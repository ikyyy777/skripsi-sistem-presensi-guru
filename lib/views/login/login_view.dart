import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_guru/constants/color_constant.dart';
import 'package:presensi_guru/constants/textstyle_constant.dart';
import 'package:presensi_guru/controllers/login_controller.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                Center(
                  child: Text(
                    "Sistem Presensi Guru",
                    style: TextstyleConstant.nunitoSansBold.copyWith(
                      fontSize: 16,
                      color: ColorConstant.black,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "SMP N SATU ATAP 1 BANTARSARI",
                    style: TextstyleConstant.nunitoSansBold.copyWith(
                      fontSize: 16,
                      color: ColorConstant.black,
                    ),
                  ),
                ),
                const SizedBox(height: 33),
                Center(
                  child: Image.asset("assets/images/logo.png"),
                ),
                const SizedBox(height: 25),
                Center(
                  child: Text(
                    "Masuk menggunakan akun yang sudah ada",
                    style: TextstyleConstant.nunitoSansRegular.copyWith(
                      fontSize: 16,
                      color: ColorConstant.black,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Nama Pengguna",
                  style: TextstyleConstant.nunitoSansBold.copyWith(
                    fontSize: 14,
                    color: ColorConstant.black50,
                  ),
                ),
                TextFormField(
                  cursorColor: ColorConstant.blue,
                  controller: loginController.username,
                  decoration: InputDecoration(
                    hintText: "Masukan nama pengguna",
                    hintStyle: TextstyleConstant.nunitoSansRegular.copyWith(
                      fontSize: 14,
                      color: ColorConstant.gray30,
                    ),
                    prefixIcon: Icon(
                      Icons.person_2_outlined,
                      color: ColorConstant.gray30,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorConstant.grayBorder),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: ColorConstant.grayBorder, width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Kata Sandi",
                  style: TextstyleConstant.nunitoSansBold.copyWith(
                    fontSize: 14,
                    color: ColorConstant.black50,
                  ),
                ),
                Obx(() {
                  return TextFormField(
                    cursorColor: ColorConstant.blue,
                    controller: loginController.password,
                    obscureText: loginController.isPasswordHidden.value,
                    decoration: InputDecoration(
                      hintText: "Masukan kata sandi",
                      hintStyle: TextstyleConstant.nunitoSansRegular.copyWith(
                        fontSize: 14,
                        color: ColorConstant.gray30,
                      ),
                      prefixIcon: Icon(
                        Icons.key_outlined,
                        color: ColorConstant.gray30,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          loginController.isPasswordHidden.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: ColorConstant.gray30,
                        ),
                        onPressed: loginController.togglePasswordVisibility,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 16.0),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorConstant.grayBorder),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: ColorConstant.grayBorder, width: 2.0),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 33),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstant.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      loginController.login();
                    },
                    child: Center(
                      child: Text(
                        "Masuk",
                        style: TextstyleConstant.nunitoSansMedium.copyWith(
                          color: ColorConstant.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
