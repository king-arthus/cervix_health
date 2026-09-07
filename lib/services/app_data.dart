import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/screening_models.dart';
import 'firebase_auth_service.dart';
import 'realtime_db_service.dart';

/// Couche de données de l'application : combine un cache local (SharedPreferences,
/// pour un affichage instantané et un usage hors-ligne) et une synchronisation
/// avec Firebase Realtime Database (pour que patientes et personnel voient les
/// mêmes données, même sur des appareils différents).
class AppData extends ChangeNotifier {
  static const _kUsers = 'ch_users';
  static const _kRequests = 'ch_requests';
  static const _kMessages = 'ch_messages';
  static const _kPosts = 'ch_posts';
  static const _kSessionUserId = 'ch_session_user_id';
  static const _kLocale = 'ch_locale';
  static const _kIdToken = 'ch_id_token';
  static const _kRefreshToken = 'ch_refresh_token';
  static const _kTokenExpiry = 'ch_token_expiry';

  final _uuid = const Uuid();
  SharedPreferences? _prefs;
  Timer? _syncTimer;

  List<AppUser> users = [];
  List<ScreeningRequest> requests = [];
  List<Message> messages = [];
  List<CommunityPost> posts = [];
  AppUser? currentUser;
  String localeCode = 'fr';

  String? _idToken;
  String? _refreshToken;
  DateTime? _tokenExpiry;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadAll();
    final savedUserId = _prefs!.getString(_kSessionUserId);
    _idToken = _prefs!.getString(_kIdToken);
    _refreshToken = _prefs!.getString(_kRefreshToken);
    final expiryStr = _prefs!.getString(_kTokenExpiry);
    _tokenExpiry = expiryStr != null ? DateTime.tryParse(expiryStr) : null;
    if (savedUserId != null) {
      try {
        currentUser = users.firstWhere((u) => u.id == savedUserId);
      } catch (_) {
        currentUser = null;
      }
    }
    localeCode = _prefs!.getString(_kLocale) ?? 'fr';
    notifyListeners();
    if (currentUser != null && _refreshToken != null) {
      _startSync();
    }
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

  // ---------------- Jeton d'accès à la base de données ----------------

