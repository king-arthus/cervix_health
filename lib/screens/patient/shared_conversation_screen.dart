import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../localization/translator.dart';
import '../../services/app_data.dart';
import '../../widgets/empty_state.dart';

/// Vue en lecture seule des messages qu'un agent ou un spécialiste a choisi
/// de partager avec la patiente concernant son dossier.
class SharedConversationScreen extends StatelessWidget {
  const SharedConversationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appData = context.watch<AppData>();
    final user = appData.currentUser;
    final messages = user == null ? [] : appData.sharedMessagesForPatient(user.id);
    final dateFormat = DateFormat.yMMMd(appData.localeCode).add_Hm();

    return Scaffold(
      appBar: AppBar(title: Text(context.t('shared_conversation_title'))),
      body: messages.isEmpty
          ? EmptyState(
              icon: Icons.forum_outlined,
              title: context.t('no_shared_messages'),
              subtitle: context.t('no_shared_messages_sub'),
            )
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(context.t('shared_conversation_notice'),
                              style: Theme.of(context).textTheme.bodySmall)),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final m = messages[index];
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(m.senderName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              const SizedBox(height: 4),
                              Text(m.text),
                              const SizedBox(height: 4),
                              Text(dateFormat.format(m.timestamp), style: Theme.of(context).textTheme.labelSmall),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
