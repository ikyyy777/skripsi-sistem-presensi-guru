import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_guru/utils/routes.dart';

class SplashscreenView extends StatefulWidget {
  const SplashscreenView({super.key});

  @override
  State<SplashscreenView> createState() => _SplashscreenViewState();
}

class _SplashscreenViewState extends State<SplashscreenView> {

  Future<void> initializeDatbase() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Periksa apakah dokumen admin ada
      DocumentSnapshot adminDoc =
          await firestore.collection('akun_pegawai').doc('admin').get();

      if (!adminDoc.exists) {
        // Jika admin belum ada, buat dokumen default
        await firestore.collection('akun_pegawai').doc('admin').set({
          "username": "admin",
          "password": "admin123",
          "id_perangkat": "",
        });
      }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed(Routes.loginView);
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