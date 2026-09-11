import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/firebase_config.dart';

/// Résultat générique d'une opération d'authentification Firebase.
/// [errorKey] correspond à une clé de traduction (voir app_strings.dart) quand success = false.
/// [debugMessage] contient le code d'erreur brut renvoyé par Firebase (ou l'exception
/// technique), utile pour diagnostiquer les cas non reconnus par [errorKey].
class AuthResult {
  final bool success;
  final String? uid;
  final String? idToken;
  final String? refreshToken;
  final int? expiresInSeconds;
  final String? errorKey;
  final String? debugMessage;
  AuthResult({
    required this.success,
    this.uid,
    this.idToken,
    this.refreshToken,
    this.expiresInSeconds,
    this.errorKey,
    this.debugMessage,
  });
}

/// Appelle directement les API REST de Firebase Authentication
/// (https://firebase.google.com/docs/reference/rest/auth) — pas besoin du SDK natif
/// ni de configuration Android/iOS spécifique, juste une clé API Web.
class FirebaseAuthService {
  static const _base = 'https://identitytoolkit.googleapis.com/v1/accounts';
  static const _tokenBase = 'https://securetoken.googleapis.com/v1/token';

  static String _mapError(String? message) {
    switch (message) {
      case 'EMAIL_EXISTS':
        return 'error_email_in_use';
      case 'EMAIL_NOT_FOUND':
        return 'error_email_not_found';
      case 'INVALID_PASSWORD':
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'error_wrong_password';
      case 'INVALID_EMAIL':
        return 'error_invalid_email';
      case 'OPERATION_NOT_ALLOWED':
        return 'error_email_auth_disabled';
      default:
        if (message != null && message.startsWith('WEAK_PASSWORD')) {
          return 'error_weak_password';
        }
        return 'generic_error';
    }
  }

  static AuthResult _fromResponse(int statusCode, dynamic rawBody) {
    Map<String, dynamic> data;
    try {
      data = rawBody is String ? jsonDecode(rawBody) : rawBody;
    } catch (_) {
      return AuthResult(
        success: false,
        errorKey: 'generic_error',
        debugMessage: 'HTTP $statusCode — réponse illisible : $rawBody',
      );
    }
    if (statusCode == 200 && data['localId'] != null) {
      return AuthResult(
        success: true,
        uid: data['localId'],
        idToken: data['idToken'],
        refreshToken: data['refreshToken'],
        expiresInSeconds: int.tryParse(data['expiresIn']?.toString() ?? ''),
      );
    }
    final rawMessage = data['error']?['message']?.toString();
    return AuthResult(
      success: false,
      errorKey: _mapError(rawMessage),
      debugMessage: 'HTTP $statusCode — ${rawMessage ?? data.toString()}',
    );
  }

  static Future<AuthResult> signUp({required String email, required String password}) async {
    try {
      final res = await http.post(
        Uri.parse('$_base:signUp?key=$firebaseWebApiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password, 'returnSecureToken': true}),
      );
      return _fromResponse(res.statusCode, res.body);
    } catch (e) {
      return AuthResult(success: false, errorKey: 'generic_error', debugMessage: 'Exception : $e');
    }
  }

  static Future<AuthResult> signIn({required String email, required String password}) async {
    try {
      final res = await http.post(
        Uri.parse('$_base:signInWithPassword?key=$firebaseWebApiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password, 'returnSecureToken': true}),
      );
      return _fromResponse(res.statusCode, res.body);
    } catch (e) {
      return AuthResult(success: false, errorKey: 'generic_error', debugMessage: 'Exception : $e');
    }
  }

  /// Envoie un e-mail de réinitialisation de mot de passe à l'adresse donnée.
  static Future<AuthResult> sendPasswordResetEmail(String email) async {
    try {
      final res = await http.post(
        Uri.parse('$_base:sendOobCode?key=$firebaseWebApiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'requestType': 'PASSWORD_RESET', 'email': email}),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return AuthResult(success: true);
      }
      final rawMessage = data['error']?['message']?.toString();
      return AuthResult(
        success: false,
        errorKey: _mapError(rawMessage),
        debugMessage: 'HTTP ${res.statusCode} — ${rawMessage ?? data.toString()}',
      );
    } catch (e) {
      return AuthResult(success: false, errorKey: 'generic_error', debugMessage: 'Exception : $e');
    }
  }

  /// Envoie un e-mail de vérification à l'adresse du compte actuellement connecté.
  static Future<AuthResult> sendEmailVerification(String idToken) async {
    try {
      final res = await http.post(
        Uri.parse('$_base:sendOobCode?key=$firebaseWebApiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'requestType': 'VERIFY_EMAIL', 'idToken': idToken}),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return AuthResult(success: true);
      }
      final rawMessage = data['error']?['message']?.toString();
      return AuthResult(
        success: false,
        errorKey: _mapError(rawMessage),
        debugMessage: 'HTTP ${res.statusCode} — ${rawMessage ?? data.toString()}',
      );
    } catch (e) {
      return AuthResult(success: false, errorKey: 'generic_error', debugMessage: 'Exception : $e');
    }
  }

  /// Récupère les informations du compte (dont le statut de vérification de l'e-mail).
  static Future<bool?> isEmailVerified(String idToken) async {
    try {
      final res = await http.post(
        Uri.parse('$_base:lookup?key=$firebaseWebApiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      );
      if (res.statusCode != 200) return null;
      final data = jsonDecode(res.body);
      final users = data['users'] as List?;
      if (users == null || users.isEmpty) return null;
      return users.first['emailVerified'] == true;
    } catch (_) {
      return null;
    }
  }

  /// Utilise le refresh token pour obtenir un nouveau idToken valide
  /// (les idToken Firebase expirent au bout d'une heure).
  static Future<AuthResult> refreshIdToken(String refreshToken) async {
    try {
      final res = await http.post(
        Uri.parse('$_tokenBase?key=$firebaseWebApiKey'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'grant_type': 'refresh_token', 'refresh_token': refreshToken},
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200 && data['id_token'] != null) {
        return AuthResult(
          success: true,
          uid: data['user_id'],
          idToken: data['id_token'],
          refreshToken: data['refresh_token'],
          expiresInSeconds: int.tryParse(data['expires_in']?.toString() ?? ''),
        );
      }
      return AuthResult(success: false, errorKey: 'generic_error', debugMessage: data.toString());
    } catch (e) {
      return AuthResult(success: false, errorKey: 'generic_error', debugMessage: 'Exception : $e');
    }
  }
}
