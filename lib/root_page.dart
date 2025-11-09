import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pendings/controller/auth_controller.dart';
import 'package:pendings/presentation/auth/page/login_page.dart';
import 'package:pendings/presentation/home/page/home_page.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find();
    return Obx(() {
      if (controller.firebaseUser.value != null) {
        return HomePage();
      } else {
        return LoginPage();
      }
    });
  }
}
