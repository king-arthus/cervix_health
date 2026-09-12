import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../localization/translator.dart';
import '../../models/screening_models.dart';
import '../../services/app_data.dart';
import '../../services/notification_service.dart';
import '../../widgets/empty_state.dart';

class ScreeningTrackingScreen extends StatefulWidget {
  const ScreeningTrackingScreen({super.key});

  @override
  State<ScreeningTrackingScreen> createState() => _ScreeningTrackingScreenState();
}

class _ScreeningTrackingScreenState extends State<ScreeningTrackingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scheduleReminders());
  }

  /// Programme (ou reprogramme) un rappel local pour chaque rendez-vous à venir.
  /// Idempotent : appeler plusieurs fois avec les mêmes données ne crée pas de doublons.
  void _scheduleReminders() {
    final appData = context.read<AppData>();
    final user = appData.currentUser;
    if (user == null) return;
    final requests = appData.requestsForPatient(user.id);
    final now = DateTime.now();
    for (final r in requests) {
      final appointment = r.nextAppointmentDate;
      if (appointment == null) continue;
      if (r.status == ScreeningStatus.annule) continue;
      if (appointment.isBefore(now)) continue;
      NotificationService.scheduleAppointmentReminder(
        id: r.id.hashCode,
        title: context.tNoWatch('appointment_reminder_title'),
        body: '${context.tNoWatch('appointment_reminder_body_prefix')} ${r.hospital}',
        appointmentDate: appointment,
      );
    }
  }

  Color _statusColor(ScreeningStatus status) {
    switch (status) {
      case ScreeningStatus.enAttente:
        return Colors.orange;
      case ScreeningStatus.planifie:
        return Colors.blue;
      case ScreeningStatus.depiste:
        return Colors.purple;
      case ScreeningStatus.oriente:
        return Colors.teal;
      case ScreeningStatus.valide:
        return Colors.green;
      case ScreeningStatus.annule:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appData = context.watch<AppData>();
    final user = appData.currentUser;
    final requests = user == null ? <ScreeningRequest>[] : appData.requestsForPatient(user.id);
    final dateFormat = DateFormat.yMMMd(appData.localeCode);

    return Scaffold(
      appBar: AppBar(title: Text(context.t('tracking_title'))),
      body: requests.isEmpty
          ? EmptyState(
              icon: Icons.timeline_outlined,
              title: context.t('no_requests_yet'),
              subtitle: context.t('no_requests_yet_sub'),
            )
          : RefreshIndicator(
              onRefresh: appData.refreshNow,
              child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final r = requests[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(r.hospital, style: Theme.of(context).textTheme.titleMedium),
                            ),
                            Chip(
                              label: Text(
                                screeningStatusLabel(r.status, context.t),
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                              backgroundColor: _statusColor(r.status),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text('${context.t('date_label')} : ${dateFormat.format(r.requestDate)}'),
                        if (r.sharedWithPatient) ...[
                          if (r.viaResult != null) Text('VIA : ${r.viaResult}'),
                          if (r.viliResult != null) Text('VILI : ${r.viliResult}'),
                          if (r.conclusion != null && r.conclusion!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text('${context.t('specialist_conclusion')} : ${r.conclusion}'),
                              ),
                            ),
                        ] else if (r.status == ScreeningStatus.depiste ||
                            r.status == ScreeningStatus.oriente ||
                            r.status == ScreeningStatus.valide)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              context.t('clinical_details_confidential'),
                              style: TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                            ),
                          ),
                        if (r.nextAppointmentDate != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              children: [
                                const Icon(Icons.notifications_active_outlined, size: 16, color: Colors.deepPurple),
                                const SizedBox(width: 6),
                                Text(
                                  '${context.t('next_appointment')} : ${dateFormat.format(r.nextAppointmentDate!)}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            ),
    );
  }
}
