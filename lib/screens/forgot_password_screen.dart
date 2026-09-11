import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../localization/translator.dart';
import '../services/app_data.dart';

bool _isValidEmail(String value) {
  return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim());
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _loading = false;
  bool _sent = false;
  String? _errorKey;
  String? _debugMessage;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _errorKey = null;
      _debugMessage = null;
    });
    final result = await context.read<AppData>().sendPasswordResetEmail(_email.text.trim());
    setState(() => _loading = false);
    if (!mounted) return;
    if (result.success) {
      setState(() => _sent = true);
    } else {
      setState(() {
        _errorKey = result.errorKey ?? 'generic_error';
        _debugMessage = result.debugMessage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.t('reset_password_title'))),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _sent
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.mark_email_read_outlined, size: 64, color: Colors.green),
                  const SizedBox(height: 20),
                  Text(
                    context.t('reset_email_sent'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(context.t('back_to_login')),
                  ),
                ],
              )
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(context.t('reset_password_instruction'), style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          InputDecoration(labelText: context.t('email'), border: const OutlineInputBorder()),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return context.t('required_field');
                        if (!_isValidEmail(v)) return context.t('error_invalid_email');
                        return null;
                      },
                    ),
                    if (_errorKey != null) ...[
                      const SizedBox(height: 12),
                      Text(context.t(_errorKey!), style: const TextStyle(color: Colors.red)),
                      if (_debugMessage != null) ...[
                        const SizedBox(height: 4),
                        Text(_debugMessage!, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                      ],
                    ],
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _loading ? null : _submit,
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: _loading
                          ? const SizedBox(
                              height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : Text(context.t('submit')),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
