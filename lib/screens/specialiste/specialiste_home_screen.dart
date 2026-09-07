import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../localization/translator.dart';
import '../../services/app_data.dart';
import '../welcome_screen.dart';
import '../profile_screen.dart';
import '../news_screen.dart';
import '../patient/messaging_screen.dart';
import '../patient/community_screen.dart';
import '../personnel/personnel_introduction_screen.dart';
import 'specialist_dossiers_screen.dart';
import 'dart:convert';

/// Espace Spécialiste — étape 1 de la refonte par rôles.
/// Le flux complet (dossiers attribués, validation, suggestion IA) sera
/// ajouté à l'étape 2, une fois le modèle "dossier" mis en place.
class SpecialisteHomeScreen extends StatelessWidget {
  const SpecialisteHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppData>().currentUser;
    final tiles = <_ModuleTile>[
      _ModuleTile(context.t('module_introduction'), Icons.menu_book, const PersonnelIntroductionScreen()),
      _ModuleTile(context.t('received_dossiers'), Icons.folder_shared_outlined, const SpecialistDossiersScreen()),
      _ModuleTile(context.t('module_messaging'), Icons.chat_bubble_outline, const MessagingScreen()),
      _ModuleTile(context.t('module_community'), Icons.groups, const CommunityScreen()),
      _ModuleTile(context.t('module_news'), Icons.newspaper, const NewsScreen()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(user?.fullName ?? context.t('specialiste_home_title')),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
            child: CircleAvatar(
              backgroundImage: (user?.photoBase64 != null && user!.photoBase64!.isNotEmpty)
                  ? MemoryImage(base64Decode(user.photoBase64!))
                  : null,
              child: (user?.photoBase64 == null || user!.photoBase64!.isEmpty)
                  ? const Icon(Icons.person)
                  : null,
            ),
          ),
        ),
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
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: tiles.map((tile) => _buildCard(context, tile)).toList(),
      ),
    );
  }

  Widget _buildCard(BuildContext context, _ModuleTile tile) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => tile.screen)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(tile.icon, size: 40, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 12),
              Text(tile.title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleSmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModuleTile {
  final String title;
  final IconData icon;
  final Widget screen;
  _ModuleTile(this.title, this.icon, this.screen);
}
