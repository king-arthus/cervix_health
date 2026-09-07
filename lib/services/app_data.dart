import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/screening_models.dart';
import 'firebase_auth_service.dart';

/// Couche de persistance légère basée sur SharedPreferences.
/// À remplacer par un vrai backend (Firebase, Supabase, API REST...) en production :
/// la messagerie et les comptes doivent être synchronisés côté serveur pour un usage multi-appareil.
class AppData extends ChangeNotifier {
  static const _kUsers = 'ch_users';
  static const _kRequests = 'ch_requests';
  static const _kMessages = 'ch_messages';
  static const _kPosts = 'ch_posts';
  static const _kSessionUserId = 'ch_session_user_id';
  static const _kLocale = 'ch_locale';

  final _uuid = const Uuid();
  SharedPreferences? _prefs;

  List<AppUser> users = [];
  List<ScreeningRequest> requests = [];
  List<Message> messages = [];
  List<CommunityPost> posts = [];
  AppUser? currentUser;
  String localeCode = 'fr';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadAll();
    final savedUserId = _prefs!.getString(_kSessionUserId);
    if (savedUserId != null) {
      try {
        currentUser = users.firstWhere((u) => u.id == savedUserId);
      } catch (_) {
        currentUser = null;
      }
    }
    localeCode = _prefs!.getString(_kLocale) ?? 'fr';
    notifyListeners();
  }

  void _loadAll() {
    users = _readList(_kUsers).map((e) => AppUser.fromJson(e)).toList();
    requests = _readList(_kRequests).map((e) => ScreeningRequest.fromJson(e)).toList();
    messages = _readList(_kMessages).map((e) => Message.fromJson(e)).toList();
    posts = _readList(_kPosts).map((e) => CommunityPost.fromJson(e)).toList();
  }

  List<Map<String, dynamic>> _readList(String key) {
    final raw = _prefs?.getString(key);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.cast<Map<String, dynamic>>();
  }

  Future<void> _saveUsers() async =>
      _prefs?.setString(_kUsers, jsonEncode(users.map((e) => e.toJson()).toList()));
  Future<void> _saveRequests() async =>
      _prefs?.setString(_kRequests, jsonEncode(requests.map((e) => e.toJson()).toList()));
  Future<void> _saveMessages() async =>
      _prefs?.setString(_kMessages, jsonEncode(messages.map((e) => e.toJson()).toList()));
  Future<void> _savePosts() async =>
      _prefs?.setString(_kPosts, jsonEncode(posts.map((e) => e.toJson()).toList()));

  // ---------------- Authentification (Firebase Auth via API REST) ----------------

  Future<({bool success, AppUser? user, String? errorKey})> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required int age,
    required String gender,
    required String contact,
    required ProfileType profileType,
    String? employerFacility,
    int? startYear,
    String? position,
    String? educationLevel,
  }) async {
    final result = await FirebaseAuthService.signUp(email: email, password: password);
    if (!result.success || result.uid == null) {
      return (success: false, user: null, errorKey: result.errorKey);
    }
    final user = AppUser(
      id: result.uid!,
      email: email,
      firstName: firstName,
      lastName: lastName,
      age: age,
      gender: gender,
      contact: contact,
      profileType: profileType,
      employerFacility: employerFacility,
      startYear: startYear,
      position: position,
      educationLevel: educationLevel,
    );
    users.add(user);
    await _saveUsers();
    await _setSession(user);
    return (success: true, user: user, errorKey: null);
  }

  /// Connecte l'utilisateur via Firebase Auth, puis retrouve (ou crée si absent
  /// localement, ex. nouvel appareil) son profil dans le stockage local.
  Future<({bool success, AppUser? user, String? errorKey})> login(
    String email,
    String password,
    ProfileType type,
  ) async {
    final result = await FirebaseAuthService.signIn(email: email, password: password);
    if (!result.success || result.uid == null) {
      return (success: false, user: null, errorKey: result.errorKey);
    }
    AppUser? match;
    try {
      match = users.firstWhere((u) => u.id == result.uid && u.profileType == type);
    } catch (_) {
      match = null;
    }
    if (match == null) {
      // Le compte existe côté Firebase mais pas encore de profil local pour ce type
      // (ex. connexion depuis un nouvel appareil) : on ne peut pas deviner ses informations.
      return (success: false, user: null, errorKey: 'error_profile_not_found');
    }
    await _setSession(match);
    return (success: true, user: match, errorKey: null);
  }

  Future<({bool success, String? errorKey})> sendPasswordResetEmail(String email) async {
    final result = await FirebaseAuthService.sendPasswordResetEmail(email);
    return (success: result.success, errorKey: result.errorKey);
  }

  Future<void> _setSession(AppUser user) async {
    currentUser = user;
    await _prefs?.setString(_kSessionUserId, user.id);
    notifyListeners();
  }

  Future<void> logout() async {
    currentUser = null;
    await _prefs?.remove(_kSessionUserId);
    notifyListeners();
  }

  List<AppUser> get personnelList => users.where((u) => u.profileType == ProfileType.personnel).toList();

  /// Met à jour la photo de profil (encodée en base64) de l'utilisateur courant.
  /// Passer `null` pour retirer la photo.
  Future<void> updateProfilePhoto(String? photoBase64) async {
    final user = currentUser;
    if (user == null) return;
    final updated = user.copyWithPhoto(photoBase64);
    final idx = users.indexWhere((u) => u.id == user.id);
    if (idx != -1) users[idx] = updated;
    currentUser = updated;
    await _saveUsers();
    notifyListeners();
  }

  // ---------------- Dépistage ----------------

  Future<ScreeningRequest> createScreeningRequest({
    required AppUser patient,
    required String hospital,
    String? assignedPersonnelId,
  }) async {
    final req = ScreeningRequest(
      id: _uuid.v4(),
      patientId: patient.id,
      patientName: patient.fullName,
      hospital: hospital,
      assignedPersonnelId: assignedPersonnelId,
      requestDate: DateTime.now(),
    );
    requests.add(req);
    await _saveRequests();
    notifyListeners();
    return req;
  }

  List<ScreeningRequest> requestsForPatient(String patientId) =>
      requests.where((r) => r.patientId == patientId).toList()
        ..sort((a, b) => b.requestDate.compareTo(a.requestDate));

  List<ScreeningRequest> get allRequests =>
      List<ScreeningRequest>.from(requests)..sort((a, b) => b.requestDate.compareTo(a.requestDate));

  Future<void> updateScreeningRequest(ScreeningRequest updated) async {
    final idx = requests.indexWhere((r) => r.id == updated.id);
    if (idx != -1) {
      requests[idx] = updated;
      await _saveRequests();
      notifyListeners();
    }
  }

  // ---------------- Messagerie ----------------

  Future<void> sendMessage({
    required AppUser sender,
    required String receiverId,
    required String text,
  }) async {
    final msg = Message(
      id: _uuid.v4(),
      senderId: sender.id,
      senderName: sender.fullName,
      receiverId: receiverId,
      text: text,
      timestamp: DateTime.now(),
    );
    messages.add(msg);
    await _saveMessages();
    notifyListeners();
  }

  List<Message> conversation(String userA, String userB) {
    final convId = Message.conversationId(userA, userB);
    final list = messages
        .where((m) => Message.conversationId(m.senderId, m.receiverId) == convId)
        .toList();
    list.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return list;
  }

  /// Liste des interlocuteurs distincts pour un utilisateur donné, avec le dernier message.
  List<MapEntry<AppUser, Message>> conversationsFor(String userId) {
    final Map<String, Message> lastByPartner = {};
    for (final m in messages) {
      String? partnerId;
      if (m.senderId == userId) {
        partnerId = m.receiverId;
      } else if (m.receiverId == userId) {
        partnerId = m.senderId;
      }
      if (partnerId == null) continue;
      final existing = lastByPartner[partnerId];
      if (existing == null || m.timestamp.isAfter(existing.timestamp)) {
        lastByPartner[partnerId] = m;
      }
    }
    final result = <MapEntry<AppUser, Message>>[];
    for (final entry in lastByPartner.entries) {
      final user = users.where((u) => u.id == entry.key).cast<AppUser?>().firstWhere(
            (u) => u != null,
            orElse: () => null,
          );
      if (user != null) result.add(MapEntry(user, entry.value));
    }
    result.sort((a, b) => b.value.timestamp.compareTo(a.value.timestamp));
    return result;
  }

  // ---------------- Communauté ----------------

  Future<void> addPost(AppUser author, String text) async {
    posts.add(CommunityPost(
      id: _uuid.v4(),
      authorId: author.id,
      authorName: author.fullName,
      text: text,
      timestamp: DateTime.now(),
    ));
    await _savePosts();
    notifyListeners();
  }

  List<CommunityPost> get sortedPosts =>
      List<CommunityPost>.from(posts)..sort((a, b) => b.timestamp.compareTo(a.timestamp));

  // ---------------- Langue ----------------

  Future<void> setLocale(String code) async {
    localeCode = code;
    await _prefs?.setString(_kLocale, code);
    notifyListeners();
  }
}
