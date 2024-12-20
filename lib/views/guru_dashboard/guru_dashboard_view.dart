import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:presensi_guru/constants/color_constant.dart';
import 'package:presensi_guru/constants/textstyle_constant.dart';
import 'package:presensi_guru/controllers/guru_controller.dart';
import 'package:presensi_guru/utils/datetime_getters.dart';
import 'package:presensi_guru/views/guru_dashboard/widgets/guru_card_widget.dart';
import 'package:presensi_guru/views/guru_dashboard/widgets/guru_profile_widget.dart';
import 'package:presensi_guru/views/guru_dashboard/widgets/guru_riwayat_presensi_widget.dart';
import 'package:presensi_guru/views/guru_dashboard/widgets/guru_tombol_presensi_widget.dart';

// ignore: must_be_immutable
class GuruDashboardView extends StatelessWidget {
  GuruDashboardView({super.key});

  final guruController = Get.put(GuruController());
  DateTime? lastPressed;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        final now = DateTime.now();
        const maxDuration = Duration(seconds: 2);
        final isWarning = lastPressed == null || now.difference(lastPressed!) > maxDuration;

        if (isWarning) {
          lastPressed = DateTime.now();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tekan sekali lagi untuk keluar'),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: ColorConstant.white,
        body: SafeArea(
          child: Obx(
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
                        const Center(child: GuruTombolPresensiWidget()),
                        const SizedBox(height: 50),
                        GuruRiwayatPresensiWidget()
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
