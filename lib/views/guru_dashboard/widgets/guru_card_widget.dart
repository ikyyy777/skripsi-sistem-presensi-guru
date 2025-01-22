import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_guru/constants/color_constant.dart';
import 'package:presensi_guru/constants/textstyle_constant.dart';
import 'package:presensi_guru/controllers/guru_controller.dart';
import 'package:presensi_guru/controllers/login_controller.dart';
import 'package:presensi_guru/models/presensi_model.dart';
import 'package:presensi_guru/utils/cache.dart';
import 'package:presensi_guru/utils/datetime_getters.dart';

class GuruCardWidget extends StatelessWidget {
  GuruCardWidget({super.key});

  final guruController = Get.put(GuruController());
  final loginController = Get.put(LoginController());

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
                        FutureBuilder<Presensi?>(
                          future: guruController.getTeacherPresenceData(
                            Cache.loggedUsername,
                            guruController.yearNow,
                            guruController.monthNow,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              Presensi presensiModel = snapshot.data!;

                              // Mencari data bulan untuk tahun dan bulan sekarang
                              var monthData =
                                  presensiModel.riwayatPresensi.firstWhere(
                                (entry) {
                                  // Parse tanggalPresensi from format 'Minggu, 8 Desember 2024' to 'yyyy-MM-dd'
                                  DateTime entryDate =
                                      DatetimeGetters.parseFormattedDate(
                                          entry.tanggalPresensi);

                                  // Compare entryDate with the current year and month
                                  String currentMonthString =
                                      '${guruController.yearNow}-${guruController.monthNow.toString().padLeft(2, '0')}';
                                  return '${entryDate.year}-${entryDate.month.toString().padLeft(2, '0')}' ==
                                      currentMonthString;
                                },
                                orElse: () => RiwayatPresensi(
                                  riwayatId: '',
                                  presensiId: '',
                                  tanggalPresensi: '',
                                  jamMasuk: '',
                                  jamKeluar: null,
                                  keterangan: 'Belum Absen',
                                  dibuatPada: '',
                                ),
                              );

                              // Mengecek apakah sudah absen hari ini
                              bool isAbsen = monthData.tanggalPresensi ==
                                  DatetimeGetters.getFormattedDateTimeNow();

                              if (isAbsen) {
                                // Jika sudah absen, tampilkan jam presensi
                                return Text(
                                  monthData.jamMasuk,
                                  style:
                                      TextstyleConstant.nunitoSansBold.copyWith(
                                    color: ColorConstant.white,
                                    fontSize: 16,
                                  ),
                                );
                              } else {
                                // Jika belum absen, tampilkan pesan belum presensi
                                return Text(
                                  "Belum Presensi",
                                  style:
                                      TextstyleConstant.nunitoSansBold.copyWith(
                                    color: ColorConstant.white,
                                    fontSize: 16,
                                  ),
                                );
                              }
                            } else {
                              // Jika data bulan tidak ditemukan
                              return Text(
                                "Belum Presensi",
                                style:
                                    TextstyleConstant.nunitoSansBold.copyWith(
                                  color: ColorConstant.white,
                                  fontSize: 16,
                                ),
                              );
                            }
                          },
                        ),
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
                          "07:00:00",
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
