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
import 'package:presensi_guru/models/presensi_model.dart';
import 'package:presensi_guru/utils/datetime_getters.dart';
import 'package:presensi_guru/utils/get_dialogs.dart';
import 'package:open_file/open_file.dart';

/// Controller untuk mengelola fungsi-fungsi admin
class AdminController extends GetxController {
  // Form Controllers untuk akun
  TextEditingController formUsername = TextEditingController();
  TextEditingController formPassword = TextEditingController();

  // Form Controllers untuk biodata pribadi
  TextEditingController formName = TextEditingController();
  TextEditingController formGender = TextEditingController();
  TextEditingController formPlaceDateOfBirth = TextEditingController();
  TextEditingController formReligion = TextEditingController();
  TextEditingController formAddress = TextEditingController();
  TextEditingController formEmail = TextEditingController();
  TextEditingController formPhoneNumber = TextEditingController();

  // Form Controllers untuk data kepegawaian
  TextEditingController formNIP = TextEditingController();
  TextEditingController formNUPTK = TextEditingController();

  // Instance Firestore untuk akses database
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // List observable untuk menyimpan data guru dalam bentuk list
  RxList<GuruModel> daftarGuru = <GuruModel>[].obs;

  // Observable values untuk data admin
  RxInt totalGuru = 0.obs;
  RxString deviceId = "".obs;

  // Utility classes
  DatetimeGetters datetimeGetters = DatetimeGetters();
  Timer? backgroundTask;

  // Variabel untuk periode
  int yearNow = DatetimeGetters.getYearNow();
  int monthNow = DateTime.now().month;
  int dayNow = DateTime.now().day;

  // Variable untuk menyimpan data guru yang dipilih
  Rx<GuruModel?> selectedDataGuru = Rx<GuruModel?>(null);

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

  /// Inisialisasi halaman admin
  Future<void> initPage() async {
    await fetchAdminCardData();
    await getTeachersDataList();
  }

