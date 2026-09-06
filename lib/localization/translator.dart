import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../services/app_data.dart';
import 'app_strings.dart';

extension Translator on BuildContext {
  /// Traduit une clé selon la langue courante de l'application.
  /// Usage : context.t('welcome_title')
  String t(String key) {
    final locale = watch<AppData>().localeCode;
    return AppStrings.t(locale, key);
  }

  /// Variante sans écoute (à utiliser dans des callbacks, hors build).
  String tNoWatch(String key) {
    final locale = read<AppData>().localeCode;
    return AppStrings.t(locale, key);
  }
}
