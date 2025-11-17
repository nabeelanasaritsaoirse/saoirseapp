// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Saoirse App';

  @override
  String get signIn => 'Sign in';

  @override
  String welcomeUser(String name) {
    return 'Welcome, $name!';
  }

  @override
  String itemsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: 'No items',
    );
    return '$_temp0';
  }

  @override
  String get stylishTitle => 'Stylish';

  @override
  String get investmentDescription => 'Turn your savings into success.\nInvest today and secure the future you’ve always wanted!';

  @override
  String get bookNow => 'Book Now';
}
