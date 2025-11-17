// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get appTitle => 'സയോഴ്‌സ് ആപ്പ്';

  @override
  String get signIn => 'സൈൻ ഇൻ';

  @override
  String welcomeUser(String name) {
    return 'സ്വാഗതം, $name!';
  }

  @override
  String itemsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ഇനങ്ങൾ',
      one: '1 ഇനം',
      zero: 'ഒന്നുമില്ല',
    );
    return '$_temp0';
  }

  @override
  String get stylishTitle => 'സ്റ്റൈലിഷ്';

  @override
  String get investmentDescription => 'നിങ്ങളുടെ സംഗ്രഹങ്ങളെ വിജയത്തിലേക്ക് മാറ്റൂ. \nഇന്നുതന്നെ നിക്ഷേപിച്ച് നിങ്ങൾ ആഗ്രഹിക്കുന്ന ഭാവി ഉറപ്പാക്കൂ!';

  @override
  String get bookNow => 'ഇപ്പോൾ ബുക്ക് ചെയ്യൂ';
}
