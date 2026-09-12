import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../localization/translator.dart';
import '../../models/screening_models.dart';
import '../../services/app_data.dart';
import '../../widgets/empty_state.dart';
import 'specialist_dossiers_screen.dart';

/// Vue de suivi globale, côté spécialiste, de tous les dossiers qui lui ont
/// été confiés au fil du temps — qu'ils soient encore en attente de
/// validation ou déjà validés.
class SpecialistTrackingScreen extends StatelessWidget {
  const SpecialistTrackingScreen({super.key});

  Color _statusColor(ScreeningStatus status) {
    switch (status) {
      case ScreeningStatus.oriente:
        return Colors.teal;
      case ScreeningStatus.valide:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appData = context.watch<AppData>();
    final user = appData.currentUser;
    final dossiers = user == null ? <ScreeningRequest>[] : appData.requestsForSpecialist(user.id);
    final dateFormat = DateFormat.yMMMd(appData.localeCode);

    return Scaffold(
      appBar: AppBar(title: Text(context.t('specialist_tracking_title'))),
      body: dossiers.isEmpty
          ? EmptyState(
              icon: Icons.timeline_outlined,
              title: context.t('no_dossiers_yet'),
              subtitle: context.t('no_dossiers_yet_sub'),
            )
          : RefreshIndicator(
              onRefresh: appData.refreshNow,
              child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: dossiers.length,
              itemBuilder: (context, index) {
                final d = dossiers[index];
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
                              child: Text(d.patientName, style: Theme.of(context).textTheme.titleMedium),
                            ),
                            Chip(
                              label: Text(
                                screeningStatusLabel(d.status, context.t),
                                style: const TextStyle(color: Colors.white, fontSize: 11),
                              ),
                              backgroundColor: _statusColor(d.status),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(d.hospital),
                        Text('${context.t('date_label')} : ${dateFormat.format(d.requestDate)}'),
                        if (d.agentName != null) Text('${context.t('module_screening_request')} : ${d.agentName}'),
                        if (d.viaResult != null) Text('VIA : ${d.viaResult}'),
                        if (d.viliResult != null) Text('VILI : ${d.viliResult}'),
                        if (d.conclusion != null && d.conclusion!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text('${context.t('specialist_conclusion')} : ${d.conclusion}'),
                            ),
                          ),
                        if (d.status != ScreeningStatus.valide)
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => DossierReviewScreen(request: d)),
                              ),
                              child: Text(context.t('my_conclusion')),
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
