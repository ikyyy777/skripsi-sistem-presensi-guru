import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_guru/constants/color_constant.dart';
import 'package:presensi_guru/constants/textstyle_constant.dart';
import 'package:presensi_guru/controllers/guru_controller.dart';
import 'package:presensi_guru/utils/datetime_getters.dart';

class PrediodeBulanRekapWidget extends StatelessWidget {
  PrediodeBulanRekapWidget({super.key, required this.month, required this.year});

  final guruController = Get.put(GuruController());

  final String month;
  final String year;
  
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final dataPresensi = guruController.presensiModel.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Periode ${DatetimeGetters.bulanIndo[int.parse(month)-1]} $year",
            style: TextstyleConstant.nunitoSansBold.copyWith(
              color: ColorConstant.black,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 15),
          Container(
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
                    guruController.dataGuru.value!.nama,
                    style: TextstyleConstant.nunitoSansMedium.copyWith(
                      color: ColorConstant.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "NIP ${guruController.dataGuru.value!.nip}",
                    style: TextstyleConstant.nunitoSansBold.copyWith(
                      color: ColorConstant.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    height: 81,
                    decoration: BoxDecoration(
                      color: ColorConstant.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Hadir",
                                style: TextstyleConstant.nunitoSansMedium.copyWith(
                                  fontSize: 12,
                                  color: ColorConstant.white,
                                ),
                              ),
                              Text(
                                dataPresensi!.totalHadir.toString(),
                                style: TextstyleConstant.nunitoSansBold.copyWith(
                                  fontSize: 14,
                                  color: ColorConstant.white,
                                ),
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Cuti",
                                style: TextstyleConstant.nunitoSansMedium.copyWith(
                                  fontSize: 12,
                                  color: ColorConstant.white,
                                ),
                              ),
                              Text(
                                dataPresensi.totalCuti.toString(),
                                style: TextstyleConstant.nunitoSansBold.copyWith(
                                  fontSize: 14,
                                  color: ColorConstant.white,
                                ),
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Telat",
                                style: TextstyleConstant.nunitoSansMedium.copyWith(
                                  fontSize: 12,
                                  color: ColorConstant.white,
                                ),
                              ),
                              Text(
                                dataPresensi.totalTelat.toString(),
                                style: TextstyleConstant.nunitoSansBold.copyWith(
                                  fontSize: 14,
                                  color: ColorConstant.white,
                                ),
                              )
                            ],
                          ),
                          VerticalDivider(color: ColorConstant.white),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Dilihat pada",
                                style: TextstyleConstant.nunitoSansMedium.copyWith(
                                  fontSize: 12,
                                  color: ColorConstant.white,
                                ),
                              ),
                              Text(
                                DatetimeGetters.getFormattedDateNow(),
                                style: TextstyleConstant.nunitoSansBold.copyWith(
                                  fontSize: 14,
                                  color: ColorConstant.white,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
