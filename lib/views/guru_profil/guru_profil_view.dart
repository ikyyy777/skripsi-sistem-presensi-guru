import 'package:flutter/material.dart';
import 'package:presensi_guru/constants/color_constant.dart';
import 'package:presensi_guru/constants/textstyle_constant.dart';
import 'package:presensi_guru/controllers/guru_controller.dart';
import 'package:get/get.dart';
import 'package:presensi_guru/controllers/login_controller.dart';

class GuruProfilView extends StatelessWidget {
  GuruProfilView({super.key});

  final guruController = Get.put(GuruController());
  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profil",
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Biodata Pribadi",
              style: TextstyleConstant.nunitoSansBold.copyWith(
                color: ColorConstant.black,
                fontSize: 14,
              ),
            ),
            Divider(
              color: ColorConstant.grayBorder,
              thickness: 1,
            ),
            const SizedBox(height: 10),
            _buildBiodataPribadi("Nama", guruController.dataGuru.value?.nama ?? ""),
            const SizedBox(height: 10),
            _buildBiodataPribadi("Jenis Kelamin", guruController.dataGuru.value?.jenisKelamin ?? ""),
            const SizedBox(height: 10),
            _buildBiodataPribadi("Tempat Tanggal Lahir", guruController.dataGuru.value?.tempatTanggalLahir ?? ""),
            const SizedBox(height: 10),
            _buildBiodataPribadi("Agama", guruController.dataGuru.value?.agama ?? ""),
            const SizedBox(height: 10),
            _buildBiodataPribadi("Email", guruController.dataGuru.value?.email ?? ""),
            const SizedBox(height: 10),
            _buildBiodataPribadi("No. HP", guruController.dataGuru.value?.noHp ?? ""),
            const SizedBox(height: 10),
            _buildBiodataPribadi("Alamat", guruController.dataGuru.value?.alamat ?? ""),

            const SizedBox(height: 16),
            Text(
              "Biodata Pribadi",
              style: TextstyleConstant.nunitoSansBold.copyWith(
                color: ColorConstant.black,
                fontSize: 14,
              ),
            ),
            Divider(
              color: ColorConstant.grayBorder,
              thickness: 1,
            ),
            const SizedBox(height: 10),
            _buildBiodataPribadi("NIP", guruController.dataGuru.value?.nip ?? ""),
            const SizedBox(height: 10),
            _buildBiodataPribadi("NUPTK", guruController.dataGuru.value?.nuptk ?? ""),

            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Logika untuk logout
                  loginController.logout();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstant.red,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Logout",
                  style: TextstyleConstant.nunitoSansBold.copyWith(
                    color: ColorConstant.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildBiodataPribadi(String label, String value) {
  return Row(
    children: [
      Text(
        label,
        style: TextstyleConstant.nunitoSansMedium.copyWith(
          color: ColorConstant.black,
          fontSize: 14,
        ),
      ),
      const Spacer(),
      Text(
        value,
        style: TextstyleConstant.nunitoSansMedium.copyWith(
          color: ColorConstant.black50,
          fontSize: 14,
        ),
      ),
    ],
  );
}
