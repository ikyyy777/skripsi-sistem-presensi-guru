import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_guru/constants/color_constant.dart';
import 'package:presensi_guru/constants/textstyle_constant.dart';
import 'package:presensi_guru/controllers/guru_controller.dart';
import 'package:intl/intl.dart';

class RiwayatPresensiWidget extends StatelessWidget {
  RiwayatPresensiWidget({super.key, required this.month});

  final guruController = Get.put(GuruController());
  final String month;

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
          // Access the observable data inside Obx
          final riwayatPresensiData = guruController.presensiModel.value;

          // Check if the list is empty
          if (riwayatPresensiData!.riwayatPresensi.isEmpty) {
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
            // Sort the list by "dibuat_pada" in descending order
            riwayatPresensiData.riwayatPresensi.sort((a, b) {
              DateTime dateA = DateFormat('dd-MM-yyyy').parse(a.dibuatPada);
              DateTime dateB = DateFormat('dd-MM-yyyy').parse(b.dibuatPada);
              return dateB.compareTo(dateA);
            });

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: riwayatPresensiData.riwayatPresensi.length,
              itemBuilder: (BuildContext context, int index) {
                var presensiItem = riwayatPresensiData.riwayatPresensi[index];

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
