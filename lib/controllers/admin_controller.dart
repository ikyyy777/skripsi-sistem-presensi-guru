import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_guru/constants/color_constant.dart';
import 'package:presensi_guru/constants/textstyle_constant.dart';
import 'package:presensi_guru/models/guru_model.dart';
import 'package:presensi_guru/utils/datetime_getters.dart';
import 'package:presensi_guru/utils/get_dialogs.dart';

class AdminController extends GetxController {
  // akun
  TextEditingController formUsername = TextEditingController();
  TextEditingController formPassword = TextEditingController();

  // biodata pribadi
  TextEditingController formName = TextEditingController();
  TextEditingController formGender = TextEditingController();
  TextEditingController formPlaceDateOfBirth = TextEditingController();
  TextEditingController formReligion = TextEditingController();
  TextEditingController formAddress = TextEditingController();
  TextEditingController formEmail = TextEditingController();
  TextEditingController formPhoneNumber = TextEditingController();

  // data kepegawaian
  TextEditingController formNIP = TextEditingController();
  TextEditingController formNUPTK = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxList<GuruModel> daftarGuru = <GuruModel>[].obs;

  RxInt totalGuru = 0.obs;
  RxString IMEI = "".obs;

  DatetimeGetters datetimeGetters = DatetimeGetters();

  @override
  void onInit() {
    super.onInit();
    initPage();
  }

  Future<void> initPage() async {
    await fetchAdminCardData();
    await fetchDataGuru();
  }

  Future<void> fetchAdminCardData() async {
    // mendapatkan total guru
    // ambil semua document di pegawai
    QuerySnapshot pegawaiCollection =
        await firestore.collection('pegawai').get();

    // Hitung jumlah dokumen
    int documentCount = pegawaiCollection.docs.length;

    totalGuru.value = documentCount - 1;

    // mendapatkan IMEI ponsel terdaftar
    DocumentSnapshot adminDoc =
        await firestore.collection("pegawai").doc("admin").get();
    if (adminDoc.exists) {
      final adminData = adminDoc.data() as Map<String, dynamic>;
      IMEI.value = adminData["IMEI"];
    } else {
      GetDialogs.showDialog1(
          "Kesalahan Fatal!", "Tidak dapat terhubung ke database!");
    }
  }

  Future<void> fetchDataGuru() async {
    try {
      QuerySnapshot pegawaiCollection =
          await firestore.collection('pegawai').get();

      List<GuruModel> fetchedGuru = pegawaiCollection.docs
          .where((doc) => doc.id != "admin") // Skip dokumen "admin"
          .map((doc) => GuruModel.fromDocumentSnapshot(doc))
          .toList();

      daftarGuru.value = fetchedGuru;
    } catch (e) {
      GetDialogs.showDialog1(
        "Kesalahan!",
        "Gagal memuat daftar guru: $e",
      );
      log('Error fetching data guru: $e');
    }
  }

