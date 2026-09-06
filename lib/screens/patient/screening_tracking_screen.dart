import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../localization/translator.dart';
import '../../models/screening_models.dart';
import '../../services/app_data.dart';

class ScreeningTrackingScreen extends StatelessWidget {
  const ScreeningTrackingScreen({super.key});

  Color _statusColor(ScreeningStatus status) {
    switch (status) {
      case ScreeningStatus.enAttente:
        return Colors.orange;
      case ScreeningStatus.planifie:
        return Colors.blue;
      case ScreeningStatus.realise:
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
          ? Center(child: Text(context.t('no_requests_yet')))
          : ListView.builder(
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
                        if (r.techniqueUsed != null && r.techniqueUsed!.isNotEmpty)
                          Text('${context.t('technique_used')} : ${r.techniqueUsed}'),
                        if (r.result != null && r.result!.isNotEmpty)
                          Text('${context.t('result_label')} : ${r.result}'),
                        if (r.nextAppointmentDate != null)
                          Text(
                            '${context.t('next_appointment')} : ${dateFormat.format(r.nextAppointmentDate!)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
