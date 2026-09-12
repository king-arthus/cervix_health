import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../localization/translator.dart';
import '../../models/screening_models.dart';
import '../../services/app_data.dart';
import '../../widgets/empty_state.dart';
import '../../models/user_model.dart';
import '../patient/messaging_screen.dart';

class SpecialistDossiersScreen extends StatelessWidget {
  const SpecialistDossiersScreen({super.key});

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
    final dossiers = user == null
        ? <ScreeningRequest>[]
        : appData.requestsForSpecialist(user.id).where((d) => d.status == ScreeningStatus.oriente).toList();
    final dateFormat = DateFormat.yMMMd(appData.localeCode);

    return Scaffold(
      appBar: AppBar(title: Text(context.t('received_dossiers'))),
      body: dossiers.isEmpty
          ? EmptyState(
              icon: Icons.folder_shared_outlined,
              title: context.t('no_dossiers_yet'),
              subtitle: context.t('no_dossiers_yet_sub'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: dossiers.length,
              itemBuilder: (context, index) {
                final d = dossiers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text(d.patientName),
                    subtitle: Text('${d.hospital}\n${dateFormat.format(d.requestDate)}'),
                    isThreeLine: true,
                    trailing: Chip(
                      label: Text(
                        screeningStatusLabel(d.status, context.t),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      backgroundColor: _statusColor(d.status),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DossierReviewScreen(request: d)),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class DossierReviewScreen extends StatefulWidget {
  final ScreeningRequest request;
  const DossierReviewScreen({super.key, required this.request});

  @override
  State<DossierReviewScreen> createState() => _DossierReviewScreenState();
}

class _DossierReviewScreenState extends State<DossierReviewScreen> {
  late TextEditingController _conclusion;
  bool _saving = false;
  late bool _sharedWithPatient;

  @override
  void initState() {
    super.initState();
    _conclusion = TextEditingController(text: widget.request.conclusion ?? '');
    _sharedWithPatient = widget.request.sharedWithPatient;
  }

  Future<void> _toggleShare(bool value) async {
    setState(() => _sharedWithPatient = value);
    widget.request.sharedWithPatient = value;
    await context.read<AppData>().updateScreeningRequest(widget.request);
  }

  @override
  void dispose() {
    _conclusion.dispose();
    super.dispose();
  }

  String _resultLabel(String? key) {
    switch (key) {
      case 'positif':
        return context.t('result_positive');
      case 'negatif':
        return context.t('result_negative');
      case 'douteux':
        return context.t('result_doubtful');
      default:
        return '-';
    }
  }

  Future<void> _validate() async {
    if (_conclusion.text.trim().isEmpty) return;
    setState(() => _saving = true);
    await context
        .read<AppData>()
        .validateBySpecialist(request: widget.request, conclusion: _conclusion.text.trim());
    setState(() => _saving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.t('dossier_validated_message'))));
      Navigator.pop(context);
    }
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 130, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.request;
    final alreadyValidated = r.status == ScreeningStatus.valide;
    return Scaffold(
      appBar: AppBar(
        title: Text(r.patientName),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            tooltip: context.t('contact_patient'),
            onPressed: () {
              AppUser? patient;
              try {
                patient = context.read<AppData>().users.firstWhere((u) => u.id == r.patientId);
              } catch (_) {
                patient = null;
              }
              if (patient == null) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(context.t('patient_not_found'))));
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(peer: patient!)));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(context.t('screening_section_title'), style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            _infoRow(context.t('via_result'), _resultLabel(r.viaResult)),
            _infoRow(context.t('vili_result'), _resultLabel(r.viliResult)),
            _infoRow(context.t('observations'), (r.observations?.isNotEmpty ?? false) ? r.observations! : '-'),
            _infoRow(context.t('personal_info'), '${r.patientName} — ${r.hospital}'),
            if (r.agentName != null) _infoRow(context.t('module_screening_request'), r.agentName!),
            const Divider(height: 40),
            Text(context.t('my_conclusion'), style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            TextFormField(
              controller: _conclusion,
              maxLines: 4,
              enabled: !alreadyValidated,
              decoration:
                  InputDecoration(labelText: context.t('conclusion'), border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _sharedWithPatient,
                onChanged: _toggleShare,
                title: Text(context.t('share_details_with_patient')),
                subtitle: Text(context.t('share_details_with_patient_sub'),
                    style: Theme.of(context).textTheme.bodySmall),
              ),
            ),
            const SizedBox(height: 16),
            if (!alreadyValidated)
              ElevatedButton(
                onPressed: _saving ? null : _validate,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: Text(context.t('validate_dossier')),
              )
            else
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, color: Colors.green),
                    const SizedBox(width: 10),
                    Expanded(child: Text(context.t('dossier_already_validated'))),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
