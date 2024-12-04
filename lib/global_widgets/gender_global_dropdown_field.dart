import 'package:flutter/material.dart';
import 'package:presensi_guru/constants/color_constant.dart';
import 'package:presensi_guru/constants/textstyle_constant.dart';
import 'package:presensi_guru/controllers/admin_controller.dart';

class GenderGlobalDropdownField extends StatelessWidget {
  const GenderGlobalDropdownField({
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
  final String value;
  final String hintText;
  final String dataType;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    // Tentukan opsi dropdown
    List<String> genderOptions = ['Laki-laki', 'Perempuan'];

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
        DropdownButtonFormField<String>(
          value: value.isEmpty ? null : value, // Nilai awal
          items: genderOptions
              .map(
                (gender) => DropdownMenuItem(
                  value: gender,
                  child: Text(
                    gender,
                    style: TextstyleConstant.nunitoSansMedium,
                  ),
                ),
              )
              .toList(),
          onChanged: (newValue) {
            adminController.formGender.text = newValue!;
          },
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ColorConstant.grayBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ColorConstant.blue),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ColorConstant.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
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