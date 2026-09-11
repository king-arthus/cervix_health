import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../localization/translator.dart';
import '../services/app_data.dart';

/// Bandeau affiché en haut des tableaux de bord tant que l'adresse e-mail
/// du compte n'a pas été vérifiée. Non bloquant : l'utilisateur peut continuer
/// à utiliser l'application, mais est régulièrement rappelé à l'ordre.
class EmailVerificationBanner extends StatefulWidget {
  const EmailVerificationBanner({super.key});

  @override
  State<EmailVerificationBanner> createState() => _EmailVerificationBannerState();
}

class _EmailVerificationBannerState extends State<EmailVerificationBanner> {
  bool _checking = false;
  bool _sending = false;
  String? _feedback;

  Future<void> _checkNow() async {
    setState(() => _checking = true);
    final verified = await context.read<AppData>().refreshEmailVerifiedStatus();
    setState(() {
      _checking = false;
      _feedback = verified ? null : context.mounted ? context.t('email_not_verified_yet') : null;
    });
  }

  Future<void> _resend() async {
    setState(() => _sending = true);
    final result = await context.read<AppData>().resendVerificationEmail();
    setState(() {
      _sending = false;
      _feedback = result.success ? context.t('verification_email_resent') : context.t('generic_error');
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppData>().currentUser;
    if (user == null || user.emailVerified) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.amber),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.mark_email_unread_outlined, color: Colors.amber),
              const SizedBox(width: 10),
              Expanded(child: Text(context.t('email_not_verified_banner'))),
            ],
          ),
          if (_feedback != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(_feedback!, style: Theme.of(context).textTheme.bodySmall),
            ),
          const SizedBox(height: 10),
          Row(
            children: [
              TextButton(
                onPressed: _sending ? null : _resend,
                child: Text(context.t('resend_verification_email')),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: _checking ? null : _checkNow,
                child: Text(context.t('ive_verified_check_now')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
