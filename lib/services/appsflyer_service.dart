import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/material.dart';
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
      debugPrint("✅ Restored referral from storage: $savedReferral");
    }
    //----------------------------------------------------

    final options = AppsFlyerOptions(
      afDevKey: '42ygpJ8vjAxWw4dg5YZoSZ',
      appId: 'com.saoirse.epi',
      showDebug: true,
      timeToWaitForATTUserAuthorization: 0,
      manualStart: false,
    );

    _sdk = AppsflyerSdk(options);

    await _sdk.initSdk(
      registerConversionDataCallback: true,
      registerOnDeepLinkingCallback: true,
    );

    _sdk.onDeepLinking((deepLinkResult) async {
      if (deepLinkResult.status == Status.FOUND &&
          deepLinkResult.deepLink != null) {
        final dl = deepLinkResult.deepLink!;
        final code = dl.deepLinkValue;

        if (code != null && code.isNotEmpty) {
          referralFromDeepLink = code;
          //---Saving to Local---
          storage.write('pending_referral_code', code);
        }
      }
    });

    _initialized = true;
  }
}