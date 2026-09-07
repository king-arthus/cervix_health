import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/firebase_config.dart';

/// Résultat générique d'une opération d'authentification Firebase.
/// [errorKey] correspond à une clé de traduction (voir app_strings.dart) quand success = false.
class AuthResult {
  final bool success;
  final String? uid;
  final String? errorKey;
  AuthResult({required this.success, this.uid, this.errorKey});
}

/// Appelle directement l'API REST "Identity Toolkit" de Firebase Authentication
/// (https://firebase.google.com/docs/reference/rest/auth) — pas besoin du SDK natif
/// ni de configuration Android/iOS spécifique, juste une clé API Web.
class FirebaseAuthService {
  static const _base = 'https://identitytoolkit.googleapis.com/v1/accounts';

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
      default:
        if (message != null && message.startsWith('WEAK_PASSWORD')) {
          return 'error_weak_password';
        }
        return 'generic_error';
    }
  }

  static Future<AuthResult> signUp({required String email, required String password}) async {
    try {
      final res = await http.post(
        Uri.parse('$_base:signUp?key=$firebaseWebApiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password, 'returnSecureToken': true}),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200 && data['localId'] != null) {
        return AuthResult(success: true, uid: data['localId']);
      }
      return AuthResult(success: false, errorKey: _mapError(data['error']?['message']));
    } catch (_) {
      return AuthResult(success: false, errorKey: 'generic_error');
    }
  }

  static Future<AuthResult> signIn({required String email, required String password}) async {
    try {
      final res = await http.post(
        Uri.parse('$_base:signInWithPassword?key=$firebaseWebApiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password, 'returnSecureToken': true}),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200 && data['localId'] != null) {
        return AuthResult(success: true, uid: data['localId']);
      }
      return AuthResult(success: false, errorKey: _mapError(data['error']?['message']));
    } catch (_) {
      return AuthResult(success: false, errorKey: 'generic_error');
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
      return AuthResult(success: false, errorKey: _mapError(data['error']?['message']));
    } catch (_) {
      return AuthResult(success: false, errorKey: 'generic_error');
    }
  }
}
