import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../localization/translator.dart';
import '../services/app_data.dart';
import '../data/news_content.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  Future<void> _openLink(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    final ok = await canLaunchUrl(uri) && await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.t('could_not_open_link'))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<AppData>().localeCode;
    return Scaffold(
      appBar: AppBar(title: Text(context.t('news_title'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline),
                const SizedBox(width: 10),
                Expanded(child: Text(context.t('news_disclaimer'), style: Theme.of(context).textTheme.bodySmall)),
              ],
            ),
          ),
          ...cervicalCancerNews.map((item) => Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(item.source,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(color: Theme.of(context).colorScheme.primary)),
                          ),
                          Text(item.date, style: Theme.of(context).textTheme.labelSmall),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(item.title[locale] ?? item.title['fr']!,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(item.summary[locale] ?? item.summary['fr']!),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () => _openLink(context, item.url),
                          icon: const Icon(Icons.open_in_new, size: 16),
                          label: Text(context.t('read_more')),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
