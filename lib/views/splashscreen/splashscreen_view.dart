import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_guru/utils/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashscreenView extends StatefulWidget {
  const SplashscreenView({super.key});

  @override
  State<SplashscreenView> createState() => _SplashscreenViewState();
}

class _SplashscreenViewState extends State<SplashscreenView> {

  Future<void> checkLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? savedUsername = sharedPreferences.getString('savedUsername');
    if (savedUsername != null) {
      if (savedUsername == "admin") {
        Get.offAllNamed(Routes.adminDashboardView);
      } else {
        Get.offAllNamed(Routes.guruDashboardView);
      }
    } else {
      Get.offAllNamed(Routes.loginView);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      checkLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/images/logo.png"),
      ),
    );
  }
}