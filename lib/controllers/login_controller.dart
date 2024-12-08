import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presensi_guru/utils/get_dialogs.dart';
import 'package:presensi_guru/utils/routes.dart';

class LoginController extends GetxController {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  RxString loggedUsername = "".obs;

  RxBool isPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> login() async {
    try {
      // Tampilkan dialog loading
      GetDialogs.showCircularLoading();

      String inputUsername = username.text.trim();
      String inputPassword = password.text.trim();

      if (inputUsername.isEmpty || inputPassword.isEmpty) {
        Get.back();
        GetDialogs.showDialog1(
          "Login Gagal",
          "Nama Pengguna atau Kata Sandi tidak boleh kosong!",
        );
        return;
      }

      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Periksa di collection "pegawai"
      DocumentSnapshot adminDoc =
          await firestore.collection('pegawai').doc("admin").get();

      if (adminDoc.exists) {
        final adminData = adminDoc.data() as Map<String, dynamic>;
        if (adminData['username'] == inputUsername &&
            adminData['password'] == inputPassword) {
          // Dapatkan IMEI perangkat
          String? imei = await getIMEI();

          if (adminData['id_perangkat'] == null || adminData['id_perangkat'] == "") {
            if (imei != null && imei != 'Permission Denied') {
              // Update IMEI di Firestore
              await firestore
                  .collection('pegawai')
                  .doc('admin')
                  .update({'id_perangkat': imei});
            }
            Get.back();
            loggedUsername.value = username.text;
            Get.toNamed(Routes.adminDashboardView);
          } else {
            if (adminData['id_perangkat'] == imei) {
              Get.back();
              loggedUsername.value = username.text;
              Get.toNamed(Routes.adminDashboardView);
            } else {
              Get.back();
              GetDialogs.showDialog1("Login Gagal!", "IMEI perangkat kamu tidak cocok");
            }
          }
          return;
        }
      }

      DocumentSnapshot guruDoc =
          await firestore.collection('pegawai').doc(inputUsername).get();

      if (guruDoc.exists) {
        final guruData = guruDoc.data() as Map<String, dynamic>;

        if (guruData['password'] == inputPassword) {
          // Dapatkan IMEI perangkat
          String? deviceId = await getIMEI();

          // Cek apakah guru pertama kali login
          if (guruData['id_perangkat'] == null || guruData['id_perangkat'] == "") {
            if (deviceId != null && deviceId != 'Permission Denied') {
              // Update IMEI di Firestore
              guruData['id_perangkat'] = deviceId;
              await firestore
                  .collection('pegawai')
                  .doc(inputUsername)
                  .update({'id_perangkat': deviceId});
            }
            Get.back();
            loggedUsername.value = username.text;
            Get.toNamed(Routes.guruDashboardView);
          } else {
            if (guruData['id_perangkat'] == deviceId) {
              Get.back();
              loggedUsername.value = username.text;
              Get.toNamed(Routes.guruDashboardView);
            } else {
              Get.back();
              GetDialogs.showDialog1("Login Gagal!", "IMEI tidak cocok");
            }
          }
          return;
        }
      }

      // Jika tidak ada kecocokan username dan password
      Get.back();
      GetDialogs.showDialog1(
        "Login Gagal",
        "Nama Pengguna atau Kata Sandi yang anda masukan salah!",
      );
    } catch (e) {
      Get.back();
      GetDialogs.showDialog1(
        "Kesalahan!",
        e.toString(),
      );
    }
  }

  Future<String?> getIMEI() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // Gunakan Android ID sebagai alternatif
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor; // iOS Identifier
    }
    return null;
  }
}