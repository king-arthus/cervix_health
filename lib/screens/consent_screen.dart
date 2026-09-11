import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../localization/translator.dart';
import '../services/app_data.dart';
import '../data/consent_content.dart';
import 'welcome_screen.dart';

class ConsentScreen extends StatefulWidget {
  const ConsentScreen({super.key});

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  bool _accepted = false;
  bool _showMustAcceptWarning = false;

  Future<void> _continue() async {
    if (!_accepted) {
      setState(() => _showMustAcceptWarning = true);
      return;
    }
    await context.read<AppData>().acceptConsent();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<AppData>().localeCode;
    return Scaffold(
      appBar: AppBar(title: Text(context.t('consent_title')), automaticallyImplyLeading: false),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  context.t('consent_intro'),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 20),
                ...consentChapters.map((chapter) => Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chapter.title[locale] ?? chapter.title['fr']!,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          if (chapter.body != null)
                            Text(chapter.body![locale] ?? chapter.body!['fr']!,
                                style: const TextStyle(height: 1.5)),
                          if (chapter.subchapters != null)
                            ...chapter.subchapters!.map((sub) => Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(sub.subtitle[locale] ?? sub.subtitle['fr']!,
                                          style: const TextStyle(fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 4),
                                      Text(sub.body[locale] ?? sub.body['fr']!,
                                          style: const TextStyle(height: 1.5)),
                                    ],
                                  ),
                                )),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, -2))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CheckboxListTile(
                    value: _accepted,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (v) => setState(() {
                      _accepted = v ?? false;
                      if (_accepted) _showMustAcceptWarning = false;
                    }),
                    title: Text(context.t('consent_checkbox_label')),
                  ),
                  if (_showMustAcceptWarning)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(context.t('consent_must_accept'), style: const TextStyle(color: Colors.red)),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _continue,
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: Text(context.t('consent_continue')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
