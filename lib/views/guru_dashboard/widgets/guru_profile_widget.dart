import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_guru/constants/color_constant.dart';
import 'package:presensi_guru/constants/textstyle_constant.dart';
import 'package:presensi_guru/controllers/guru_controller.dart';
import 'package:presensi_guru/utils/datetime_getters.dart';
import 'package:presensi_guru/utils/routes.dart';

class GuruProfileWidget extends StatelessWidget {
  GuruProfileWidget({super.key});

  final guruController = Get.put(GuruController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.guruProfilView);
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(
              color: ColorConstant.grayBorder,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(90),
          ),
          child: guruController.dataGuru.value?.jenisKelamin == "Laki-laki" ? Image.asset(
            "assets/images/male_teacher.png",
            fit: BoxFit.cover,
          ) : Image.asset(
            "assets/images/female_teacher.png", 
            fit: BoxFit.cover,
          )),
        title: Text(
          "Selamat ${DatetimeGetters.getTimeOfDay()}",
          style: TextstyleConstant.nunitoSansBold.copyWith(
            fontSize: 12,
            color: ColorConstant.black50,
          ),
        ),
        subtitle: Obx(
          () => Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                guruController.dataGuru.value?.nama ?? "",
                style: TextstyleConstant.nunitoSansBold.copyWith(
                  fontSize: 16,
                  color: ColorConstant.black,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: ColorConstant.black50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
