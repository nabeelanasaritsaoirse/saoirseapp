import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageSwitcher extends StatelessWidget {
  final box = GetStorage();

  LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Change Language',
      icon: const Icon(Icons.translate,
          color: Colors.white, size: 24), // 🌐 Language icon
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (String value) {
        final locale = Locale(value);
        Get.updateLocale(locale);
        box.write('language', value);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'en',
          child: Row(
            children: const [
              Icon(Icons.flag, color: Colors.blueAccent, size: 18),
              SizedBox(width: 8),
              Text('English'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'hi',
          child: Row(
            children: const [
              Icon(Icons.flag, color: Colors.orangeAccent, size: 18),
              SizedBox(width: 8),
              Text('हिंदी'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'ml',
          child: Row(
            children: const [
              Icon(Icons.flag, color: Colors.green, size: 18),
              SizedBox(width: 8),
              Text('മലയാളം'),
            ],
          ),
        ),
      ],
    );
  }
}
