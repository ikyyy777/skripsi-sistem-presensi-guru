import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_guru/constants/color_constant.dart';
import 'package:presensi_guru/constants/textstyle_constant.dart';
import 'package:presensi_guru/controllers/guru_controller.dart';
import 'package:presensi_guru/utils/datetime_getters.dart';
import 'package:presensi_guru/views/guru_dashboard/widgets/guru_card_widget.dart';
import 'package:presensi_guru/views/guru_dashboard/widgets/guru_profile_widget.dart';
import 'package:presensi_guru/views/guru_dashboard/widgets/guru_riwayat_presensi_widget.dart';
import 'package:presensi_guru/views/guru_dashboard/widgets/guru_tombol_presensi_widget.dart';

class GuruDashboardView extends StatelessWidget {
  GuruDashboardView({super.key});

  final guruController = Get.put(GuruController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      body: SafeArea(child: Obx(
        () {
          if (guruController.isPageLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorConstant.blue,
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GuruProfileWidget(),
                    const SizedBox(height: 15),
                    GuruCardWidget(),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        DatetimeGetters.getFormattedDateTimeNow(),
                        style: TextstyleConstant.nunitoSansMedium,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Center(child: GuruTombolPresensiWidget()),
                    const SizedBox(height: 50),
                    GuruRiwayatPresensiWidget()
                  ],
                ),
              ),
            );
          }
        },
      )),
    );
  }
}
