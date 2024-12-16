import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_guru/constants/color_constant.dart';
import 'package:presensi_guru/constants/textstyle_constant.dart';
import 'package:presensi_guru/utils/routes.dart';

class AdminRekapWidget extends StatelessWidget {
  const AdminRekapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.adminLihatRekapPresensiView);
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorConstant.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Lihat & Rekap Presensi",
                      style: TextstyleConstant.nunitoSansBold.copyWith(
                        color: ColorConstant.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Klik disini untuk melihat dan rekap presensi guru secara otomatis",
                      style: TextstyleConstant.nunitoSansMedium.copyWith(
                        color: ColorConstant.white,
                        fontSize: 14,
                      ),
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.navigate_next,
                color: ColorConstant.white,
                size: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
