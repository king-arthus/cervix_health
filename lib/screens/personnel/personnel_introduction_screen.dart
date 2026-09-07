import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../localization/translator.dart';
import '../../services/app_data.dart';
import '../../data/introduction_content.dart';

class PersonnelIntroductionScreen extends StatelessWidget {
  const PersonnelIntroductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<AppData>().localeCode;
    return Scaffold(
      appBar: AppBar(title: Text(context.t('module_introduction'))),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: personnelIntroChapters.map((chapter) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Text(
                  chapter.title[locale] ?? chapter.title['fr']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (chapter.body != null)
                    Text(chapter.body![locale] ?? chapter.body!['fr']!, style: const TextStyle(height: 1.5)),
                  if (chapter.subchapters != null)
                    ...chapter.subchapters!.map((sub) => Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sub.subtitle[locale] ?? sub.subtitle['fr']!,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 6),
                              Text(sub.body[locale] ?? sub.body['fr']!, style: const TextStyle(height: 1.5)),
                            ],
                          ),
                        )),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
