import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_guru/constants/color_constant.dart';
import 'package:presensi_guru/constants/textstyle_constant.dart';
import 'package:presensi_guru/controllers/guru_controller.dart';
import 'package:presensi_guru/models/presensi_model.dart';
import 'package:presensi_guru/utils/datetime_getters.dart';
import 'package:presensi_guru/utils/routes.dart';

class GuruRiwayatPresensiWidget extends StatelessWidget {
  GuruRiwayatPresensiWidget({super.key});

  final guruController = Get.put(GuruController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Riwayat Presensi",
              style: TextstyleConstant.nunitoSansBold.copyWith(
                color: ColorConstant.black,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.guruRiwayatPresensiView);
              },
              child: Text(
                "lihat semua",
                style: TextstyleConstant.nunitoSansBold.copyWith(
                  color: ColorConstant.blue,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Obx(() {
          final riwayatPresensiData = guruController.presensiModel.value;

          // Jika presensiModel null, tampilkan pesan default
          if (riwayatPresensiData == null) {
            return Center(
              child: Text(
                "Data presensi tidak tersedia",
                style: TextstyleConstant.nunitoSansMedium.copyWith(
                  fontSize: 14,
                  color: ColorConstant.gray30,
                ),
              ),
            );
          }

          // Menghitung total riwayat presensi dan limit menjadi 5
          int totalPresensi = riwayatPresensiData.riwayatPresensi.length;
          totalPresensi = totalPresensi > 5 ? 5 : totalPresensi;

          if (totalPresensi == 0) {
            return Center(
              child: Text(
                "Tidak ada data presensi",
                style: TextstyleConstant.nunitoSansMedium.copyWith(
                  fontSize: 14,
                  color: ColorConstant.gray30,
                ),
              ),
            );
          } else {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: totalPresensi,
              itemBuilder: (BuildContext context, int index) {
                // Ambil data riwayat presensi pada bulan ini, dibalik urutannya
                var presensiItem = riwayatPresensiData.riwayatPresensi.reversed
                    .toList()[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: ColorConstant.grayBorder),
                  ),
                  child: ListTile(
                    title: Text(
                      "Jam Masuk",
                      style: TextstyleConstant.nunitoSansMedium.copyWith(
                        fontSize: 10,
                        color: ColorConstant.black,
                      ),
                    ),
                    subtitle: Text(
                      presensiItem.jamMasuk,
                      style: TextstyleConstant.nunitoSansBold.copyWith(
                        color: ColorConstant.black,
                        fontSize: 14,
                      ),
                    ),
                    trailing: Text(
                      presensiItem.tanggalPresensi,
                      style: TextstyleConstant.nunitoSansBold.copyWith(
                        color: ColorConstant.black50,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              },
            );
          }
        }),
      ],
    );
  }
}
