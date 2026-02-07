import 'dart:io';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:get_storage/get_storage.dart';

class AppsFlyerService {
  AppsFlyerService._internal();
  static final AppsFlyerService instance = AppsFlyerService._internal();

  late final AppsflyerSdk _sdk;

  String? referralFromDeepLink;
  final storage = GetStorage();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    //--------Checking Local Storage----------------------
    final savedReferral = storage.read('pending_referral_code');
    if (savedReferral != null && savedReferral.isNotEmpty) {
      referralFromDeepLink = savedReferral;
    }
    //----------------------------------------------------

    final options = AppsFlyerOptions(
      afDevKey: '42ygpJ8vjAxWw4dg5YZoSZ',
      appId: Platform.isAndroid ? 'com.saoirse.epi' : '6755812043',
      showDebug: true,
      timeToWaitForATTUserAuthorization: 0,
      disableAdvertisingIdentifier: true,
      manualStart: false,
    );

    _sdk = AppsflyerSdk(options);

    await _sdk.initSdk(
      registerConversionDataCallback: true,
      registerOnDeepLinkingCallback: true,
      registerOnAppOpenAttributionCallback: true,
    );

    _sdk.onDeepLinking((deepLinkResult) async {
      if (deepLinkResult.status != Status.FOUND ||
          deepLinkResult.deepLink == null) {
        return;
      }

      final dl = deepLinkResult.deepLink!;
      final deepLinkValue = dl.deepLinkValue;

      // -------------------------------
      //  REFERRAL
      // -------------------------------
      if (deepLinkValue != null && deepLinkValue.isNotEmpty) {
        referralFromDeepLink = deepLinkValue;
        storage.write('pending_referral_code', deepLinkValue);
      }

      // -------------------------------
      // PRODUCT DEEP LINK/
      // -------------------------------
      final afDp = dl.clickEvent["af_dp"];
      if (afDp != null && afDp.toString().startsWith("epi://product/")) {
        final uri = Uri.parse(afDp);
        final productId = uri.pathSegments.last;

        storage.write("pending_product_id", productId);
        // DeepLinkNavigationService.handleProductNavigation();
      }
    });

    _sdk.onAppOpenAttribution((data) {
      // -------------------------------
      // PRODUCT DEEP LINK (BACKGROUND)
      // -------------------------------
      final afDp = data["af_dp"];
      if (afDp != null && afDp.toString().startsWith("epi://product/")) {
        final uri = Uri.parse(afDp);
        final productId = uri.pathSegments.last;

        storage.write("pending_product_id", productId);
        // DeepLinkNavigationService.handleProductNavigation();
      }
    });

    _initialized = true;
  }

  String? consumePendingProduct() {
    final id = storage.read("pending_product_id");
    if (id != null) {
      storage.remove("pending_product_id");
    }
    return id;
  }
}
