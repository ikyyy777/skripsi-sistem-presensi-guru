import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_guru/constants/color_constant.dart';
import 'package:presensi_guru/constants/textstyle_constant.dart';
import 'package:presensi_guru/controllers/guru_controller.dart';
import 'package:presensi_guru/models/presensi_model.dart';
import 'package:presensi_guru/utils/datetime_getters.dart';
import 'package:presensi_guru/views/guru_rekap_presensi/widgets/prediode_bulan_rekap_widget.dart';
import 'package:presensi_guru/views/guru_rekap_presensi/widgets/riwayat_presensi_widget.dart';

class GuruRekapPresensiView extends StatelessWidget {
  GuruRekapPresensiView({super.key, required this.month, required this.year});

  final String month;
  final String year;

  final guruController = Get.put(GuruController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Rekap Presensi",
          style: TextstyleConstant.nunitoSansBold.copyWith(
            color: ColorConstant.black,
            fontSize: 14,
          ),
        ),
        backgroundColor: ColorConstant.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 1),
          child: Container(
            color: ColorConstant.grayBorder,
            height: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrediodeBulanRekapWidget(month: month, year: year),
              const SizedBox(height: 10),
              RiwayatPresensiWidget(month: month)
            ],
          ),
        ),
      ),
    );
  }
}
