import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_guru/constants/color_constant.dart';
import 'package:presensi_guru/constants/textstyle_constant.dart';
import 'package:presensi_guru/controllers/admin_controller.dart';
import 'package:presensi_guru/utils/datetime_getters.dart';

class AdminProfileWidget extends StatelessWidget {
  AdminProfileWidget({super.key});

  final adminController = Get.put(AdminController());

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage("assets/images/admin_profile.png"),
          ),
          border: Border.all(
            color: ColorConstant.grayBorder,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(90),
        ),
      ),
      title: Text(
        "Selamat ${DatetimeGetters.getTimeOfDay()}",
        style: TextstyleConstant.nunitoSansBold
            .copyWith(fontSize: 12, color: ColorConstant.black50),
      ),
      subtitle: Text(
        "Administrator",
        style: TextstyleConstant.nunitoSansBold
            .copyWith(fontSize: 16, color: ColorConstant.black),
      ),
      trailing: GestureDetector(
        onTap: () {
          showChangePasswordDialog(context);
        },
        child: Text(
          "Ubah Kata Sandi",
          style: TextstyleConstant.nunitoSansBold
              .copyWith(fontSize: 12, color: ColorConstant.black50),
        ),
      ),
    );
  }

  void showChangePasswordDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Ubah Kata Sandi",
            style: TextstyleConstant.nunitoSansBold.copyWith(fontSize: 16),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Kata Sandi Baru",
                    labelStyle: TextstyleConstant.nunitoSansMedium.copyWith(
                      color: ColorConstant.black,
                      fontSize: 14,
                    ),
                    hintText: "Masukkan kata sandi baru",
                    hintStyle: TextstyleConstant.nunitoSansMedium.copyWith(
                      color: ColorConstant.black50,
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: ColorConstant.blue), // Active border color
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kata sandi baru tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Konfirmasi Kata Sandi",
                    labelStyle: TextstyleConstant.nunitoSansMedium.copyWith(
                      color: ColorConstant.black,
                      fontSize: 14,
                    ),
                    hintText: "Masukkan ulang kata sandi",
                    hintStyle: TextstyleConstant.nunitoSansMedium.copyWith(
                      color: ColorConstant.black,
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: ColorConstant.blue), // Active border color
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Konfirmasi kata sandi tidak boleh kosong';
                    }
                    if (value != newPasswordController.text) {
                      return 'Kata sandi tidak sama';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Menutup dialog tanpa melakukan apa-apa
                Navigator.of(context).pop();
              },
              child: Text(
                "Batal",
                style: TextstyleConstant.nunitoSansBold.copyWith(
                  fontSize: 14,
                  color: ColorConstant.black50,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  // Jika validasi berhasil, lakukan proses ubah kata sandi
                  adminController.updatePassword(newPasswordController.text);

                  Navigator.of(context).pop(); // Menutup dialog
                }
              },
              child: Text(
                "Ok",
                style: TextstyleConstant.nunitoSansBold.copyWith(
                  fontSize: 14,
                  color: ColorConstant.blue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
