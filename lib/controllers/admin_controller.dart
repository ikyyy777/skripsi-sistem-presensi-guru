// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:presensi_guru/constants/color_constant.dart';
import 'package:presensi_guru/constants/textstyle_constant.dart';
import 'package:presensi_guru/models/guru_model.dart';
import 'package:presensi_guru/utils/datetime_getters.dart';
import 'package:presensi_guru/utils/get_dialogs.dart';
import 'package:open_file/open_file.dart';

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
  RxString deviceId = "".obs;

  DatetimeGetters datetimeGetters = DatetimeGetters();
  Timer? backgroundTask;

  @override
  void onInit() {
    super.onInit();
    initPage();
    startBackgroundTask();
  }

  @override
  void onClose() {
    super.onClose();
    backgroundTask?.cancel();
  }

  Future<void> initPage() async {
    await fetchAdminCardData();
    await fetchDataGuru();
  }

  void startBackgroundTask() {
    backgroundTask =
        Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
      initPage();
    });
  }

  Future<void> fetchAdminCardData() async {
    // mendapatkan total guru
    // ambil semua document di pegawai
    QuerySnapshot pegawaiCollection =
        await firestore.collection('pegawai').get();

    // Hitung jumlah dokumen
    int documentCount = pegawaiCollection.docs.length;

    totalGuru.value = documentCount - 1;

    // mendapatkan device id ponsel terdaftar
    DocumentSnapshot adminDoc =
        await firestore.collection("pegawai").doc("admin").get();
    if (adminDoc.exists) {
      final adminData = adminDoc.data() as Map<String, dynamic>;
      deviceId.value = adminData["id_perangkat"];
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
    // Periksa apakah username sudah ada di collection "pegawai"
    QuerySnapshot querySnapshot = await firestore
        .collection('pegawai')
        .where('username', isEqualTo: formUsername.text)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      GetDialogs.showDialog1(
        "Guru sudah terdaftar!",
        "Username guru yang Anda masukkan sudah digunakan. Silakan pilih username lain.",
      );
      return;
    }

    // Tambah data pegawai ke koleksi "pegawai"
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
      'id_perangkat': "",
      'dibuat_pada': FieldValue.serverTimestamp(),
    });

    // Reset form fields
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

    GetDialogs.showSnackBar1("Guru Ditambahkan", "Berhasil menambah guru");
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
    required String idPerangkat,
  }) async {
    try {
      // Update data guru di collection "Pegawai"
      await firestore.collection('pegawai').doc(username).update({
        'nama': nama,
        'jenis_kelamin': jenisKelamin,
        'tempat_lahir': tempatTanggalLahir,
        'agama': agama,
        'alamat': alamat,
        'email': email,
        'no_hp': noHp,
        'NIP': nip,
        'NUPTK': nuptk,
        'password': password,
        'id_perangkat': idPerangkat,
      });

      GetDialogs.showSnackBar1(
          "Guru Diperbarui", "Berhasil memperbarui data guru");
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

  Future<Map<String, dynamic>> cetakRekapPresensi({
    required int tahun,
    required int bulan,
  }) async {
    try {
      // 1. Ambil semua guru terlebih dahulu
      QuerySnapshot guruSnapshot = await firestore
          .collection('pegawai')
          .where(FieldPath.documentId, isNotEqualTo: "admin")
          .get();

      log('Found ${guruSnapshot.docs.length} teachers');

      Map<String, Map<String, dynamic>> rekapPresensiGuru = {};

      // 2. Loop untuk setiap guru
      for (var guruDoc in guruSnapshot.docs) {
        String username = guruDoc.id;
        String presensiId = "${username}_${tahun}_$bulan"; // Format presensi ID

        // Log to check presensiId
        log('Processing presensiId for $username: $presensiId');

        // 3. Ambil data presensi guru
        DocumentSnapshot presensiDoc =
            await firestore.collection('presensi').doc(presensiId).get();

        log('Presensi document for $username: ${presensiDoc.exists}');

        // 4. Ambil riwayat presensi
        QuerySnapshot riwayatPresensiSnapshot = await firestore
            .collection('riwayat_presensi')
            .where('presensi_id', isEqualTo: presensiId)
            .get();

        log('Found ${riwayatPresensiSnapshot.docs.length} riwayat presensi for $username');

        // 5. Susun data rekapitulasi
        Map<String, dynamic> guruData = guruDoc.data() as Map<String, dynamic>;

        // Prepare presensi data (if exists)
        Map<String, dynamic> presensiData = {};
        if (presensiDoc.exists) {
          presensiData = presensiDoc.data() as Map<String, dynamic>;
        }

        List<Map<String, dynamic>> riwayatPresensi =
            riwayatPresensiSnapshot.docs
                .map((doc) => {
                      'riwayat_id': doc.get('riwayat_id'),
                      'tanggal_presensi': doc.get('tanggal_presensi'),
                      'jam_masuk': doc.get('jam_masuk'),
                      'keterangan': doc.get('keterangan'),
                    })
                .toList();

        // Populate the rekapPresensiGuru map
        log('Inserting data for $username');
        rekapPresensiGuru[username] = {
          'nama_guru': guruData['nama'],
          'presensi': {
            'total_hadir': presensiData['total_hadir'] ?? 0,
            'total_telat': presensiData['total_telat'] ?? 0,
            'total_cuti': presensiData['total_cuti'] ?? 0,
          },
          'riwayat_presensi': riwayatPresensi,
        };
      }

      // Return the result
      return {
        'periode': {
          'tahun': tahun,
          'bulan': bulan,
        },
        'rekap_presensi': rekapPresensiGuru,
      };
    } catch (e) {
      log('Error getting rekap presensi: $e');
      rethrow;
    }
  }

  Future<void> requestStoragePermission() async {
    if (await Permission.manageExternalStorage.isDenied) {
      await Permission.manageExternalStorage.request();
    }

    if (await Permission.manageExternalStorage.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> exportToExcel(Map<String, dynamic> rekapData) async {
    try {
      await requestStoragePermission();
      GetDialogs.showCircularLoading();
      var excel = Excel.createExcel();
      Sheet sheet = excel['Sheet1'];

      // Dapatkan semua tanggal dalam bulan tersebut
      int tahun = rekapData['periode']['tahun'];
      int bulan = rekapData['periode']['bulan'];
      int jumlahHari = DateTime(tahun, bulan + 1, 0).day;

      // Buat header dasar
      List<dynamic> headers = ['Username', 'Nama Guru', 'Total Hadir', 'Total Telat', 'Total Cuti'];
      
      // List untuk menyimpan tanggal kerja (Senin-Jumat)
      List<DateTime> tanggalKerja = [];
      
      // Tambahkan hanya tanggal kerja (Senin-Jumat) ke header
      for (int i = 1; i <= jumlahHari; i++) {
        DateTime tanggal = DateTime(tahun, bulan, i);
        // 6 = Sabtu, 7 = Minggu
        if (tanggal.weekday < 6) {
          tanggalKerja.add(tanggal);
          headers.add('${tanggal.day}/${bulan.toString().padLeft(2, '0')}/$tahun');
        }
      }

      // Tambahkan headers ke Excel
      sheet.appendRow(headers.map((header) => TextCellValue(header)).toList());

      // Tambahkan data rows
      rekapData['rekap_presensi'].forEach((username, data) {
        List<dynamic> rowData = [];
        
        // Data dasar guru
        rowData.add(TextCellValue(username));
        rowData.add(TextCellValue(data['nama_guru']));
        rowData.add(IntCellValue(data['presensi']['total_hadir'] ?? 0));
        rowData.add(IntCellValue(data['presensi']['total_telat'] ?? 0));
        rowData.add(IntCellValue(data['presensi']['total_cuti'] ?? 0));

        // Buat Map untuk menyimpan presensi per tanggal
        Map<String, String> presensiPerTanggal = {};
        List riwayatPresensi = data['riwayat_presensi'];

        // Isi Map dengan data presensi
        for (var riwayat in riwayatPresensi) {
          String tanggalRaw = riwayat['tanggal_presensi'];
          List<String> parts = tanggalRaw.split(', ')[1].split(' ');
          
          Map<String, String> bulanMap = {
            'Januari': '01',
            'Februari': '02',
            'Maret': '03',
            'April': '04',
            'Mei': '05',
            'Juni': '06',
            'Juli': '07',
            'Agustus': '08',
            'September': '09',
            'Oktober': '10',
            'November': '11',
            'Desember': '12',
          };
          
          String tanggal = parts[0];
          String bulanAngka = bulanMap[parts[1]] ?? '01';
          String tahun = parts[2];
          
          String tanggalKey = '$tanggal/$bulanAngka/$tahun';
          
          String keterangan = riwayat['keterangan'];
          String jamMasuk = riwayat['jam_masuk'];
          presensiPerTanggal[tanggalKey] = '$jamMasuk $keterangan';
        }

        // Tambahkan data presensi hanya untuk tanggal kerja
        for (DateTime tanggal in tanggalKerja) {
          String tanggalKey = '${tanggal.day}/${bulan.toString().padLeft(2, '0')}/$tahun';
          rowData.add(TextCellValue(presensiPerTanggal[tanggalKey] ?? '-'));
        }
        
        // Tambahkan row ke Excel
        sheet.appendRow(rowData.map((cell) => cell as CellValue).toList());
      });

      // Generate file name
      String timestamp =
          DateTime.now().toString().replaceAll(RegExp(r'[^0-9]'), '');
      String fileName = 'rekap_presensi_$timestamp.xlsx';
      Directory? directory;

      List<int>? excelBytes = excel.encode();
      if (excelBytes != null) {
        // Create "Rekap Presensi" folder in internal storage
        directory = await getExternalStorageDirectory();
        String newPath = '';
        List<String> folders = directory!.path.split('/');
        for (int x = 1; x < folders.length; x++) {
          String folder = folders[x];
          if (folder != 'Android') {
            newPath += '/' + folder;
          } else {
            break;
          }
        }
        newPath = newPath + '/Rekap Presensi';
        directory = Directory(newPath);

        File saveFile = File('${directory.path}/$fileName');

        // close circular loading
        Get.back();

        // create folder if not exists
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        // create file if not exists
        if (await directory.exists()) {
          await saveFile.writeAsBytes(excelBytes);

          // Show dialog for success
          Get.dialog(
            AlertDialog(
              title: Text(
                'Berhasil',
                style: TextstyleConstant.nunitoSansMedium,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'File rekap presensi telah disimpan di folder Rekap Presensi',
                    style: TextstyleConstant.nunitoSansMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstant.white,
                    ),
                    onPressed: () async {
                      try {
                        final result = await OpenFile.open(saveFile.path);
                        if (result.type != ResultType.done) {
                          GetDialogs.showSnackBar1("Kesalahan",
                              "Gagal membuka file: ${result.message}");
                        }
                        Get.back();
                      } catch (e) {
                        log('Error opening file: $e');
                        GetDialogs.showSnackBar1(
                            "Kesalahan", "Gagal membuka file: $e");
                      }
                    },
                    child: Text(
                      'Buka File',
                      style: TextstyleConstant.nunitoSansMedium
                          .copyWith(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }
    } catch (e) {
      log('Error exporting to Excel: $e');
      GetDialogs.showDialog1("Kesalahan", "Gagal menyimpan file Excel: $e");
    }
  }
}
