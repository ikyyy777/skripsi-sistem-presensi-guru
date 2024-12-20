import 'package:flutter/material.dart';
import 'package:presensi_guru/constants/color_constant.dart';
import 'package:presensi_guru/views/admin_dashboard/widgets/admin_card_widget.dart';
import 'package:presensi_guru/views/admin_dashboard/widgets/admin_daftar_guru_widget.dart';
import 'package:presensi_guru/views/admin_dashboard/widgets/admin_profile_widget.dart';
import 'package:presensi_guru/views/admin_dashboard/widgets/admin_rekap_widget.dart';
import 'package:presensi_guru/views/admin_dashboard/widgets/admin_tambah_guru_button_widget.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  DateTime? lastPressed;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        
        final now = DateTime.now();
        const maxDuration = Duration(seconds: 2);
        final isWarning = lastPressed == null || 
            now.difference(lastPressed!) > maxDuration;

        if (isWarning) {
          setState(() {
            lastPressed = DateTime.now();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tekan sekali lagi untuk keluar'),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }
        Navigator.of(context).pop();
      },
      child: Scaffold(
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
      ),
    );
  }
}