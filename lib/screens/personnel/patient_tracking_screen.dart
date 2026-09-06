import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../localization/translator.dart';
import '../../models/screening_models.dart';
import '../../services/app_data.dart';
import 'screening_requests_screen.dart';

/// Vue de suivi centrée sur les patientes déjà dépistées ou planifiées
/// (technique utilisée, résultat obtenu, date du prochain rendez-vous).
class PatientTrackingScreen extends StatelessWidget {
  const PatientTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appData = context.watch<AppData>();
    final tracked = appData.allRequests
        .where((r) => r.status == ScreeningStatus.realise || r.status == ScreeningStatus.planifie)
        .toList();
    final dateFormat = DateFormat.yMMMd(appData.localeCode);

    return Scaffold(
      appBar: AppBar(title: Text(context.t('patient_tracking'))),
      body: tracked.isEmpty
          ? Center(child: Text(context.t('no_requests_yet')))
          : ListView.builder(
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
                        Text(r.patientName, style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text(r.hospital),
                        if (r.techniqueUsed != null && r.techniqueUsed!.isNotEmpty)
                          Text('${context.t('technique_used')} : ${r.techniqueUsed}'),
                        if (r.result != null && r.result!.isNotEmpty)
                          Text('${context.t('result_label')} : ${r.result}'),
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
    );
  }
}
