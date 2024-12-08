import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_guru/constants/color_constant.dart';
import 'package:presensi_guru/constants/textstyle_constant.dart';
import 'package:presensi_guru/utils/routes.dart';

class AdminTambahGuruButtonWidget extends StatelessWidget {
  const AdminTambahGuruButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorConstant.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Get.toNamed(Routes.formulirTambahGuruView);
          },
          child: Center(
            child: Text(
              "Tambah Guru",
              style: TextstyleConstant.nunitoSansMedium.copyWith(
                color: ColorConstant.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
