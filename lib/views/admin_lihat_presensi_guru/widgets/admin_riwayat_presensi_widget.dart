import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:presensi_guru/constants/color_constant.dart';
import 'package:presensi_guru/constants/textstyle_constant.dart';
import 'package:presensi_guru/models/presensi_model.dart';

class AdminRiwayatPresensiWidget extends StatelessWidget {
  const AdminRiwayatPresensiWidget({super.key, required this.presensi});

  final Presensi presensi;

  @override
  Widget build(BuildContext context) {
    // Sort the list by "dibuat_pada" in descending order
    presensi.riwayatPresensi.sort((a, b) {
      DateTime dateA = DateFormat('dd-MM-yyyy').parse(a.dibuatPada);
      DateTime dateB = DateFormat('dd-MM-yyyy').parse(b.dibuatPada);
      return dateB.compareTo(dateA);
    });

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
        // Check if the list is empty
        presensi.riwayatPresensi.isEmpty
            ? Center(
                child: Text(
                  "Tidak ada data presensi",
                  style: TextstyleConstant.nunitoSansMedium.copyWith(
                    fontSize: 14,
                    color: ColorConstant.gray30,
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: presensi.riwayatPresensi.length,
                itemBuilder: (BuildContext context, int index) {
                  var presensiItem = presensi.riwayatPresensi[index];

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
              ),
      ],
    );
  }
}
