import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/app_loader.dart';
import 'signin_controller.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  SignInController signInController = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Obx(
          () => Stack(
            children: [
              Visibility(
                visible: signInController.loading.value,
                child: appLoader(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
