import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../localization/translator.dart';
import '../../models/screening_models.dart';
import '../../services/app_data.dart';

import '../../widgets/empty_state.dart';

class ScreeningRequestsScreen extends StatelessWidget {
  const ScreeningRequestsScreen({super.key});

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
  late ScreeningStatus _status;
  late TextEditingController _technique;
  late TextEditingController _result;
  DateTime? _nextAppointment;

  @override
  void initState() {
    super.initState();
    _status = widget.request.status;
    _technique = TextEditingController(text: widget.request.techniqueUsed ?? '');
    _result = TextEditingController(text: widget.request.result ?? '');
    _nextAppointment = widget.request.nextAppointmentDate;
  }

  @override
  void dispose() {
    _technique.dispose();
    _result.dispose();
    super.dispose();
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

  Future<void> _save() async {
    final updated = widget.request;
    updated.status = _status;
    updated.techniqueUsed = _technique.text.trim();
    updated.result = _result.text.trim();
    updated.nextAppointmentDate = _nextAppointment;
    await context.read<AppData>().updateScreeningRequest(updated);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMd(context.watch<AppData>().localeCode);
    return Scaffold(
      appBar: AppBar(title: Text(widget.request.patientName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.request.hospital, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline),
                  const SizedBox(width: 10),
                  Expanded(child: Text(context.t('ai_analysis_placeholder'))),
                ],
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<ScreeningStatus>(
              value: _status,
              decoration:
                  InputDecoration(labelText: context.t('select_status'), border: const OutlineInputBorder()),
              items: ScreeningStatus.values
                  .map((s) => DropdownMenuItem(value: s, child: Text(screeningStatusLabel(s, context.t))))
                  .toList(),
              onChanged: (v) => setState(() => _status = v ?? _status),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _technique,
              decoration:
                  InputDecoration(labelText: context.t('technique_used'), border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _result,
              decoration: InputDecoration(labelText: context.t('result_label'), border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.t('next_appointment')),
              subtitle: Text(_nextAppointment != null ? dateFormat.format(_nextAppointment!) : '-'),
              trailing: const Icon(Icons.calendar_month),
              onTap: _pickDate,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: Text(context.t('save')),
            ),
          ],
        ),
      ),
    );
  }
}
