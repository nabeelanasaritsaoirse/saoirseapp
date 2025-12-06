import 'dart:developer';

void appToast({
  required String content,
  String title = 'Message',
  bool error = false,
}) {
  final status = error ? "❌ ERROR" : "✅ SUCCESS";

  log("$status | $title → $content");
}



