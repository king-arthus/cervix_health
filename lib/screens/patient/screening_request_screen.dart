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
  String? _selectedCountry;
  String? _selectedCity;
  String? _selectedHospital;

  List<String> get _citiesForCountry {
    if (_selectedCountry == null) return [];
    final cities = <String>[];
    for (final h in hospitalsByCountry[_selectedCountry]!) {
      if (!cities.contains(h.city)) cities.add(h.city);
    }
    return cities;
  }

  List<HospitalEntry> get _hospitalsForCity {
    if (_selectedCountry == null || _selectedCity == null) return [];
    return hospitalsByCountry[_selectedCountry]!
        .where((h) => h.city == _selectedCity)
        .where((h) => h.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  Future<void> _sendRequest() async {
    if (_selectedHospital == null || _selectedCity == null || _selectedCountry == null) return;
    final appData = context.read<AppData>();
    final user = appData.currentUser;
    if (user == null) return;
    final fullHospital = '$_selectedHospital — $_selectedCity, $_selectedCountry';
    await appData.createScreeningRequest(patient: user, hospital: fullHospital);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.t('request_sent'))));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final personnelList = context.watch<AppData>().personnelList;
    final countries = hospitalsByCountry.keys.toList();

    return Scaffold(
      appBar: AppBar(title: Text(context.t('screening_request_title'))),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.phone_outlined, size: 16),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(context.t('hospital_list_disclaimer'),
                        style: Theme.of(context).textTheme.bodySmall)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: DropdownButtonFormField<String>(
              value: _selectedCountry,
              decoration:
                  InputDecoration(labelText: context.t('select_country'), border: const OutlineInputBorder()),
              items: countries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() {
                _selectedCountry = v;
                _selectedCity = null;
                _selectedHospital = null;
              }),
            ),
          ),
          if (_selectedCountry != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: DropdownButtonFormField<String>(
                value: _selectedCity,
                decoration:
                    InputDecoration(labelText: context.t('select_city'), border: const OutlineInputBorder()),
                items: _citiesForCountry.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() {
                  _selectedCity = v;
                  _selectedHospital = null;
                }),
              ),
            ),
          if (_selectedCity != null)
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
                if (_selectedCity != null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Text(context.t('select_hospital'), style: Theme.of(context).textTheme.titleSmall),
                  ),
                  ..._hospitalsForCity.map(
                    (h) => RadioListTile<String>(
                      title: Text(h.name),
                      value: h.name,
                      groupValue: _selectedHospital,
                      onChanged: (v) => setState(() => _selectedHospital = v),
                    ),
                  ),
                  const Divider(),
                ],
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
