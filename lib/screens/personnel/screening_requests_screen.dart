import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../localization/translator.dart';
import '../../models/screening_models.dart';
import '../../models/user_model.dart';
import '../../services/app_data.dart';
import '../../widgets/empty_state.dart';
import '../patient/messaging_screen.dart';

class ScreeningRequestsScreen extends StatelessWidget {
  const ScreeningRequestsScreen({super.key});

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
    final requests = appData.allRequests;
    final dateFormat = DateFormat.yMMMd(appData.localeCode);

    return Scaffold(
      appBar: AppBar(title: Text(context.t('screening_requests_received'))),
      body: requests.isEmpty
          ? EmptyState(
              icon: Icons.assignment_outlined,
              title: context.t('no_screening_requests'),
              subtitle: context.t('no_screening_requests_sub'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final r = requests[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text(r.patientName),
                    subtitle: Text('${r.hospital}\n${dateFormat.format(r.requestDate)}'),
                    isThreeLine: true,
                    trailing: Chip(
                      label: Text(
                        screeningStatusLabel(r.status, context.t),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      backgroundColor: _statusColor(r.status),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ScreeningRequestDetailScreen(request: r)),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class ScreeningRequestDetailScreen extends StatefulWidget {
  final ScreeningRequest request;
  const ScreeningRequestDetailScreen({super.key, required this.request});

  @override
  State<ScreeningRequestDetailScreen> createState() => _ScreeningRequestDetailScreenState();
}

class _ScreeningRequestDetailScreenState extends State<ScreeningRequestDetailScreen> {
  late TextEditingController _observations;
  late TextEditingController _conclusion;
  String? _viaResult;
  String? _viliResult;
  String? _selectedSpecialistId;
  DateTime? _nextAppointment;
  bool _saving = false;
  late bool _sharedWithPatient;

  static const _resultOptions = ['positif', 'negatif', 'douteux'];

  @override
  void initState() {
    super.initState();
    _observations = TextEditingController(text: widget.request.observations ?? '');
    _conclusion = TextEditingController(text: widget.request.conclusion ?? '');
    _viaResult = widget.request.viaResult;
    _viliResult = widget.request.viliResult;
    _selectedSpecialistId = widget.request.specialistId;
    _nextAppointment = widget.request.nextAppointmentDate;
    _sharedWithPatient = widget.request.sharedWithPatient;
  }

  Future<void> _toggleShare(bool value) async {
    setState(() => _sharedWithPatient = value);
    widget.request.sharedWithPatient = value;
    await context.read<AppData>().updateScreeningRequest(widget.request);
  }

  @override
  void dispose() {
    _observations.dispose();
    _conclusion.dispose();
    super.dispose();
  }

  String _resultLabel(String key) {
    switch (key) {
      case 'positif':
        return context.t('result_positive');
      case 'negatif':
        return context.t('result_negative');
      default:
        return context.t('result_doubtful');
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _nextAppointment ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) setState(() => _nextAppointment = picked);
  }

  Future<void> _saveScreening() async {
    if (_viaResult == null || _viliResult == null) return;
    setState(() => _saving = true);
    final appData = context.read<AppData>();
    final agent = appData.currentUser;
    if (agent == null) return;
    widget.request.nextAppointmentDate = _nextAppointment;
    await appData.submitScreeningByAgent(
      request: widget.request,
      agent: agent,
      viaResult: _viaResult!,
      viliResult: _viliResult!,
      observations: _observations.text.trim(),
    );
    setState(() => _saving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.t('screening_saved'))));
    }
  }

  Future<void> _refer() async {
    if (_selectedSpecialistId == null) return;
    final appData = context.read<AppData>();
    AppUser? specialist;
    try {
      specialist = appData.specialisteList.firstWhere((s) => s.id == _selectedSpecialistId);
    } catch (_) {
      specialist = null;
    }
    if (specialist == null) return;
    setState(() => _saving = true);
    await appData.referToSpecialist(request: widget.request, specialist: specialist);
    setState(() => _saving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.t('referred_to_specialist'))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final appData = context.watch<AppData>();
    final dateFormat = DateFormat.yMMMd(appData.localeCode);
    final specialists = appData.specialisteList;
    final canRefer = widget.request.status == ScreeningStatus.depiste ||
        widget.request.status == ScreeningStatus.oriente;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.request.patientName),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            tooltip: context.t('contact_patient'),
            onPressed: () {
              AppUser? patient;
              try {
                patient = context.read<AppData>().users.firstWhere((u) => u.id == widget.request.patientId);
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
            Text(widget.request.hospital, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Chip(label: Text(screeningStatusLabel(widget.request.status, context.t))),
            const SizedBox(height: 20),

            Text(context.t('screening_section_title'), style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _viaResult,
              decoration: InputDecoration(labelText: context.t('via_result'), border: const OutlineInputBorder()),
              items: _resultOptions
                  .map((r) => DropdownMenuItem(value: r, child: Text(_resultLabel(r))))
                  .toList(),
              onChanged: (v) => setState(() => _viaResult = v),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _viliResult,
              decoration: InputDecoration(labelText: context.t('vili_result'), border: const OutlineInputBorder()),
              items: _resultOptions
                  .map((r) => DropdownMenuItem(value: r, child: Text(_resultLabel(r))))
                  .toList(),
              onChanged: (v) => setState(() => _viliResult = v),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _observations,
              maxLines: 3,
              decoration:
                  InputDecoration(labelText: context.t('observations'), border: const OutlineInputBorder()),
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
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.t('next_appointment')),
              subtitle: Text(_nextAppointment != null ? dateFormat.format(_nextAppointment!) : '-'),
              trailing: const Icon(Icons.calendar_month),
              onTap: _pickDate,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: (_viaResult == null || _viliResult == null || _saving) ? null : _saveScreening,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: Text(context.t('save')),
            ),

            const Divider(height: 40),

            Text(context.t('refer_to_specialist'), style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            if (specialists.isEmpty)
              Text(context.t('no_specialist_available'))
            else ...[
              DropdownButtonFormField<String>(
                value: _selectedSpecialistId,
                decoration:
                    InputDecoration(labelText: context.t('select_specialist'), border: const OutlineInputBorder()),
                items: specialists
                    .map((s) => DropdownMenuItem(
                        value: s.id, child: Text('${s.fullName}${s.specialty != null ? " — ${s.specialty}" : ""}')))
                    .toList(),
                onChanged: canRefer ? (v) => setState(() => _selectedSpecialistId = v) : null,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: (!canRefer || _selectedSpecialistId == null || _saving) ? null : _refer,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: Text(context.t('refer_to_specialist')),
              ),
            ],

            if (widget.request.conclusion != null && widget.request.conclusion!.isNotEmpty) ...[
              const Divider(height: 40),
              Text(context.t('specialist_conclusion'), style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(widget.request.conclusion!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
