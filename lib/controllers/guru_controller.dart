import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:presensi_guru/models/guru_model.dart';
import 'package:presensi_guru/models/presensi_model.dart';
import 'package:presensi_guru/utils/cache.dart';
import 'package:presensi_guru/utils/datetime_getters.dart';
import 'package:presensi_guru/utils/get_dialogs.dart';

class GuruController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Rx<GuruModel?> dataGuru = Rx<GuruModel?>(null);
  Rx<Presensi?> presensiModel = Rx<Presensi?>(null);

  RxBool isPageLoading = true.obs;

  Timer? backgroundTask;

  int yearNow = DatetimeGetters.getYearNow();
  int monthNow = DateTime.now().month;
  int dayNow = DateTime.now().day;

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

  void initPage() async {
    isPageLoading.value = true;
    await getTeacherData();
    presensiModel.value = await getTeacherPresenceData(
        Cache.loggedUsername, yearNow, monthNow);
    isPageLoading.value = false;
  }

  void startBackgroundTask() {
    backgroundTask =
        Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
      await getTeacherData();
      presensiModel.value = await getTeacherPresenceData(
          Cache.loggedUsername, yearNow, monthNow);
    });
  }

  Future<void> getTeacherData() async {
    try {
      DocumentSnapshot doc = await firestore
          .collection('pegawai')
          .doc(Cache.loggedUsername)
          .get();
      dataGuru.value = GuruModel.fromDocumentSnapshot(doc);
    } catch (e) {
      log(e.toString());
    }
  }

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

  String checkOntime() {
    // Ambil waktu saat ini
    DateTime sekarang = DateTime.now();

    // Tentukan batas waktu presensi hari ini (pukul 09:00)
    DateTime batasPresensi =
        DateTime(sekarang.year, sekarang.month, sekarang.day, 9, 0, 0);

    // Bandingkan waktu presensi dengan batas presensi
    if (sekarang.isBefore(batasPresensi)) {
      return "ontime";
    } else {
      return "telat";
    }
  }

  Future<bool> isConnectedWifiSchool() async {
    final info = NetworkInfo();
    if (await Permission.locationWhenInUse.request().isGranted) {
      final wifiBSSID = await info.getWifiBSSID(); // MAC Address

      if (wifiBSSID == "90:55:de:19:dd:f0") {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<void> postPresence() async {
    try {
      final keterangan = checkOntime();
      String todayDateTime = DatetimeGetters.getFormattedDateTimeNow();
      String todayDate = DatetimeGetters.getDateNowInt();
      String jamMasuk = DateTime.now().toString().split(" ")[1].substring(0, 8);

      // Validasi hari Sabtu dan Minggu
      int todayWeekday = DateTime.now().weekday; // 6 = Sabtu, 7 = Minggu
      if (todayWeekday == 6 || todayWeekday == 7) {
        GetDialogs.showDialog1("Maaf",
            "Presensi tidak dapat dilakukan pada hari Sabtu atau Minggu.");
        return;
      }

      String presensiId =
          "${Cache.loggedUsername}_${yearNow}_$monthNow";
      String riwayatId =
          "${Cache.loggedUsername}_${yearNow}_${monthNow}_$dayNow";

      // Check if user already has attendance for today
      QuerySnapshot riwayatData = await firestore
          .collection('riwayat_presensi')
          .where('riwayat_id', isEqualTo: riwayatId)
          .get();

      if (riwayatData.docs.isNotEmpty) {
        // Show dialog if already marked attendance today
        GetDialogs.showDialog1(
            "Gagal Presensi", "Presensi hanya bisa dilakukan sekali per hari.");
        return;
      }

      // Check if presensi document exists
      QuerySnapshot presensiData = await firestore
          .collection('presensi')
          .where('presensi_id', isEqualTo: presensiId)
          .get();

      if (presensiData.docs.isEmpty) {
        // If presensi document doesn't exist, create it
        await firestore.collection('presensi').doc(presensiId).set({
          "presensi_id": presensiId,
          "username": Cache.loggedUsername,
          "tahun": yearNow,
          "bulan": monthNow,
          "total_hadir": 1,
          "total_cuti": 0,
          "total_telat": 0,
          "dibuat_pada": todayDate,
        });
      } else {
        // If presensi document exists, update total_hadir or total_telat
        DocumentSnapshot presensiDoc = presensiData.docs.first;
        int totalHadir = presensiDoc['total_hadir'];
        int totalTelat = presensiDoc['total_telat'];

        // Update the total_hadir or total_telat based on keterangan (if needed)
        if (keterangan == "Hadir") {
          totalHadir++;
        } else if (keterangan == "Telat") {
          totalTelat++;
        }

        await firestore.collection('presensi').doc(presensiId).update({
          "total_hadir": totalHadir,
          "total_telat": totalTelat,
        });
      }

      // Tambah dokumen baru ke koleksi "riwayat_presensi"
      await firestore.collection('riwayat_presensi').doc(riwayatId).set({
        "riwayat_id": riwayatId,
        "presensi_id": presensiId,
        "tanggal_presensi": todayDateTime,
        "jam_masuk": jamMasuk,
        "keterangan": keterangan,
        "dibuat_pada": todayDate,
      });

      GetDialogs.showSnackBar1(
          "Sukses Presensi", "Terima kasih sudah presensi");
      initPage();
    } catch (e) {
      log(e.toString());
      GetDialogs.showDialog1(
          "Gagal Presensi", "Terjadi kesalahan, coba lagi nanti.");
    }
  }
}
