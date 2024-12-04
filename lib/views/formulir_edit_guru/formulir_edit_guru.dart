import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_guru/constants/color_constant.dart';
import 'package:presensi_guru/constants/textstyle_constant.dart';
import 'package:presensi_guru/controllers/admin_controller.dart';

class FormulirEditGuru extends StatelessWidget {
  FormulirEditGuru({
    super.key,
    required this.index,
  });

  final int index;

  final _formKey = GlobalKey<FormState>(); // Tambahkan GlobalKey untuk validasi
  final adminController = Get.put(AdminController());

  @override
  Widget build(BuildContext context) {
    // akun
    TextEditingController formUsername = TextEditingController(
      text: adminController.daftarGuru[index].username,
    );
    TextEditingController formPassword = TextEditingController(
      text: adminController.daftarGuru[index].password,
    );

    // biodata pribadi
    TextEditingController formName = TextEditingController(
      text: adminController.daftarGuru[index].nama,
    );
    TextEditingController formGender = TextEditingController(
      text: adminController.daftarGuru[index].jenisKelamin,
    );
    TextEditingController formPlaceDateOfBirth = TextEditingController(
      text: adminController.daftarGuru[index].tempatTanggalLahir,
    );
    TextEditingController formReligion = TextEditingController(
      text: adminController.daftarGuru[index].agama,
    );
    TextEditingController formAddress = TextEditingController(
      text: adminController.daftarGuru[index].alamat,
    );
    TextEditingController formEmail = TextEditingController(
      text: adminController.daftarGuru[index].email,
    );
    TextEditingController formPhoneNumber = TextEditingController(
      text: adminController.daftarGuru[index].noHp,
    );

    // data kepegawaian
    TextEditingController formNIP = TextEditingController(
      text: adminController.daftarGuru[index].nip,
    );
    TextEditingController formNUPTK = TextEditingController(
      text: adminController.daftarGuru[index].nuptk,
    );

    return Scaffold(
      backgroundColor: ColorConstant.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          centerTitle: true,
          title: Text(
            "Edit Guru",
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
                CustomFormField(
                  adminController: adminController,
                  title: "Nama Pengguna",
                  value: formUsername,
                  hintText: "username1",
                  dataType: 'String',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Nama pengguna tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomFormField(
                  adminController: adminController,
                  title: "Password",
                  value: formPassword,
                  hintText: "password",
                  dataType: 'String',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password tidak boleh kosong';
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
                CustomFormField(
                  adminController: adminController,
                  title: "Nama Lengkap",
                  value: formName,
                  hintText: "Nama Lengkap",
                  dataType: 'String',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Nama lengkap tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomFormField(
                  adminController: adminController,
                  title: "Jenis Kelamin",
                  value: formGender,
                  hintText: "Jenis Kelamin",
                  dataType: 'String',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Jenis kelamin tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomFormField(
                  adminController: adminController,
                  title: "Tempat, Tanggal Lahir",
                  value: formPlaceDateOfBirth,
                  hintText: "Tempat, Tanggal Lahir",
                  dataType: 'String',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Tempat dan tanggal lahir tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomFormField(
                  adminController: adminController,
                  title: "Agama",
                  value: formReligion,
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
                CustomFormField(
                  adminController: adminController,
                  title: "Alamat",
                  value: formAddress,
                  hintText: "Alamat",
                  dataType: 'String',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Alamat tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomFormField(
                  adminController: adminController,
                  title: "Email",
                  value: formEmail,
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
                CustomFormField(
                  adminController: adminController,
                  title: "Nomor Telepon",
                  value: formPhoneNumber,
                  hintText: "Nomor Telepon",
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
                CustomFormField(
                  adminController: adminController,
                  title: "NIP",
                  value: formNIP,
                  hintText: "Nomor Induk Pegawai",
                  dataType: 'int',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 10),
                CustomFormField(
                  adminController: adminController,
                  title: "NUPTK",
                  value: formNUPTK,
                  hintText: "Nomor Unik Pendidik dan Tenaga Kependidikan",
                  dataType: 'int',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return null;
                    }
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
                        adminController.updateGuru(
                          username: adminController.daftarGuru[index].username,
                          nama: formName.text,
                          jenisKelamin: formGender.text,
                          tempatTanggalLahir: formPlaceDateOfBirth.text,
                          agama: formReligion.text,
                          alamat: formAddress.text,
                          email: formEmail.text,
                          noHp: formPhoneNumber.text,
                          nip: formNIP.text,
                          nuptk: formNUPTK.text,
                          password: formPassword.text,
                        );
                        adminController.initPage();
                        Get.back();
                      }
                    },
                    child: Center(
                      child: Text(
                        "Kirim Formulir",
                        style: TextstyleConstant.nunitoSansMedium.copyWith(
                          color: ColorConstant.white,
                          fontSize: 20,
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

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    super.key,
    required this.adminController,
    required this.title,
    required this.value,
    required this.hintText,
    required this.dataType,
    required this.validator,
  });

  final AdminController adminController;
  final String title;
  final TextEditingController value;
  final String hintText;
  final String dataType;
  final FormFieldValidator<String> validator; // Validator ditambahkan

  @override
  Widget build(BuildContext context) {
    // Tentukan keyboardType berdasarkan dataType
    TextInputType keyboardType = TextInputType.text;
    if (dataType == 'int') {
      keyboardType =
          TextInputType.number; // Untuk integer, gunakan keyboard angka
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextstyleConstant.nunitoSansBold.copyWith(
            fontSize: 14,
            color: ColorConstant.black50,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: value,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ColorConstant.grayBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ColorConstant.blue),
            ),
            errorBorder: OutlineInputBorder(
              // Menambahkan errorBorder
              borderSide: BorderSide(
                  color: ColorConstant.red), // Warna merah untuk border error
            ),
            focusedErrorBorder: OutlineInputBorder(
              // Menambahkan focusedErrorBorder
              borderSide: BorderSide(color: ColorConstant.red),
            ),
            hintText: hintText,
            hintStyle: TextstyleConstant.nunitoSansMedium.copyWith(
              color: ColorConstant.black50,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 12,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
