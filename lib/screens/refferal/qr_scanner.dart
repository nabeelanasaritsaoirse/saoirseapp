import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:get/get.dart';

import '../../constants/app_strings.dart';
import '../../widgets/custom_appbar.dart';

class QRScannerScreen extends StatelessWidget {
  final Function(String) onReferralDetected;

  const QRScannerScreen({super.key, required this.onReferralDetected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBack: true,
        title: AppStrings.scan_referral_qr_code,
      ),
      body: MobileScanner(
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;

          for (final barcode in barcodes) {
            final String? rawValue = barcode.rawValue;

            if (rawValue != null && rawValue.isNotEmpty) {
              onReferralDetected(rawValue);
              Get.back(); // Close scanner screen
            }
          }
        },
      ),
    );
  }
}
