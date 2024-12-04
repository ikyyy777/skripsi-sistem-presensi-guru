import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:presensi_guru/controllers/login_controller.dart';
import 'package:presensi_guru/models/guru_model.dart';
import 'package:presensi_guru/models/presensi_model.dart';
import 'package:presensi_guru/utils/datetime_getters.dart';
import 'package:presensi_guru/utils/get_dialogs.dart';

class GuruController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Rx<GuruModel?> dataGuru = Rx<GuruModel?>(null);
  Rx<PresensiModel?> presensiModel = Rx<PresensiModel?>(null);

  RxBool isPageLoading = true.obs;

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

  void initPage() async {
    isPageLoading.value = true;
    await fetchDataGuru();
    presensiModel.value = await fetchDataPresensi();
    isPageLoading.value = false;
  }

  void startBackgroundTask() {
    backgroundTask =
        Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
      await fetchDataGuru();
      presensiModel.value = await fetchDataPresensi();
    });
  }

  Future<void> fetchDataGuru() async {
    try {
      final loginController = Get.put(LoginController());
      DocumentSnapshot doc = await firestore
          .collection('pegawai')
          .doc(loginController.loggedUsername.value)
          .get();
      dataGuru.value = GuruModel.fromDocumentSnapshot(doc);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<PresensiModel?> fetchDataPresensi() async {
    try {
      final loginController = Get.put(LoginController());
      DocumentReference docRef = firestore
          .collection('presensi')
          .doc(loginController.loggedUsername.value);
      DocumentSnapshot doc = await docRef.get();

      if (doc.exists) {
        // Mengambil data dari Firestore dan mengonversinya ke dalam model
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return PresensiModel.fromMap(
            loginController.loggedUsername.value, data);
      } else {
        // Jika dokumen tidak ada
        GetDialogs.showDialog1(
            "Fatal Error", "Dokumen presensi tidak ditemukan pada database");
        return null;
      }
    } catch (e) {
      // Menangani error jika terjadi masalah saat mengambil data
      log(e.toString());
      GetDialogs.showDialog1(
          "Fatal Error", "Terjadi kesalahan saat mengambil data");
      return null;
    }
  }

  String checkTepatWaktu() {
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

  Future<void> kirimPresensi() async {
    try {
      // if (true) {
      if (await isConnectedWifiSchool()) {
        final loginController = Get.put(LoginController());
        final keterangan = checkTepatWaktu();
        String yearNow = DatetimeGetters.getYearNow();
        String monthNow = DateTime.now().month.toString();
        String monthNowIndo =
            DatetimeGetters.bulanIndo[int.parse(monthNow) - 1];
        String todayDate = DatetimeGetters.getFormattedDateTimeNow();
        String jamMasuk = DateTime.now()
            .toString()
            .split(" ")[1]
            .substring(0, 8); // Get HH-MM-SS

        // Validasi hari Sabtu dan Minggu
        int todayWeekday = DateTime.now().weekday; // 6 = Sabtu, 7 = Minggu
        if (todayWeekday == 6 || todayWeekday == 7) {
          GetDialogs.showDialog1("Maaf",
              "Presensi tidak dapat dilakukan pada hari Sabtu atau Minggu.");
          return;
        }

        DocumentReference docRef = firestore
            .collection('presensi')
            .doc(loginController.loggedUsername.value);
        DocumentSnapshot doc = await docRef.get();

        if (doc.exists) {
          Map<String, dynamic> presensiData =
              doc.data() as Map<String, dynamic>;

          // Jika tahun sudah ada
          if (presensiData.containsKey(yearNow)) {
            List<dynamic> yearData = presensiData[yearNow];
            var monthData = yearData.firstWhere(
                (month) => month['bulan'] == monthNowIndo,
                orElse: () => null);

            if (monthData != null) {
              // Cek apakah hari ini sudah presensi
              bool alreadyPresensi = monthData['riwayat_presensi']
                  .any((entry) => entry['tanggal_presensi'] == todayDate);

              if (alreadyPresensi) {
                GetDialogs.showDialog1(
                    "Maaf", "Kamu cuma bisa presensi satu kali setiap hari");
                return;
              }

              // Jika belum presensi, tambahkan riwayat presensi
              monthData['riwayat_presensi'].add({
                'keterangan': keterangan,
                'jam_masuk': jamMasuk,
                'tanggal_presensi': todayDate
              });

              // Perbarui total counts
              if (keterangan == 'ontime') {
                monthData['total_hadir']++;
              } else if (keterangan == 'telat') {
                monthData['total_hadir']++;
                monthData['total_telat']++;
              }
              GetDialogs.showSnackBar1(
                  "Sukses Presensi", "Terima kasih sudah presensi hari ini");
              initPage();
            } else {
              // Jika bulan belum ada, tambahkan bulan baru
              yearData.add({
                'bulan': monthNowIndo,
                'total_hadir': keterangan == 'ontime' ? 1 : 0,
                'total_cuti': 0,
                'total_telat': keterangan == 'telat' ? 1 : 0,
                'riwayat_presensi': [
                  {
                    'keterangan': keterangan,
                    'jam_masuk': jamMasuk,
                    'tanggal_presensi': todayDate
                  }
                ]
              });
              GetDialogs.showSnackBar1(
                  "Sukses Presensi", "Terima kasih sudah presensi hari ini");
              initPage();
            }

            // Update kembali dokumen di Firestore
            await docRef.update({yearNow: yearData});
          } else {
            // Jika tahun belum ada, buat tahun baru
            await docRef.set({
              yearNow: [
                {
                  'bulan': monthNowIndo,
                  'total_hadir': keterangan == 'ontime' ? 1 : 0,
                  'total_cuti': 0,
                  'total_telat': keterangan == 'telat' ? 1 : 0,
                  'riwayat_presensi': [
                    {
                      'keterangan': keterangan,
                      'jam_masuk': jamMasuk,
                      'tanggal_presensi': todayDate
                    }
                  ]
                }
              ]
            });
            GetDialogs.showSnackBar1(
                "Sukses Presensi", "Terima kasih sudah presensi hari ini");
            initPage();
          }
        } else {
          // Jika dokumen presensi belum ada, buat dokumen baru
          await docRef.set({
            yearNow: [
              {
                'bulan': monthNowIndo,
                'total_hadir': keterangan == 'ontime' ? 1 : 0,
                'total_cuti': 0,
                'total_telat': keterangan == 'telat' ? 1 : 0,
                'riwayat_presensi': [
                  {
                    'keterangan': keterangan,
                    'jam_masuk': jamMasuk,
                    'tanggal_presensi': todayDate
                  }
                ]
              }
            ]
          });
          GetDialogs.showSnackBar1(
              "Sukses Presensi", "Terima kasih sudah presensi hari ini");
          initPage();
        }
      } else {
        GetDialogs.showDialog1(
            "Gagal Presensi", "Kamu tidak terhubung ke jaringan sekolah!");
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
