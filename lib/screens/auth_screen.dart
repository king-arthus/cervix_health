import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../localization/translator.dart';
import '../models/user_model.dart';
import '../services/app_data.dart';
import 'patient/patient_home_screen.dart';
import 'personnel/personnel_home_screen.dart';

class AuthScreen extends StatefulWidget {
  final ProfileType profileType;
  const AuthScreen({super.key, required this.profileType});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPatient = widget.profileType == ProfileType.patient;
    return Scaffold(
      appBar: AppBar(
        title: Text(isPatient ? context.t('profile_patient') : context.t('profile_personnel')),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: context.t('login')),
            Tab(text: context.t('signup')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _LoginForm(profileType: widget.profileType),
          _SignupForm(profileType: widget.profileType),
        ],
      ),
    );
  }
}

void _goToHome(BuildContext context, AppUser user) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (_) =>
          user.profileType == ProfileType.patient ? const PatientHomeScreen() : const PersonnelHomeScreen(),
    ),
    (route) => false,
  );
}

class _LoginForm extends StatefulWidget {
  final ProfileType profileType;
  const _LoginForm({required this.profileType});

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  String? _errorKey;
  bool _loading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _errorKey = null;
    });
    final appData = context.read<AppData>();
    final user = await appData.login(_username.text.trim(), _password.text, widget.profileType);
    setState(() => _loading = false);
    if (!mounted) return;
    if (user == null) {
      setState(() => _errorKey = 'error_login_failed');
    } else {
      _goToHome(context, user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(context.t('welcome_back'), style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            TextFormField(
              controller: _username,
              decoration: InputDecoration(labelText: context.t('username'), border: const OutlineInputBorder()),
              validator: (v) => (v == null || v.trim().isEmpty) ? context.t('required_field') : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _password,
              obscureText: true,
              decoration: InputDecoration(labelText: context.t('password'), border: const OutlineInputBorder()),
              validator: (v) => (v == null || v.isEmpty) ? context.t('required_field') : null,
            ),
            if (_errorKey != null) ...[
              const SizedBox(height: 12),
              Text(context.t(_errorKey!), style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : _submit,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: _loading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(context.t('login')),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignupForm extends StatefulWidget {
  final ProfileType profileType;
  const _SignupForm({required this.profileType});

  @override
  State<_SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<_SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _age = TextEditingController();
  final _contact = TextEditingController();
  final _employerFacility = TextEditingController();
  final _startYear = TextEditingController();
  final _position = TextEditingController();
  final _educationLevel = TextEditingController();
  String _gender = 'female';
  String? _errorKey;
  bool _loading = false;

  bool get _isPersonnel => widget.profileType == ProfileType.personnel;

  @override
  void dispose() {
    for (final c in [
      _username,
      _password,
      _confirmPassword,
      _firstName,
      _lastName,
      _age,
      _contact,
      _employerFacility,
      _startYear,
      _position,
      _educationLevel,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_password.text != _confirmPassword.text) {
      setState(() => _errorKey = 'passwords_dont_match');
      return;
    }
    setState(() {
      _loading = true;
      _errorKey = null;
    });
    final appData = context.read<AppData>();
    final usernameError = appData.findErrorForSignup(_username.text.trim(), widget.profileType);
    if (usernameError != null) {
      setState(() {
        _loading = false;
        _errorKey = usernameError;
      });
      return;
    }
    final user = AppUser(
      id: const Uuid().v4(),
      username: _username.text.trim(),
      password: _password.text,
      firstName: _firstName.text.trim(),
      lastName: _lastName.text.trim(),
      age: int.tryParse(_age.text.trim()) ?? 0,
      gender: _gender,
      contact: _contact.text.trim(),
      profileType: widget.profileType,
      employerFacility: _isPersonnel ? _employerFacility.text.trim() : null,
      startYear: _isPersonnel ? int.tryParse(_startYear.text.trim()) : null,
      position: _isPersonnel ? _position.text.trim() : null,
      educationLevel: _isPersonnel ? _educationLevel.text.trim() : null,
    );
    final created = await appData.signUp(user);
    setState(() => _loading = false);
    if (!mounted) return;
    _goToHome(context, created);
  }

  Widget _field(TextEditingController c, String labelKey,
      {TextInputType type = TextInputType.text, bool numeric = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: c,
        keyboardType: type,
        decoration: InputDecoration(labelText: context.t(labelKey), border: const OutlineInputBorder()),
        validator: (v) {
          if (v == null || v.trim().isEmpty) return context.t('required_field');
          if (numeric && int.tryParse(v.trim()) == null) return context.t('invalid_number');
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _field(_username, 'username'),
            _field(_password, 'password'),
            _field(_confirmPassword, 'confirm_password'),
            _field(_firstName, 'first_name'),
            _field(_lastName, 'last_name'),
            _field(_age, 'age', type: TextInputType.number, numeric: true),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: DropdownButtonFormField<String>(
                value: _gender,
                decoration: InputDecoration(labelText: context.t('gender'), border: const OutlineInputBorder()),
                items: [
                  DropdownMenuItem(value: 'female', child: Text(context.t('female'))),
                  DropdownMenuItem(value: 'male', child: Text(context.t('male'))),
                ],
                onChanged: (v) => setState(() => _gender = v ?? 'female'),
              ),
            ),
            _field(_contact, 'contact', type: TextInputType.phone),
            if (_isPersonnel) ...[
              _field(_employerFacility, 'employer_facility'),
              _field(_startYear, 'start_year', type: TextInputType.number, numeric: true),
              _field(_position, 'position'),
              _field(_educationLevel, 'education_level'),
            ],
            if (_errorKey != null) ...[
              Text(context.t(_errorKey!), style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 12),
            ],
            ElevatedButton(
              onPressed: _loading ? null : _submit,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: _loading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(context.t('submit')),
            ),
          ],
        ),
      ),
    );
  }
}
