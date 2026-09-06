import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../localization/translator.dart';
import '../../services/app_data.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final _controller = TextEditingController();

  Future<void> _post() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final appData = context.read<AppData>();
    final user = appData.currentUser;
    if (user == null) return;
    await appData.addPost(user, text);
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final appData = context.watch<AppData>();
    final posts = appData.sortedPosts;
    final dateFormat = DateFormat.yMMMd(appData.localeCode).add_Hm();

    return Scaffold(
      appBar: AppBar(title: Text(context.t('community_title'))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: context.t('write_post'),
                      border: const OutlineInputBorder(),
                    ),
                    minLines: 1,
                    maxLines: 3,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _post, child: Text(context.t('post'))),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: posts.isEmpty
                ? Center(child: Text(context.t('no_posts_yet')))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final p = posts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(p.authorName,
                                        style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                  Text(dateFormat.format(p.timestamp),
                                      style: Theme.of(context).textTheme.labelSmall),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(p.text),
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