  /// Memulai background task untuk refresh data secara periodik
  void startBackgroundTask() {
    backgroundTask =
        Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
      initPage();
    });
  }

  /// Mengambil data presensi guru
  Future<Presensi?> getTeacherPresenceData(
      String username, int year, int month) async {
    try {
      // Referensi koleksi
      CollectionReference presensiRef =
          FirebaseFirestore.instance.collection('presensi');
      CollectionReference riwayatPresensiRef =
          FirebaseFirestore.instance.collection('riwayat_presensi');

      // ID presensi
      String presensiId = "${username}_${year}_$month";

      // Query presensi
      DocumentSnapshot presensiDoc = await presensiRef.doc(presensiId).get();
      if (!presensiDoc.exists) {
        log("Data presensi tidak ditemukan untuk ID: $presensiId");
        return null;
      }

      // Ambil data presensi
      Map<String, dynamic> presensiData =
          presensiDoc.data() as Map<String, dynamic>;

      // Query riwayat presensi terkait
      QuerySnapshot riwayatPresensiSnapshot = await riwayatPresensiRef
          .where('presensi_id', isEqualTo: presensiId)
          .get();

      // Map riwayat presensi ke model
      List<RiwayatPresensi> riwayatPresensiList =
          riwayatPresensiSnapshot.docs.map((doc) {
        return RiwayatPresensi.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      // Buat model Presensi
      return Presensi.fromMap(presensiData, riwayatPresensiList);
    } catch (e) {
      log("Terjadi kesalahan saat mengambil data presensi: $e");
      return null;
    }
  }

  /// Mengambil data untuk ditampilkan di admin card
  Future<void> fetchAdminCardData() async {
    // Mendapatkan total guru
    QuerySnapshot pegawaiCollection =
        await firestore.collection('pegawai').get();

    // Hitung jumlah dokumen (dikurangi 1 untuk admin)
    int documentCount = pegawaiCollection.docs.length;
    totalGuru.value = documentCount - 1;

    // Mendapatkan device id ponsel terdaftar
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

  /// Mengambil data semua guru dari Firestore
  Future<void> getTeachersDataList() async {
    try {
      QuerySnapshot pegawaiCollection =
          await firestore.collection('pegawai').get();

      // Filter dan mapping data guru
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

  /// Mengambil data presensi guru

  /// Menambahkan data guru baru ke Firestore
  Future<void> addTeacher() async {
    // Cek username duplikat
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

    // Tambah data guru baru
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

  /// Mengupdate password admin
  Future<void> updatePassword(String newPassword) async {
    try {
      DocumentReference adminDocRef =
          firestore.collection("pegawai").doc("admin");

      await adminDocRef.update({
        'password': newPassword,
      });

      GetDialogs.showSnackBar1("Kata Sandi", "Berhasil mengganti kata sandi");
    } catch (e) {
      GetDialogs.showDialog1(
        "Kesalahan!",
        "Terjadi kesalahan saat memperbarui kata sandi.",
      );
      log('Error updating password: $e');
    }
  }

  /// Mengupdate data guru yang sudah ada
  Future<void> updateTeacherData({
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

  /// Menghapus data guru
  Future<void> deleteTeacher(String username, BuildContext context) async {
    try {
      // Dialog konfirmasi penghapusan
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
          content: Text(
            "Apakah Anda yakin ingin menghapus guru ini?",
            style: TextstyleConstant.nunitoSansMedium.copyWith(
              fontSize: 14,
              color: ColorConstant.black,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                "Batal",
                style: TextstyleConstant.nunitoSansMedium.copyWith(
                  color: ColorConstant.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                "Hapus",
                style: TextstyleConstant.nunitoSansMedium.copyWith(
                  color: ColorConstant.blue,
                ),
              ),
            ),
          ],
        ),
      );

      if (confirm == true) {
        await firestore.collection('pegawai').doc(username).delete();
        await getTeachersDataList();

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

  /// Mengambil data rekap presensi untuk periode tertentu
  Future<Map<String, dynamic>> getPresenceRecap({
    required int tahun,
    required int bulan,
  }) async {
    try {
      // Ambil data semua guru kecuali admin
      QuerySnapshot guruSnapshot = await firestore
          .collection('pegawai')
          .where(FieldPath.documentId, isNotEqualTo: "admin")
          .get();

      log('Found ${guruSnapshot.docs.length} teachers');

      Map<String, Map<String, dynamic>> rekapPresensiGuru = {};

      // Loop untuk setiap guru
      for (var guruDoc in guruSnapshot.docs) {
        String username = guruDoc.id;
        String presensiId = "${username}_${tahun}_$bulan";

        log('Processing presensiId for $username: $presensiId');

        // Ambil data presensi guru
        DocumentSnapshot presensiDoc =
            await firestore.collection('presensi').doc(presensiId).get();

        log('Presensi document for $username: ${presensiDoc.exists}');

        // Ambil riwayat presensi
        QuerySnapshot riwayatPresensiSnapshot = await firestore
            .collection('riwayat_presensi')
            .where('presensi_id', isEqualTo: presensiId)
            .get();

        log('Found ${riwayatPresensiSnapshot.docs.length} riwayat presensi for $username');

        // Susun data rekapitulasi
        Map<String, dynamic> guruData = guruDoc.data() as Map<String, dynamic>;

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

  /// Request permission untuk akses storage
  Future<void> requestStoragePermission() async {
    if (await Permission.manageExternalStorage.isDenied) {
      await Permission.manageExternalStorage.request();
    }

    if (await Permission.manageExternalStorage.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  /// Export data rekap presensi ke Excel
  Future<void> exportPresenceDataToExcel(Map<String, dynamic> rekapData) async {
    try {
      await requestStoragePermission();
      GetDialogs.showCircularLoading();
      var excel = Excel.createExcel();
      Sheet sheet = excel['Sheet1'];

      // Setup data periode
      int tahun = rekapData['periode']['tahun'];
      int bulan = rekapData['periode']['bulan'];
      int jumlahHari = DateTime(tahun, bulan + 1, 0).day;

      // Setup headers
      List<dynamic> headers = [
        'Username',
        'Nama Guru',
        'Total Hadir',
        'Total Telat',
        'Total Cuti'
      ];

      List<DateTime> tanggalKerja = [];

      // Tambah tanggal kerja ke header (Senin-Jumat)
      for (int i = 1; i <= jumlahHari; i++) {
        DateTime tanggal = DateTime(tahun, bulan, i);
        if (tanggal.weekday < 6) {
          tanggalKerja.add(tanggal);
          headers
              .add('${tanggal.day}/${bulan.toString().padLeft(2, '0')}/$tahun');
        }
      }

      sheet.appendRow(headers.map((header) => TextCellValue(header)).toList());

      // Tambah data rows
      rekapData['rekap_presensi'].forEach((username, data) {
        List<dynamic> rowData = [];

        rowData.add(TextCellValue(username));
        rowData.add(TextCellValue(data['nama_guru']));
        rowData.add(IntCellValue(data['presensi']['total_hadir'] ?? 0));
        rowData.add(IntCellValue(data['presensi']['total_telat'] ?? 0));
        rowData.add(IntCellValue(data['presensi']['total_cuti'] ?? 0));

        Map<String, String> presensiPerTanggal = {};
        List riwayatPresensi = data['riwayat_presensi'];

        // Mapping data presensi per tanggal
        for (var riwayat in riwayatPresensi) {
          String tanggalRaw = riwayat['tanggal_presensi'];
          List<String> parts = tanggalRaw.split(', ')[1].split(' ');

          String tanggal = parts[0];
          String bulanAngka = DatetimeGetters.bulanIndoInt[parts[1]] ?? '01';
          String tahun = parts[2];

          String tanggalKey = '$tanggal/$bulanAngka/$tahun';

          String keterangan = riwayat['keterangan'];
          String jamMasuk = riwayat['jam_masuk'];
          presensiPerTanggal[tanggalKey] = '$jamMasuk $keterangan';
        }

        // Tambah data presensi untuk tanggal kerja
        for (DateTime tanggal in tanggalKerja) {
          String tanggalKey =
              '${tanggal.day}/${bulan.toString().padLeft(2, '0')}/$tahun';
          rowData.add(TextCellValue(presensiPerTanggal[tanggalKey] ?? '-'));
        }

        sheet.appendRow(rowData.map((cell) => cell as CellValue).toList());
      });

      // Generate nama file
      String timestamp =
          DateTime.now().toString().replaceAll(RegExp(r'[^0-9]'), '');
      String fileName = 'rekap_presensi_$timestamp.xlsx';
      Directory? directory;

      List<int>? excelBytes = excel.encode();
      if (excelBytes != null) {
        // Buat folder "Rekap Presensi" di storage
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

        Get.back();

        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        if (await directory.exists()) {
          await saveFile.writeAsBytes(excelBytes);

          // Dialog sukses
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

  /// Mengirim data cuti guru
  Future<void> postPresenceManual(
      String username, String tanggalPresensi, String keterangan) async {
    try {
      DateTime dateTime = DateTime.parse(tanggalPresensi);
      String formattedTanggal = DatetimeGetters.getFormattedDateTimeNow();
      String todayDate = DatetimeGetters.getDateNowInt();
      String presensiId = "${username}_${dateTime.year}_${dateTime.month}";
      String riwayatId = "${presensiId}_${dateTime.day}";

      // Cek duplikasi presensi
      DocumentSnapshot riwayatDoc =
          await firestore.collection('riwayat_presensi').doc(riwayatId).get();

      if (riwayatDoc.exists) {
        GetDialogs.showDialog1('Gagal', 'Data presensi hari ini sudah ada');
        return;
      }
      if (keterangan == "Hadir") {
        // Cek dan update dokumen presensi
        DocumentSnapshot presensiDoc =
            await firestore.collection('presensi').doc(presensiId).get();

        if (!presensiDoc.exists) {
          await firestore
              .collection('presensi')
              .doc(presensiId)
              .set({'total_hadir': 1, 'total_cuti': 0, 'total_telat': 0});
        } else {
          await firestore.collection('presensi').doc(presensiId).update({
            'total_hadir': FieldValue.increment(1),
          });
        }

        // Simpan riwayat presensi
        await firestore.collection('riwayat_presensi').doc(riwayatId).set({
          'riwayat_id': riwayatId,
          'presensi_id': presensiId,
          'tanggal_presensi': formattedTanggal,
          'keterangan': keterangan,
          'jam_masuk': '-',
          'dibuat_pada': todayDate,
        });
      } else {
        // Cek dan update dokumen presensi
        DocumentSnapshot presensiDoc =
            await firestore.collection('presensi').doc(presensiId).get();

        if (!presensiDoc.exists) {
          await firestore
              .collection('presensi')
              .doc(presensiId)
              .set({'total_cuti': 1, 'total_hadir': 0, 'total_telat': 0});
        } else {
          await firestore.collection('presensi').doc(presensiId).update({
            'total_cuti': FieldValue.increment(1),
          });
        }

        // Simpan riwayat presensi cuti
        await firestore.collection('riwayat_presensi').doc(riwayatId).set({
          'riwayat_id': riwayatId,
          'presensi_id': presensiId,
          'tanggal_presensi': formattedTanggal,
          'keterangan': keterangan,
          'jam_masuk': '-',
          'dibuat_pada': todayDate,
        });

        GetDialogs.showSnackBar1('Berhasil', 'Berhasil mengirim data cuti');
      }
    } catch (e) {
      log('Error kirim cuti: $e');
      GetDialogs.showSnackBar1('Gagal', 'Gagal mengirim data cuti: $e');
    }
  }

  /// Mengambil data guru berdasarkan username
  Future<void> fetchDataGuru(String username) async {
    try {
      DocumentSnapshot doc =
          await firestore.collection('pegawai').doc(username).get();
      selectedDataGuru.value = GuruModel.fromDocumentSnapshot(doc);
    } catch (e) {
      log(e.toString());
    }
  }
}
