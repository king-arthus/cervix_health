import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../localization/translator.dart';
import '../models/user_model.dart';
import '../services/app_data.dart';
import 'patient/patient_home_screen.dart';
import 'personnel/personnel_home_screen.dart';
import 'specialiste/specialiste_home_screen.dart';
import 'admin/admin_home_screen.dart';
import 'forgot_password_screen.dart';

bool _isValidEmail(String value) {
  return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim());
}

String _roleLabelKey(UserRole role) {
  switch (role) {
    case UserRole.patient:
      return 'profile_patient';
    case UserRole.agent:
      return 'profile_agent';
    case UserRole.specialiste:
      return 'profile_specialiste';
    case UserRole.admin:
      return 'profile_admin';
  }
}

class AuthScreen extends StatefulWidget {
  final UserRole role;
  const AuthScreen({super.key, required this.role});

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
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t(_roleLabelKey(widget.role))),
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
          _LoginForm(role: widget.role),
          _SignupForm(role: widget.role),
        ],
      ),
    );
  }
}

void _goToHome(BuildContext context, AppUser user) {
  Widget target;
  switch (user.role) {
    case UserRole.patient:
      target = const PatientHomeScreen();
      break;
    case UserRole.agent:
      target = const PersonnelHomeScreen();
      break;
    case UserRole.specialiste:
      target = const SpecialisteHomeScreen();
      break;
    case UserRole.admin:
      target = const AdminHomeScreen();
      break;
  }
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => target),
    (route) => false,
  );
}

class _LoginForm extends StatefulWidget {
  final UserRole role;
  const _LoginForm({required this.role});

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  String? _errorKey;
  String? _debugMessage;
  bool _loading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _errorKey = null;
      _debugMessage = null;
    });
    final appData = context.read<AppData>();
    final result = await appData.login(_email.text.trim(), _password.text, widget.role);
    setState(() => _loading = false);
    if (!mounted) return;
    if (!result.success || result.user == null) {
      setState(() {
        _errorKey = result.errorKey ?? 'generic_error';
        _debugMessage = result.debugMessage;
      });
    } else {
      _goToHome(context, result.user!);
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
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: context.t('email'), border: const OutlineInputBorder()),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return context.t('required_field');
                if (!_isValidEmail(v)) return context.t('error_invalid_email');
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _password,
              obscureText: true,
              decoration: InputDecoration(labelText: context.t('password'), border: const OutlineInputBorder()),
              validator: (v) => (v == null || v.isEmpty) ? context.t('required_field') : null,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                ),
                child: Text(context.t('forgot_password')),
              ),
            ),
            if (_errorKey != null) ...[
              const SizedBox(height: 4),
              Text(context.t(_errorKey!), style: const TextStyle(color: Colors.red)),
              if (_debugMessage != null) ...[
                const SizedBox(height: 4),
                Text(_debugMessage!, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ],
            const SizedBox(height: 16),
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
  final UserRole role;
  const _SignupForm({required this.role});

  @override
  State<_SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<_SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
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
  final _specialty = TextEditingController();
  String _gender = 'female';
  String? _errorKey;
  String? _debugMessage;
  bool _loading = false;

  bool get _isAgent => widget.role == UserRole.agent;
  bool get _isSpecialiste => widget.role == UserRole.specialiste;

  @override
  void dispose() {
    for (final c in [
      _email,
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
      _specialty,
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
      _debugMessage = null;
    });
    final appData = context.read<AppData>();
    final result = await appData.signUp(
      email: _email.text.trim(),
      password: _password.text,
      firstName: _firstName.text.trim(),
      lastName: _lastName.text.trim(),
      age: int.tryParse(_age.text.trim()) ?? 0,
      gender: _gender,
      contact: _contact.text.trim(),
      role: widget.role,
      employerFacility: (_isAgent || _isSpecialiste) ? _employerFacility.text.trim() : null,
      startYear: (_isAgent || _isSpecialiste) ? int.tryParse(_startYear.text.trim()) : null,
      position: _isAgent ? _position.text.trim() : null,
      educationLevel: _isAgent ? _educationLevel.text.trim() : null,
      specialty: _isSpecialiste ? _specialty.text.trim() : null,
    );
    setState(() => _loading = false);
    if (!mounted) return;
    if (!result.success || result.user == null) {
      setState(() {
        _errorKey = result.errorKey ?? 'generic_error';
        _debugMessage = result.debugMessage;
      });
      return;
    }
    _goToHome(context, result.user!);
  }

  Widget _field(TextEditingController c, String labelKey,
      {TextInputType type = TextInputType.text, bool numeric = false, bool email = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: c,
        keyboardType: type,
        decoration: InputDecoration(labelText: context.t(labelKey), border: const OutlineInputBorder()),
        validator: (v) {
          if (v == null || v.trim().isEmpty) return context.t('required_field');
          if (numeric && int.tryParse(v.trim()) == null) return context.t('invalid_number');
          if (email && !_isValidEmail(v)) return context.t('error_invalid_email');
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
            _field(_email, 'email', type: TextInputType.emailAddress, email: true),
            _field(_password, 'password'),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(context.t('password_hint'),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
              ),
            ),
            _field(_confirmPassword, 'confirm_password'),
            _field(_firstName, 'first_name'),
            _field(_lastName, 'last_name'),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TextFormField(
                controller: _age,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: context.t('age'), border: const OutlineInputBorder()),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return context.t('required_field');
                  final age = int.tryParse(v.trim());
                  if (age == null) return context.t('invalid_number');
                  if (widget.role == UserRole.patient && age < 18) return context.t('error_must_be_adult');
                  return null;
                },
              ),
            ),
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
            if (_isAgent) ...[
              _field(_employerFacility, 'employer_facility'),
              _field(_startYear, 'start_year', type: TextInputType.number, numeric: true),
              _field(_position, 'position'),
              _field(_educationLevel, 'education_level'),
            ],
            if (_isSpecialiste) ...[
              _field(_employerFacility, 'employer_facility'),
              _field(_startYear, 'start_year', type: TextInputType.number, numeric: true),
              _field(_specialty, 'specialty'),
            ],
            if (_errorKey != null) ...[
              Text(context.t(_errorKey!), style: const TextStyle(color: Colors.red)),
              if (_debugMessage != null) ...[
                const SizedBox(height: 4),
                Text(_debugMessage!, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
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
