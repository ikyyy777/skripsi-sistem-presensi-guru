// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_guru/constants/color_constant.dart';
import 'package:presensi_guru/constants/textstyle_constant.dart';

class GetDialogs {
  static void showDialog1(String title, String message) {
    Get.dialog(
      AlertDialog(
        title: Text(
          title,
          style: TextstyleConstant.nunitoSansMedium.copyWith(
            color: ColorConstant.black,
            fontSize: 20,
          ),
        ),
        content: Text(
          message,
          style: TextstyleConstant.nunitoSansRegular.copyWith(
            color: ColorConstant.black50,
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "OK",
              style: TextStyle(color: ColorConstant.blue),
            ),
          ),
        ],
      ),
    );
  }

  static void showCircularLoading() {
    Get.dialog(
      WillPopScope(
        onWillPop: () async =>
            false, // Mencegah pengguna menutup dialog loading
        child: Center(
          child: CircularProgressIndicator(
            color: ColorConstant.blue,
          ),
        ),
      ),
      barrierDismissible: false, // Mencegah klik di luar dialog
    );
  }

  static void showSnackBar1(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: ColorConstant.white,
      colorText: ColorConstant.black,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          offset: const Offset(0, 4),
          blurRadius: 10,
          spreadRadius: 2,
        ),
      ],
    );
  }
}
