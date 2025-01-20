import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_guru/constants/color_constant.dart';
import 'package:presensi_guru/constants/textstyle_constant.dart';
import 'package:presensi_guru/controllers/admin_controller.dart';
import 'package:presensi_guru/models/presensi_model.dart';
import 'package:presensi_guru/views/admin_lihat_presensi_guru/widgets/admin_periode_bulan_rekap_widget.dart';
import 'package:presensi_guru/views/admin_lihat_presensi_guru/widgets/admin_riwayat_presensi_widget.dart';

class AdminLihatPresensiGuruView extends StatefulWidget {
  AdminLihatPresensiGuruView({super.key, required this.usernameGuru});

  final String usernameGuru;

  @override
  _AdminLihatPresensiGuruViewState createState() =>
      _AdminLihatPresensiGuruViewState();
}

class _AdminLihatPresensiGuruViewState
    extends State<AdminLihatPresensiGuruView> {
  final adminController = Get.put(AdminController());
  Presensi? presensi;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      await adminController.fetchDataGuru(widget.usernameGuru);

      presensi = await adminController.getTeacherPresenceData(
        widget.usernameGuru,
        adminController.yearNow,
        adminController.monthNow,
      );
    } catch (e) {
      errorMessage = "Error: $e";
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Riwayat Presensi Guru",
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
      body: SingleChildScrollView(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: ColorConstant.blue,
                ),
              )
            : errorMessage != null
                ? Center(child: Text(errorMessage!))
                : presensi == null
                    ? Column(
                        children: [
                          Center(
                            child: Text(
                              "Tidak ada data presensi",
                              style:
                                  TextstyleConstant.nunitoSansMedium.copyWith(
                                fontSize: 16,
                                color: ColorConstant.black,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            AdminPeriodeBulanRekapWidget(
                              presensi: presensi!,
                              guru: adminController.selectedDataGuru.value!,
                              year: adminController.yearNow.toString(),
                              month: adminController.monthNow.toString(),
                            ),
                            const SizedBox(height: 10),
                            AdminRiwayatPresensiWidget(presensi: presensi!),
                          ],
                        ),
                      ),
      ),
    );
  }
}
