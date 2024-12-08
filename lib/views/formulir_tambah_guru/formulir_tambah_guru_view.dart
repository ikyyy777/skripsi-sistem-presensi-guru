import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_guru/constants/color_constant.dart';
import 'package:presensi_guru/constants/textstyle_constant.dart';
import 'package:presensi_guru/controllers/admin_controller.dart';
import 'package:presensi_guru/global_widgets/custom_global_form_field.dart';
import 'package:presensi_guru/global_widgets/gender_global_dropdown_field.dart';

class FormulirTambahGuruView extends StatelessWidget {
  FormulirTambahGuruView({super.key});

  final adminController = Get.put(AdminController());
  final _formKey = GlobalKey<FormState>(); // Tambahkan GlobalKey untuk validasi

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          centerTitle: true,
          title: Text(
            "Tambah Guru",
            style: TextstyleConstant.nunitoSansBold.copyWith(
              color: ColorConstant.black,
              fontSize: 14,
            ),
          ),
          backgroundColor: ColorConstant.white,
          elevation: 0, // Hilangkan elevasi
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 1),
            child: Container(
              color: ColorConstant.grayBorder,
              height: 1, // Ketebalan garis bawah
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, top: 15, right: 16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, // FormKey untuk validasi
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Akun",
                  style: TextstyleConstant.nunitoSansBold.copyWith(
                    fontSize: 16,
                  ),
                ),
                const Divider(),
                const SizedBox(height: 10),
                CustomGlobalFormField(
                  adminController: adminController,
                  title: "Nama Pengguna*",
                  value: adminController.formUsername,
                  hintText: "nama pengguna",
                  dataType: 'String',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Nama pengguna tidak boleh kosong';
                    }
                    if (value.contains(' ')) {
                      return 'Nama pengguna tidak boleh mengandung spasi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomGlobalFormField(
                  adminController: adminController,
                  title: "Kata Sandi*",
                  value: adminController.formPassword,
                  hintText: "kata sandi",
                  dataType: 'String',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Kata sandi tidak boleh kosong';
                    }
                    if (value.contains(' ')) {
                      return 'Kata sandi tidak boleh mengandung spasi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  "Biodata Pribadi",
                  style: TextstyleConstant.nunitoSansBold.copyWith(
                    fontSize: 16,
                  ),
                ),
                const Divider(),
                const SizedBox(height: 10),
                CustomGlobalFormField(
                  adminController: adminController,
                  title: "Nama Lengkap*",
                  value: adminController.formName,
                  hintText: "Nama Lengkap",
                  dataType: 'String',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Nama lengkap tidak boleh kosong';
                    }
                    // Cek apakah nama lengkap mengandung angka atau simbol selain huruf dan spasi
                    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                      return 'Nama lengkap hanya boleh mengandung huruf';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                GenderGlobalDropdownField(
                  adminController: adminController,
                  title: "Jenis Kelamin*",
                  value: adminController.formGender.text,
                  hintText: "Pilih Jenis Kelamin",
                  dataType: 'String',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Jenis kelamin tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomGlobalFormField(
                  adminController: adminController,
                  title: "Tempat, Tanggal Lahir*",
                  value: adminController.formPlaceDateOfBirth,
                  hintText: "Cilacap, 12 Oktober 2003",
                  dataType: 'String',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Tempat dan tanggal lahir tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomGlobalFormField(
                  adminController: adminController,
                  title: "Agama*",
                  value: adminController.formReligion,
                  hintText: "Agama",
                  dataType: 'String',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Agama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomGlobalFormField(
                  adminController: adminController,
                  title: "Alamat*",
                  value: adminController.formAddress,
                  hintText: "Alamat Lengkap",
                  dataType: 'String',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Alamat tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomGlobalFormField(
                  adminController: adminController,
                  title: "Email*",
                  value: adminController.formEmail,
                  hintText: "Email",
                  dataType: 'String',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomGlobalFormField(
                  adminController: adminController,
                  title: "Nomor Telepon*",
                  value: adminController.formPhoneNumber,
                  hintText: "0812345678910",
                  dataType: 'int',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Nomor telepon tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  "Data Kepegawaian",
                  style: TextstyleConstant.nunitoSansBold.copyWith(
                    fontSize: 16,
                  ),
                ),
                const Divider(),
                const SizedBox(height: 10),
                CustomGlobalFormField(
                  adminController: adminController,
                  title: "NIP",
                  value: adminController.formNIP,
                  hintText: "Nomor Induk Pegawai",
                  dataType: 'int',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return null;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomGlobalFormField(
                  adminController: adminController,
                  title: "NUPTK",
                  value: adminController.formNUPTK,
                  hintText: "Nomor Unik Pendidik dan Tenaga Kependidikan",
                  dataType: 'int',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return null;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstant.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Jika form valid, lanjutkan dengan aksi
                        adminController.addGuru();
                        adminController.initPage();
                        Get.back();
                      }
                    },
                    child: Center(
                      child: Text(
                        "Tambahkan Guru",
                        style: TextstyleConstant.nunitoSansMedium.copyWith(
                          color: ColorConstant.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