  Future<void> addGuru() async {
    try {
      // Periksa apakah username sudah ada di collection "pegawai"
      QuerySnapshot querySnapshot = await firestore
          .collection('pegawai')
          .where('username', isEqualTo: formUsername.text)
          .get();

      // Jika username sudah ada
      if (querySnapshot.docs.isNotEmpty) {
        // Tampilkan pesan error menggunakan ErrorHandlers
        GetDialogs.showDialog1(
          "Guru sudah terdaftar!",
          "Username guru yang Anda masukkan sudah digunakan. Silakan pilih username lain.",
        );
        return;
      }

      // Jika username belum ada, buat data guru baru di collection "pegawai"
      await firestore.collection('pegawai').doc(formUsername.text).set({
        'username': formUsername.text,
        'password': formPassword.text,
        'nama': formName.text,
        'jenis_kelamin': formGender.text,
        'tempat_tanggal_lahir': formPlaceDateOfBirth.text,
        'agama': formReligion.text,
        'alamat': formAddress.text,
        'email': formEmail.text,
        'no_hp': formPhoneNumber.text,
        'NIP': formNIP.text,
        'NUPTK': formNUPTK.text,
        'IMEI': "",
        'dibuat_pada': FieldValue.serverTimestamp(),
      });

      String yearNow = DatetimeGetters.getYearNow();
      String monthNow = DateTime.now().month.toString();
      String monthNowIndo = DatetimeGetters.bulanIndo[int.parse(monthNow) - 1];
      // Tambahkan dokumen baru di collection "presensi" dengan nama username
      await firestore.collection('presensi').doc(formUsername.text).set({
        yearNow: [
          {
            "bulan": monthNowIndo,
            "total_hadir": 0,
            "total_cuti": 0,
            "total_telat": 0,
            "riwayat_presensi": []
          }
        ]
      });

      // Setelah berhasil menambah data guru, reset form fields jika diperlukan
      formUsername.clear();
      formPassword.clear();
      formName.clear();
      formGender.clear();
      formPlaceDateOfBirth.clear();
      formReligion.clear();
      formAddress.clear();
      formEmail.clear();
      formPhoneNumber.clear();
      formNIP.clear();
      formNUPTK.clear();

      // Opsional: Informasi sukses setelah menambah guru baru
      GetDialogs.showSnackBar1("Guru Ditambahkan", "Berhasil menambah guru");
    } catch (e) {
      // Tangani error lainnya jika terjadi
      GetDialogs.showDialog1(
          "Kesalahan!", "Terjadi kesalahan saat menambahkan guru.");
      log('Error adding guru: $e');
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      // Mendapatkan dokumen admin dari koleksi "pegawai"
      DocumentReference adminDocRef =
          firestore.collection("pegawai").doc("admin");

      // Melakukan update pada field "password"
      await adminDocRef.update({
        'password': newPassword,
      });

      // Tampilkan pesan sukses
      GetDialogs.showSnackBar1("Kata Sandi", "Berhasil mengganti kata sandi");
    } catch (e) {
      // Tangani error jika terjadi kesalahan saat update password
      GetDialogs.showDialog1(
        "Kesalahan!",
        "Terjadi kesalahan saat memperbarui kata sandi.",
      );
      log('Error updating password: $e');
    }
  }

  Future<void> updateGuru({
    required String username,
    required String nama,
    required String jenisKelamin,
    required String tempatTanggalLahir,
    required String agama,
    required String alamat,
    required String email,
    required String noHp,
    required String nip,
    required String nuptk,
    required String password,
  }) async {
    try {
      await firestore.collection('pegawai').doc(username).update({
        'nama': nama,
        'jenis_kelamin': jenisKelamin,
        'tempat_tanggal_lahir': tempatTanggalLahir,
        'agama': agama,
        'alamat': alamat,
        'email': email,
        'no_hp': noHp,
        'NIP': nip,
        'NUPTK': nuptk,
        'password': password,
      });

      GetDialogs.showSnackBar1("Guru Diperbarui", "Berhasil memperbarui data guru");
    } catch (e) {
      GetDialogs.showDialog1(
        "Kesalahan!",
        "Gagal memperbarui data guru: $e",
      );
      log('Error updating guru: $e');
    }
  }

  Future<void> deleteGuru(String username, BuildContext context) async {
    try {
      // Tampilkan dialog konfirmasi menggunakan `showDialog` untuk memastikan hasil `bool` terdeteksi
      bool? confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Konfirmasi Hapus Guru",
            style: TextstyleConstant.nunitoSansMedium.copyWith(
              fontSize: 18,
              color: ColorConstant.black,
            ),
          ),
          content: const Text("Apakah Anda yakin ingin menghapus guru ini?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // Batal
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true), // Hapus
              child: Text(
                "Hapus",
                style: TextStyle(color: ColorConstant.blue),
              ),
            ),
          ],
        ),
      );

      // Jika pengguna mengkonfirmasi hapus
      if (confirm == true) {
        await firestore.collection('pegawai').doc(username).delete();
        await fetchDataGuru();

        GetDialogs.showSnackBar1("Guru Dihapus", "Berhasil hapus guru");
      } else {
        log("Batal hapus");
      }
    } catch (e) {
      GetDialogs.showDialog1(
        "Kesalahan!",
        "Gagal menghapus data guru: $e",
      );
      log('Error deleting guru: $e');
    }
  }
}
