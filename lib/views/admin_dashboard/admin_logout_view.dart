import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_guru/constants/textstyle_constant.dart';
import 'package:presensi_guru/controllers/login_controller.dart';

class AdminLogoutView extends StatelessWidget {
  AdminLogoutView({super.key});

  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            loginController.logout();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            "Logout",
            style: TextstyleConstant.nunitoSansBold.copyWith(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}