import 'package:flutter/material.dart';
import 'package:presensi_guru/constants/color_constant.dart';
import 'package:presensi_guru/views/admin_dashboard/widgets/admin_card_widget.dart';
import 'package:presensi_guru/views/admin_dashboard/widgets/admin_daftar_guru_widget.dart';
import 'package:presensi_guru/views/admin_dashboard/widgets/admin_profile_widget.dart';
import 'package:presensi_guru/views/admin_dashboard/widgets/admin_rekap_widget.dart';
import 'package:presensi_guru/views/admin_dashboard/widgets/admin_tambah_guru_button_widget.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AdminProfileWidget(),
                const SizedBox(height: 10),
                AdminCardWidget(),
                const SizedBox(height: 20),
                AdminRekapWidget(),
                const SizedBox(height: 20),
                AdminDaftarGuruWidget(),
                const SizedBox(height: 20),
                AdminTambahGuruButtonWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}