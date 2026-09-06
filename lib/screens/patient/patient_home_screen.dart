import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../localization/translator.dart';
import '../../services/app_data.dart';
import '../welcome_screen.dart';
import 'introduction_screen.dart';
import 'risk_factors_screen.dart';
import 'screening_request_screen.dart';
import 'screening_tracking_screen.dart';
import 'messaging_screen.dart';
import 'community_screen.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppData>().currentUser;
    final tiles = <_ModuleTile>[
      _ModuleTile(context.t('module_introduction'), Icons.menu_book, const IntroductionScreen()),
      _ModuleTile(context.t('module_risk_factors'), Icons.fact_check, const RiskFactorsScreen()),
      _ModuleTile(context.t('module_screening_request'), Icons.medical_information, const ScreeningRequestScreen()),
      _ModuleTile(context.t('module_tracking'), Icons.timeline, const ScreeningTrackingScreen()),
      _ModuleTile(context.t('module_messaging'), Icons.chat_bubble_outline, const MessagingScreen()),
      _ModuleTile(context.t('module_community'), Icons.groups, const CommunityScreen()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(user?.fullName ?? context.t('profile_patient')),
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
