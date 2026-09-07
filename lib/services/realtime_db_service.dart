import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/firebase_config.dart';

/// Accès à Firebase Realtime Database via son API REST (GET/PUT en JSON).
/// Aucun SDK natif requis : de simples requêtes HTTPS, authentifiées avec
/// le jeton (idToken) de l'utilisateur connecté.
class RealtimeDbService {
  /// Récupère un nœud unique (ex. "users/UID123"), ou null si absent/échec.
  static Future<Map<String, dynamic>?> getItem(String path, String idToken) async {
    try {
      final uri = Uri.parse('$firebaseDatabaseUrl/$path.json?auth=$idToken');
      final res = await http.get(uri);
      if (res.statusCode != 200 || res.body == 'null') return null;
      final decoded = jsonDecode(res.body);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Récupère toute une collection (ex. "screeningRequests") sous forme de
  /// Map { id: données }, ou null en cas d'échec (pas de connexion, etc.).
  static Future<Map<String, dynamic>?> getAll(String collection, String idToken) async {
    try {
      final uri = Uri.parse('$firebaseDatabaseUrl/$collection.json?auth=$idToken');
      final res = await http.get(uri);
      if (res.statusCode != 200) return null;
      if (res.body == 'null') return {};
      final decoded = jsonDecode(res.body);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
      return {};
    } catch (_) {
      return null;
    }
  }

  /// Écrit (ou remplace) un élément unique dans une collection.
  static Future<bool> putItem(
    String collection,
    String id,
    Map<String, dynamic> data,
    String idToken,
  ) async {
    try {
      final uri = Uri.parse('$firebaseDatabaseUrl/$collection/$id.json?auth=$idToken');
      final res = await http.put(uri, body: jsonEncode(data));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
