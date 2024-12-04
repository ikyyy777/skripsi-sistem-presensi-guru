import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_guru/constants/color_constant.dart';
import 'package:presensi_guru/constants/textstyle_constant.dart';
import 'package:presensi_guru/controllers/admin_controller.dart';

class AdminCardWidget extends StatelessWidget {
  AdminCardWidget({super.key});

  final adminController = Get.put(AdminController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 174,
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
              "Admin",
              style: TextstyleConstant.nunitoSansMedium.copyWith(
                color: ColorConstant.white,
                fontSize: 14,
              ),
            ),
            Text(
              "SMPN Satu Atap 1 Bantarsari",
              style: TextstyleConstant.nunitoSansBold.copyWith(
                color: ColorConstant.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              height: 78,
              decoration: BoxDecoration(
                color: ColorConstant.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Total Guru",
                          style: TextstyleConstant.nunitoSansMedium.copyWith(
                              fontSize: 14, color: ColorConstant.white),
                        ),
                        const SizedBox(height: 5),
                        Obx(
                          () => Text(
                            adminController.totalGuru.value.toString(),
                            style: TextstyleConstant.nunitoSansMedium.copyWith(
                                fontSize: 14, color: ColorConstant.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    VerticalDivider(
                      color: ColorConstant.white,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "ID Perangkat",
                          style: TextstyleConstant.nunitoSansMedium.copyWith(
                            fontSize: 14,
                            color: ColorConstant.white,
                          ),
                        ),
                        Obx(
                          () => Text(
                            adminController.IMEI.value,
                            style: TextstyleConstant.nunitoSansBold.copyWith(
                              fontSize: 16,
                              color: ColorConstant.white,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
