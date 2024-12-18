import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_guru/constants/color_constant.dart';
import 'package:presensi_guru/constants/textstyle_constant.dart';
import 'package:presensi_guru/controllers/admin_controller.dart';
import 'package:presensi_guru/views/formulir_edit_guru/formulir_edit_guru.dart';

class AdminDaftarGuruWidget extends StatelessWidget {
  AdminDaftarGuruWidget({super.key});

  final adminController = Get.put(AdminController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Daftar Guru",
          style: TextstyleConstant.nunitoSansBold.copyWith(
            fontSize: 14,
            color: ColorConstant.black,
          ),
        ),
        const Divider(),
        Obx(() {
          if (adminController.daftarGuru.isEmpty) {
            return Center(
              child: Text(
                "Tidak ada data guru",
                style: TextstyleConstant.nunitoSansMedium.copyWith(
                  fontSize: 14,
                  color: ColorConstant.gray30,
                ),
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: adminController.daftarGuru.length,
            itemBuilder: (BuildContext context, int index) {
              final guru = adminController.daftarGuru[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.person),
                title: Text(
                  guru.nama,
                  style: TextstyleConstant.nunitoSansMedium.copyWith(
                    fontSize: 14,
                    color: ColorConstant.black,
                  ),
                ),
                subtitle: Text("NIP ${guru.nip}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(()=> FormulirEditGuru(index: index));
                      },
                      child: const Icon(
                        Icons.edit,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        adminController.deleteGuru(guru.username, context);
                      },
                      child: const Icon(
                        Icons.delete,
                        size: 24,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ],
    );
  }
}
