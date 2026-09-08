import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

/// Gère les notifications locales (rappels de rendez-vous de dépistage).
/// Fonctionne entièrement sur l'appareil, sans backend — chaque appareil
/// programme ses propres rappels à partir des données qu'il a localement.
class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    tzdata.initializeTimeZones();
    try {
      // Tchad et Cameroun partagent le même fuseau horaire (UTC+1, sans heure d'été).
      tz.setLocalLocation(tz.getLocation('Africa/Ndjamena'));
    } catch (_) {
      // En cas d'échec (base de données de fuseaux incomplète), on continue avec le fuseau par défaut.
    }
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    try {
      await _plugin.initialize(initSettings);
    } catch (_) {
      // Ne bloque jamais le démarrage de l'app si les notifications échouent à s'initialiser.
    }
    _initialized = true;
  }

  static Future<void> requestPermission() async {
    try {
      final androidImpl =
          _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      await androidImpl?.requestNotificationsPermission();
    } catch (_) {}
  }

  /// Programme un rappel la veille du rendez-vous, à 9h heure locale.
  /// Si cette heure est déjà passée, aucun rappel n'est programmé.
  static Future<void> scheduleAppointmentReminder({
    required int id,
    required String title,
    required String body,
    required DateTime appointmentDate,
  }) async {
    final reminderTime =
        DateTime(appointmentDate.year, appointmentDate.month, appointmentDate.day - 1, 9, 0);
    if (reminderTime.isBefore(DateTime.now())) return;

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'appointment_reminders',
        'Rappels de rendez-vous',
        channelDescription: 'Rappels pour les rendez-vous de dépistage',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
    try {
      final scheduled = tz.TZDateTime.from(reminderTime, tz.local);
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        scheduled,
        details,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    } catch (_) {
      // Si la permission n'a pas été accordée ou toute autre erreur : on n'interrompt pas l'app.
    }
  }

  static Future<void> cancel(int id) async {
    try {
      await _plugin.cancel(id);
    } catch (_) {}
  }
}
