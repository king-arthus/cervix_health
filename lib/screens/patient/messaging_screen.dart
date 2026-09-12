import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../localization/translator.dart';
import '../../models/user_model.dart';
import '../../services/app_data.dart';
import '../../widgets/empty_state.dart';

class MessagingScreen extends StatelessWidget {
  const MessagingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appData = context.watch<AppData>();
    final user = appData.currentUser;
    final conversations = user == null ? [] : appData.conversationsFor(user.id);
    final dateFormat = DateFormat.Hm(appData.localeCode);

    return Scaffold(
      appBar: AppBar(title: Text(context.t('messaging_title'))),
      body: conversations.isEmpty
          ? EmptyState(
              icon: Icons.chat_bubble_outline,
              title: context.t('no_conversations'),
              subtitle: context.t('no_conversations_sub'),
            )
          : RefreshIndicator(
              onRefresh: appData.refreshNow,
              child: ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final entry = conversations[index];
                final peer = entry.key;
                final lastMessage = entry.value;
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(peer.fullName),
                  subtitle: Text(
                    lastMessage.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(dateFormat.format(lastMessage.timestamp)),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ChatScreen(peer: peer)),
                  ),
                );
              },
            ),
            ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final AppUser peer;
  const ChatScreen({super.key, required this.peer});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  bool get _isProfessionalConversation {
    final me = context.read<AppData>().currentUser;
    if (me == null) return false;
    return me.role != UserRole.patient && widget.peer.role != UserRole.patient;
  }

  Future<void> _openSharingDialog() async {
    final appData = context.read<AppData>();
    final me = appData.currentUser;
    if (me == null) return;
    final currentPatientId = appData.sharedPatientIdFor(me.id, widget.peer.id);
    final candidates = appData.patientsLinkingProfessionals(me.id, widget.peer.id);

    await showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(context.t('share_conversation_title'), style: Theme.of(context).textTheme.titleMedium),
            ),
            if (candidates.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(context.t('no_linked_patients')),
              ),
            ...candidates.map((p) => ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(p.fullName),
                  trailing: currentPatientId == p.id ? const Icon(Icons.check, color: Colors.green) : null,
                  onTap: () async {
                    Navigator.pop(ctx);
                    await appData.setConversationSharing(userA: me.id, userB: widget.peer.id, patientId: p.id);
                  },
                )),
            if (currentPatientId != null)
              ListTile(
                leading: const Icon(Icons.link_off, color: Colors.red),
                title: Text(context.t('stop_sharing'), style: const TextStyle(color: Colors.red)),
                onTap: () async {
                  Navigator.pop(ctx);
                  await appData.setConversationSharing(userA: me.id, userB: widget.peer.id, patientId: null);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final appData = context.read<AppData>();
    final user = appData.currentUser;
    if (user == null) return;
    await appData.sendMessage(sender: user, receiverId: widget.peer.id, text: text);
    _controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appData = context.watch<AppData>();
    final user = appData.currentUser;
    final messages = user == null ? [] : appData.conversation(user.id, widget.peer.id);
    final dateFormat = DateFormat.Hm(appData.localeCode);
    final showSharing = _isProfessionalConversation;
    final sharedPatientId = user == null ? null : appData.sharedPatientIdFor(user.id, widget.peer.id);
    AppUser? sharedPatient;
    if (sharedPatientId != null) {
      try {
        sharedPatient = appData.users.firstWhere((u) => u.id == sharedPatientId);
      } catch (_) {}
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.peer.fullName),
        actions: [
          if (showSharing)
            IconButton(
              icon: Icon(sharedPatientId != null ? Icons.share : Icons.share_outlined),
              tooltip: context.t('share_conversation_title'),
              onPressed: _openSharingDialog,
            ),
        ],
      ),
      body: Column(
        children: [
          if (showSharing && sharedPatient != null)
            Container(
              width: double.infinity,
              color: Colors.green.withOpacity(0.12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                '${context.t('sharing_active_with')} ${sharedPatient.fullName}',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final m = messages[index];
                final isMine = m.senderId == user?.id;
                return Align(
                  alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMine
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m.text),
                        const SizedBox(height: 4),
                        Text(
                          dateFormat.format(m.timestamp),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: context.t('type_message'),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.send), onPressed: _send),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
