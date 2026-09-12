import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../localization/translator.dart';
import '../../models/screening_models.dart';
import '../../services/app_data.dart';
import '../../widgets/empty_state.dart';
import 'screening_requests_screen.dart';

/// Vue de suivi centrée sur les patientes déjà dépistées, orientées ou dont
/// le dossier a été validé par un spécialiste.
class PatientTrackingScreen extends StatelessWidget {
  const PatientTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appData = context.watch<AppData>();
    final tracked = appData.allRequests
        .where((r) =>
            r.status == ScreeningStatus.depiste ||
            r.status == ScreeningStatus.oriente ||
            r.status == ScreeningStatus.valide ||
            r.status == ScreeningStatus.planifie)
        .toList();
    final dateFormat = DateFormat.yMMMd(appData.localeCode);

    return Scaffold(
      appBar: AppBar(title: Text(context.t('patient_tracking'))),
      body: tracked.isEmpty
          ? EmptyState(
              icon: Icons.medical_information_outlined,
              title: context.t('no_requests_yet'),
              subtitle: context.t('no_requests_yet_sub'),
            )
          : RefreshIndicator(
              onRefresh: appData.refreshNow,
              child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: tracked.length,
              itemBuilder: (context, index) {
                final r = tracked[index];
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
                              child: Text(r.patientName, style: Theme.of(context).textTheme.titleMedium),
                            ),
                            Chip(
                              label: Text(screeningStatusLabel(r.status, context.t),
                                  style: const TextStyle(fontSize: 11)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(r.hospital),
                        if (r.viaResult != null) Text('VIA : ${r.viaResult}'),
                        if (r.viliResult != null) Text('VILI : ${r.viliResult}'),
                        if (r.specialistName != null)
                          Text('${context.t('select_specialist')} : ${r.specialistName}'),
                        if (r.conclusion != null && r.conclusion!.isNotEmpty)
                          Text('${context.t('specialist_conclusion')} : ${r.conclusion}'),
                        if (r.nextAppointmentDate != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              '${context.t('next_appointment')} : ${dateFormat.format(r.nextAppointmentDate!)}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => ScreeningRequestDetailScreen(request: r)),
                            ),
                            child: Text(context.t('update_request')),
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
