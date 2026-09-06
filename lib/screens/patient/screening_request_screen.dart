import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../localization/translator.dart';
import '../../data/hospitals.dart';
import '../../models/user_model.dart';
import '../../services/app_data.dart';
import 'messaging_screen.dart';

class ScreeningRequestScreen extends StatefulWidget {
  const ScreeningRequestScreen({super.key});

  @override
  State<ScreeningRequestScreen> createState() => _ScreeningRequestScreenState();
}

class _ScreeningRequestScreenState extends State<ScreeningRequestScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  String? _selectedHospital;

  List<String> get _filteredHospitals => chadScreeningHospitals
      .where((h) => h.toLowerCase().contains(_query.toLowerCase()))
      .toList();

  Future<void> _sendRequest() async {
    if (_selectedHospital == null) return;
    final appData = context.read<AppData>();
    final user = appData.currentUser;
    if (user == null) return;
    await appData.createScreeningRequest(patient: user, hospital: _selectedHospital!);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.t('request_sent'))));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final personnelList = context.watch<AppData>().personnelList;

    return Scaffold(
      appBar: AppBar(title: Text(context.t('screening_request_title'))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: context.t('search_hospital'),
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Text(context.t('select_hospital'), style: Theme.of(context).textTheme.titleSmall),
                ),
                ..._filteredHospitals.map(
                  (h) => RadioListTile<String>(
                    title: Text(h),
                    value: h,
                    groupValue: _selectedHospital,
                    onChanged: (v) => setState(() => _selectedHospital = v),
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Text(context.t('search_personnel'), style: Theme.of(context).textTheme.titleSmall),
                ),
                if (personnelList.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(context.t('no_personnel_available')),
                  ),
                ...personnelList.map((p) => _PersonnelTile(personnel: p)),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _selectedHospital == null ? null : _sendRequest,
        icon: const Icon(Icons.send),
        label: Text(context.t('submit')),
      ),
    );
  }
}

class _PersonnelTile extends StatelessWidget {
  final AppUser personnel;
  const _PersonnelTile({required this.personnel});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.medical_services_outlined)),
      title: Text(personnel.fullName),
      subtitle: Text(personnel.employerFacility ?? ''),
      trailing: IconButton(
        icon: const Icon(Icons.chat_bubble_outline),
        tooltip: context.t('contact_patient'),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ChatScreen(peer: personnel)),
        ),
      ),
    );
  }
}
