import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//gen ภาษา ใช้ command flutter gen-l10n
class LocalizationService {
  static final LocalizationService _instance = LocalizationService._internal();

  late AppLocalizations _localizations;

  factory LocalizationService() {
    return _instance;
  }

  LocalizationService._internal();

  void setLocalizations(BuildContext context) {
    _localizations = AppLocalizations.of(context)!;
  }

  AppLocalizations get localizations => _localizations;
}
