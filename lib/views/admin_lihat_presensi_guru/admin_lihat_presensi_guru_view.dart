import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_guru/constants/color_constant.dart';
import 'package:presensi_guru/constants/textstyle_constant.dart';
import 'package:presensi_guru/controllers/admin_controller.dart';
import 'package:presensi_guru/models/presensi_model.dart';
import 'package:presensi_guru/views/admin_lihat_presensi_guru/widgets/admin_periode_bulan_rekap_widget.dart';
import 'package:presensi_guru/views/admin_lihat_presensi_guru/widgets/admin_riwayat_presensi_widget.dart';

class AdminLihatPresensiGuruView extends StatelessWidget {
  AdminLihatPresensiGuruView({super.key, required this.usernameGuru});

  final String usernameGuru;
  final adminController = Get.put(AdminController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Riwayat Presensi Guru",
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
        child: FutureBuilder<Presensi?>(
          future: adminController.getDataPresensiGuru(
            usernameGuru,
            adminController.yearNow,
            adminController.monthNow,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: ColorConstant.blue,
              ));
            } else if (adminController.selectedDataGuru.value == null) {
              return Center(
                  child: CircularProgressIndicator(
                color: ColorConstant.blue,
              ));
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(
                child: Text(
                  "Tidak ada data presensi",
                  style: TextstyleConstant.nunitoSansBold.copyWith(
                    fontSize: 16,
                    color: ColorConstant.black,
                  ),
                ),
              );
            } else {
              final presensi = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    AdminPeriodeBulanRekapWidget(
                      presensi: presensi,
                      guru: adminController.selectedDataGuru.value!,
                      year: adminController.yearNow.toString(),
                      month: adminController.monthNow.toString(),
                    ),
                    const SizedBox(height: 10),
                    AdminRiwayatPresensiWidget(presensi: presensi),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
