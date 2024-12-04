import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_guru/constants/color_constant.dart';
import 'package:presensi_guru/constants/textstyle_constant.dart';
import 'package:presensi_guru/controllers/guru_controller.dart';
import 'package:presensi_guru/models/presensi_model.dart';
import 'package:presensi_guru/utils/datetime_getters.dart';

class GuruCardWidget extends StatelessWidget {
  GuruCardWidget({super.key});

  final guruController = Get.put(GuruController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorConstant.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Guru",
              style: TextstyleConstant.nunitoSansMedium
                  .copyWith(fontSize: 14, color: ColorConstant.white),
            ),
            const SizedBox(height: 5),
            Obx(
              () => Text(
                "NIP ${guruController.dataGuru.value?.nip ?? ""}",
                style: TextstyleConstant.nunitoSansBold
                    .copyWith(fontSize: 16, color: ColorConstant.white),
              ),
            ),
            const SizedBox(height: 18),
            Container(
              height: 83,
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorConstant.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Masuk",
                          style: TextstyleConstant.nunitoSansMedium.copyWith(
                            color: ColorConstant.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Obx(() {
                          return FutureBuilder<PresensiModel?>(
                            future: guruController
                                .fetchDataPresensi(), // Mengambil data presensi
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                PresensiModel presensiModel = snapshot.data!;
                                // Mendapatkan data tahun dan bulan sekarang
                                String yearNow = DatetimeGetters.getYearNow();
                                String monthNow =
                                    DateTime.now().month.toString();
                                String monthNowIndo = DatetimeGetters
                                    .bulanIndo[int.parse(monthNow) - 1];
                                String todayDate = DatetimeGetters.getFormattedDateTimeNow();

                                // Mencari data bulan untuk tahun dan bulan sekarang
                                var yearData =
                                    presensiModel.presensiData[yearNow];
                                var monthData = yearData!.firstWhere(
                                  (month) => month.bulan == monthNowIndo,
                                  orElse: () => Presensi(
                                      bulan: monthNowIndo,
                                      totalHadir: 0,
                                      totalCuti: 0,
                                      totalTelat: 0,
                                      riwayatPresensi: []),
                                );

                                if (monthData != null) {
                                  // Mengecek apakah sudah absen hari ini
                                  bool isAbsen = monthData.riwayatPresensi.any(
                                      (entry) =>
                                          entry.tanggalPresensi == todayDate);

                                  if (isAbsen) {
                                    // Jika sudah absen, tampilkan jam presensi
                                    String jamMasuk = monthData.riwayatPresensi
                                        .firstWhere((entry) =>
                                            entry.tanggalPresensi == todayDate)
                                        .jamMasuk;
                                    return Text(
                                      jamMasuk,
                                      style: TextstyleConstant.nunitoSansBold.copyWith(
                                        color: ColorConstant.white,
                                        fontSize: 16,
                                      ),
                                    );
                                  } else {
                                    // Jika belum absen, tampilkan pesan belum presensi
                                    return Text(
                                      "Belum Presensi",
                                      style: TextstyleConstant.nunitoSansBold.copyWith(
                                        color: ColorConstant.white,
                                        fontSize: 16,
                                      ),
                                    );
                                  }
                                } else {
                                  // Jika data bulan tidak ditemukan
                                  return const Text("");
                                }
                              }

                              return const Text("");
                            },
                          );
                        }),
                      ],
                    ),
                    VerticalDivider(
                      color: ColorConstant.white,
                    ),
                    Column(
                      children: [
                        Text(
                          "Batas Presensi",
                          style: TextstyleConstant.nunitoSansMedium.copyWith(
                            color: ColorConstant.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "09:00:00",
                          style: TextstyleConstant.nunitoSansBold.copyWith(
                            color: ColorConstant.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
