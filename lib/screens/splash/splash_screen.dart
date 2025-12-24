import 'package:flutter/material.dart';
import 'package:saoirse_app/bindings/allcontroller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // 🔥 CRITICAL iOS FIX: Initialize controllers AFTER first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ✅ Now safe - Flutter has already rendered
      Allcontroller().dependencies();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Your existing splash screen UI
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
