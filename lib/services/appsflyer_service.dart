import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'deep_link_navigation_service.dart';

class AppsFlyerService {
  AppsFlyerService._internal();
  static final AppsFlyerService instance = AppsFlyerService._internal();

  late final AppsflyerSdk _sdk;

  String? referralFromDeepLink;
  final storage = GetStorage();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    try {
      // 🔹 Restore referral if exists
      final savedReferral = storage.read('pending_referral_code');
      if (savedReferral != null && savedReferral.isNotEmpty) {
        referralFromDeepLink = savedReferral;
        debugPrint("✅ Restored referral: $savedReferral");
      }

      // 🔹 SAFE AppsFlyer options for iOS
      final options = AppsFlyerOptions(
        afDevKey: '42ygpJ8vjAxWw4dg5YZoSZ',
        appId: '1765456537', // ✅ Apple App Store NUMERIC ID
        showDebug: true,
        timeToWaitForATTUserAuthorization: 60, // ✅ REQUIRED for iOS
        manualStart: true, // ✅ REQUIRED for iOS
      );

      _sdk = AppsflyerSdk(options);

      // 🔹 Init SDK (do NOT await)
      _sdk.initSdk(
        registerConversionDataCallback: true,
        registerOnDeepLinkingCallback: true,
        registerOnAppOpenAttributionCallback: true,
      );

      // 🔹 Start SDK AFTER UI is ready (prevents black screen)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _sdk.startSDK();
      });

      // 🔹 Deep linking (foreground)
      _sdk.onDeepLinking((deepLinkResult) async {
        if (deepLinkResult.status != Status.FOUND ||
            deepLinkResult.deepLink == null) {
          return;
        }

        final dl = deepLinkResult.deepLink!;
        final deepLinkValue = dl.deepLinkValue;

        if (deepLinkValue != null && deepLinkValue.isNotEmpty) {
          referralFromDeepLink = deepLinkValue;
          storage.write('pending_referral_code', deepLinkValue);
        }

        final afDp = dl.clickEvent["af_dp"];
        if (afDp != null && afDp.toString().startsWith("epi://product/")) {
          final uri = Uri.parse(afDp);
          final productId = uri.pathSegments.last;

          storage.write("pending_product_id", productId);
          DeepLinkNavigationService.handleProductNavigation();
        }
      });

      // 🔹 App open attribution (background)
      _sdk.onAppOpenAttribution((data) {
        final afDp = data["af_dp"];
        if (afDp != null && afDp.toString().startsWith("epi://product/")) {
          final uri = Uri.parse(afDp);
          final productId = uri.pathSegments.last;

          storage.write("pending_product_id", productId);
          DeepLinkNavigationService.handleProductNavigation();
        }
      });

      _initialized = true;
    } catch (e) {
      // 🔥 NEVER crash the app
      debugPrint("❌ AppsFlyer init failed: $e");
    }
  }

  String? consumePendingProduct() {
    final id = storage.read("pending_product_id");
    if (id != null) {
      storage.remove("pending_product_id");
    }
    return id;
  }
}
