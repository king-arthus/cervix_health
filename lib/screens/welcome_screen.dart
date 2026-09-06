import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../localization/translator.dart';
import '../models/user_model.dart';
import '../services/app_data.dart';
import 'auth_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _showLanguageMenu(BuildContext context) {
    final appData = context.read<AppData>();
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(context.t('french')),
              trailing: appData.localeCode == 'fr' ? const Icon(Icons.check) : null,
              onTap: () {
                appData.setLocale('fr');
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: Text(context.t('english')),
              trailing: appData.localeCode == 'en' ? const Icon(Icons.check) : null,
              onTap: () {
                appData.setLocale('en');
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: Text(context.t('arabic')),
              trailing: appData.localeCode == 'ar' ? const Icon(Icons.check) : null,
              onTap: () {
                appData.setLocale('ar');
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: IconButton(
                  icon: const Icon(Icons.language),
                  tooltip: context.t('select_language'),
                  onPressed: () => _showLanguageMenu(context),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.favorite, size: 72, color: Colors.pinkAccent),
                    const SizedBox(height: 24),
                    Text(
                      context.t('welcome_title'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      context.t('welcome_subtitle'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 48),
                    Text(
                      context.t('select_profile'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.person),
                        label: Text(context.t('profile_patient')),
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AuthScreen(profileType: ProfileType.patient),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.medical_services_outlined),
                        label: Text(context.t('profile_personnel')),
                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AuthScreen(profileType: ProfileType.personnel),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
