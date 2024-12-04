import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_guru/constants/color_constant.dart';
import 'package:presensi_guru/constants/textstyle_constant.dart';
import 'package:presensi_guru/controllers/guru_controller.dart';
import 'package:presensi_guru/models/presensi_model.dart';

class RiwayatPresensiWidget extends StatelessWidget {
  RiwayatPresensiWidget({super.key, required this.month});

  final guruController = Get.put(GuruController());
  final String month;

  Presensi get monthPresensi {
    // Extract the monthPresensi logic into a getter
    return guruController.presensiModel.value!.presensiData.values
        .expand((yearData) => yearData)
        .firstWhere(
          (presensi) => presensi.bulan == month,
          orElse: () => Presensi(
            bulan: month,
            totalHadir: 0,
            totalCuti: 0,
            totalTelat: 0,
            riwayatPresensi: [],
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Riwayat Presensi",
          style: TextstyleConstant.nunitoSansBold.copyWith(
            color: ColorConstant.black,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 20),
        Obx(() {
          int totalPresensi = monthPresensi.riwayatPresensi.length;

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
                var presensiItem =
                    monthPresensi.riwayatPresensi.reversed.toList()[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: ColorConstant.grayBorder), // Border color
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