  Future<void> _storeTokens(String idToken, String refreshToken, int? expiresIn) async {
    _idToken = idToken;
    _refreshToken = refreshToken;
    _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn ?? 3600));
    await _prefs?.setString(_kIdToken, idToken);
    await _prefs?.setString(_kRefreshToken, refreshToken);
    await _prefs?.setString(_kTokenExpiry, _tokenExpiry!.toIso8601String());
  }

  /// Retourne un idToken valide, en le rafraîchissant si besoin. Retourne null
  /// si l'utilisateur n'est pas connecté ou si le rafraîchissement échoue
  /// (ex. pas de connexion internet) — dans ce cas, l'app continue avec les
  /// données locales en cache.
  Future<String?> _validIdToken() async {
    if (_idToken == null || _refreshToken == null) return null;
    if (_tokenExpiry != null && DateTime.now().isBefore(_tokenExpiry!.subtract(const Duration(minutes: 5)))) {
      return _idToken;
    }
    final result = await FirebaseAuthService.refreshIdToken(_refreshToken!);
    if (!result.success || result.idToken == null || result.refreshToken == null) return null;
    await _storeTokens(result.idToken!, result.refreshToken!, result.expiresIn);
    return _idToken;
  }

  // ---------------- Authentification (Firebase Auth via API REST) ----------------

  Future<({bool success, AppUser? user, String? errorKey})> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required int age,
    required String gender,
    required String contact,
    required UserRole role,
    String? employerFacility,
    int? startYear,
    String? position,
    String? educationLevel,
    String? specialty,
  }) async {
    final result = await FirebaseAuthService.signUp(email: email, password: password);
    if (!result.success || result.uid == null || result.idToken == null || result.refreshToken == null) {
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
      role: role,
      employerFacility: employerFacility,
      startYear: startYear,
      position: position,
      educationLevel: educationLevel,
      specialty: specialty,
    );
    users.add(user);
    await _saveUsers();
    await _storeTokens(result.idToken!, result.refreshToken!, result.expiresIn);
    await _setSession(user);
    // Publie immédiatement le profil dans la base partagée.
    await RealtimeDbService.putItem('users', user.id, user.toJson(), result.idToken!);
    _startSync();
    return (success: true, user: user, errorKey: null);
  }

  Future<({bool success, AppUser? user, String? errorKey})> login(
    String email,
    String password,
    UserRole role,
  ) async {
    final result = await FirebaseAuthService.signIn(email: email, password: password);
    if (!result.success || result.uid == null || result.idToken == null || result.refreshToken == null) {
      return (success: false, user: null, errorKey: result.errorKey);
    }
    await _storeTokens(result.idToken!, result.refreshToken!, result.expiresIn);
    // Récupère les dernières données de la base partagée avant de chercher le profil local.
    await _pullRemoteData();
    AppUser? match;
    try {
      match = users.firstWhere((u) => u.id == result.uid && u.role == role);
    } catch (_) {
      match = null;
    }
    if (match == null) {
      return (success: false, user: null, errorKey: 'error_profile_not_found');
    }
    await _setSession(match);
    _startSync();
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
    _syncTimer?.cancel();
    _syncTimer = null;
    await _prefs?.remove(_kSessionUserId);
    await _prefs?.remove(_kIdToken);
    await _prefs?.remove(_kRefreshToken);
    await _prefs?.remove(_kTokenExpiry);
    _idToken = null;
    _refreshToken = null;
    _tokenExpiry = null;
    notifyListeners();
  }

  List<AppUser> get agentList => users.where((u) => u.role == UserRole.agent).toList();
  List<AppUser> get specialisteList => users.where((u) => u.role == UserRole.specialiste).toList();
  // Alias conservé pour compatibilité : les patientes recherchent des agents pour l'orientation.
  List<AppUser> get personnelList => agentList;

  Future<void> updateProfilePhoto(String? photoBase64) async {
    final user = currentUser;
    if (user == null) return;
    final updated = user.copyWithPhoto(photoBase64);
    final idx = users.indexWhere((u) => u.id == user.id);
    if (idx != -1) users[idx] = updated;
    currentUser = updated;
    await _saveUsers();
    notifyListeners();
    final token = await _validIdToken();
    if (token != null) await RealtimeDbService.putItem('users', updated.id, updated.toJson(), token);
  }

  // ---------------- Synchronisation avec la base partagée ----------------

  /// Démarre la synchronisation périodique (toutes les 15 secondes) avec
  /// Firebase Realtime Database, tant qu'un utilisateur est connecté.
  void _startSync() {
    _syncTimer?.cancel();
    _pullRemoteData();
    _syncTimer = Timer.periodic(const Duration(seconds: 15), (_) => _pullRemoteData());
  }

  /// Récupère toutes les données partagées (comptes, demandes, messages,
  /// publications) depuis la base en ligne et met à jour le cache local.
  /// Ne fait rien silencieusement en cas d'échec (pas de connexion) : l'app
  /// continue avec les dernières données connues.
  Future<void> _pullRemoteData() async {
    final token = await _validIdToken();
    if (token == null) return;

    final remoteUsers = await RealtimeDbService.getAll('users', token);
    if (remoteUsers != null) {
      users = remoteUsers.values
          .map((e) => AppUser.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      await _saveUsers();
      if (currentUser != null) {
        try {
          currentUser = users.firstWhere((u) => u.id == currentUser!.id);
        } catch (_) {}
      }
    }

    final remoteRequests = await RealtimeDbService.getAll('screening_requests', token);
    if (remoteRequests != null) {
      requests = remoteRequests.values
          .map((e) => ScreeningRequest.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      await _saveRequests();
    }

    final remoteMessages = await RealtimeDbService.getAll('messages', token);
    if (remoteMessages != null) {
      messages = remoteMessages.values
          .map((e) => Message.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      await _saveMessages();
    }

    final remotePosts = await RealtimeDbService.getAll('community_posts', token);
    if (remotePosts != null) {
      posts = remotePosts.values
          .map((e) => CommunityPost.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      await _savePosts();
    }

    notifyListeners();
  }

  /// Force une synchronisation immédiate (ex. tir manuel "pull to refresh").
  Future<void> refreshNow() => _pullRemoteData();

  // ---------------- Dépistage ----------------

  Future<ScreeningRequest> createScreeningRequest({
    required AppUser patient,
    required String hospital,
  }) async {
    final req = ScreeningRequest(
      id: _uuid.v4(),
      patientId: patient.id,
      patientName: patient.fullName,
      hospital: hospital,
      requestDate: DateTime.now(),
    );
    requests.add(req);
    await _saveRequests();
    notifyListeners();
    final token = await _validIdToken();
    if (token != null) await RealtimeDbService.putItem('screening_requests', req.id, req.toJson(), token);
    return req;
  }

  List<ScreeningRequest> requestsForPatient(String patientId) =>
      requests.where((r) => r.patientId == patientId).toList()
        ..sort((a, b) => b.requestDate.compareTo(a.requestDate));

  List<ScreeningRequest> get allRequests =>
      List<ScreeningRequest>.from(requests)..sort((a, b) => b.requestDate.compareTo(a.requestDate));

  /// Dossiers actuellement orientés vers ce spécialiste, en attente de validation ou déjà validés.
  List<ScreeningRequest> requestsForSpecialist(String specialistId) =>
      requests.where((r) => r.specialistId == specialistId).toList()
        ..sort((a, b) => b.requestDate.compareTo(a.requestDate));

  Future<void> updateScreeningRequest(ScreeningRequest updated) async {
    final idx = requests.indexWhere((r) => r.id == updated.id);
    if (idx != -1) {
      requests[idx] = updated;
      await _saveRequests();
      notifyListeners();
    }
    final token = await _validIdToken();
    if (token != null) {
      await RealtimeDbService.putItem('screening_requests', updated.id, updated.toJson(), token);
    }
  }

  /// L'agent renseigne les résultats du dépistage réalisé sur le terrain.
  Future<void> submitScreeningByAgent({
    required ScreeningRequest request,
    required AppUser agent,
    required String viaResult,
    required String viliResult,
    required String observations,
  }) async {
    request.agentId = agent.id;
    request.agentName = agent.fullName;
    request.viaResult = viaResult;
    request.viliResult = viliResult;
    request.observations = observations;
    request.status = ScreeningStatus.depiste;
    await updateScreeningRequest(request);
  }

  /// L'agent oriente le dossier vers un spécialiste pour validation.
  Future<void> referToSpecialist({
    required ScreeningRequest request,
    required AppUser specialist,
  }) async {
    request.specialistId = specialist.id;
    request.specialistName = specialist.fullName;
    request.status = ScreeningStatus.oriente;
    await updateScreeningRequest(request);
  }

  /// Le spécialiste examine le dossier et rend sa conclusion, ce qui clôt le dossier.
  Future<void> validateBySpecialist({
    required ScreeningRequest request,
    required String conclusion,
  }) async {
    request.conclusion = conclusion;
    request.validationDate = DateTime.now();
    request.status = ScreeningStatus.valide;
    await updateScreeningRequest(request);
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
    final token = await _validIdToken();
    if (token != null) await RealtimeDbService.putItem('messages', msg.id, msg.toJson(), token);
  }

  List<Message> conversation(String userA, String userB) {
    final convId = Message.conversationId(userA, userB);
    final list = messages
        .where((m) => Message.conversationId(m.senderId, m.receiverId) == convId)
        .toList();
    list.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return list;
  }

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
      AppUser? user;
      try {
        user = users.firstWhere((u) => u.id == entry.key);
      } catch (_) {
        user = null;
      }
      if (user != null) result.add(MapEntry(user, entry.value));
    }
    result.sort((a, b) => b.value.timestamp.compareTo(a.value.timestamp));
    return result;
  }

  // ---------------- Communauté ----------------

  Future<void> addPost(AppUser author, String text) async {
    final post = CommunityPost(
      id: _uuid.v4(),
      authorId: author.id,
      authorName: author.fullName,
      text: text,
      timestamp: DateTime.now(),
    );
    posts.add(post);
    await _savePosts();
    notifyListeners();
    final token = await _validIdToken();
    if (token != null) await RealtimeDbService.putItem('community_posts', post.id, post.toJson(), token);
  }

  List<CommunityPost> get sortedPosts =>
      List<CommunityPost>.from(posts)..sort((a, b) => b.timestamp.compareTo(a.timestamp));

  // ---------------- Langue ----------------

  Future<void> setLocale(String code) async {
    localeCode = code;
    await _prefs?.setString(_kLocale, code);
    notifyListeners();
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    super.dispose();
  }
}
