import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../localization/translator.dart';
import '../../services/app_data.dart';
import '../welcome_screen.dart';

/// Espace Administrateur — non fonctionnel à ce stade (étape 3 de la refonte
/// par rôles). Les comptes admin ne sont pas créés via l'inscription publique ;
/// ils doivent être configurés manuellement dans Firebase pour l'instant.
class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t('admin_home_title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: context.t('logout'),
            onPressed: () async {
              await context.read<AppData>().logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.admin_panel_settings_outlined, size: 72, color: Theme.of(context).colorScheme.outline),
              const SizedBox(height: 20),
              Text(
                context.t('admin_coming_soon'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
