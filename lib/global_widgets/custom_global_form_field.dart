import 'package:flutter/material.dart';
import 'package:presensi_guru/constants/color_constant.dart';
import 'package:presensi_guru/constants/textstyle_constant.dart';
import 'package:presensi_guru/controllers/admin_controller.dart';

class CustomGlobalFormField extends StatelessWidget {
  const CustomGlobalFormField({
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
