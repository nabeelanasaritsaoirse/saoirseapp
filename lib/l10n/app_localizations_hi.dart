// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'सेर्से ऐप';

  @override
  String get signIn => 'साइन इन';

  @override
  String welcomeUser(String name) {
    return 'स्वागत है, $name!';
  }

  @override
  String itemsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count आइटम',
      one: '1 आइटम',
      zero: 'कोई आइटम नहीं',
    );
    return '$_temp0';
  }

  @override
  String get stylishTitle => 'स्टाइलिश';

  @override
  String get investmentDescription => 'अपनी बचत को सफलता में बदलें। \nआज ही निवेश करें और वह भविष्य सुरक्षित करें जिसकी आपने हमेशा कल्पना की है!';

  @override
  String get bookNow => 'अभी बुक करें';
}
