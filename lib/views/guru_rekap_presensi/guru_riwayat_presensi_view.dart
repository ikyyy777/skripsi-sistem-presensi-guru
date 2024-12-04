import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_guru/constants/color_constant.dart';
import 'package:presensi_guru/constants/textstyle_constant.dart';
import 'package:presensi_guru/controllers/guru_controller.dart';
import 'package:presensi_guru/models/presensi_model.dart';
import 'package:presensi_guru/utils/datetime_getters.dart';
import 'package:presensi_guru/views/guru_rekap_presensi/guru_rekap_presensi_view.dart';

class GuruRiwayatPresensiView extends StatefulWidget {
  const GuruRiwayatPresensiView({super.key});

  @override
  _GuruRiwayatPresensiViewState createState() => _GuruRiwayatPresensiViewState();
}

class _GuruRiwayatPresensiViewState extends State<GuruRiwayatPresensiView> {
  final guruController = Get.find<GuruController>();
  late List<bool> expansionState;

  @override
  void initState() {
    super.initState();
    // Log data untuk memastikan jumlah state sesuai dengan jumlah tahun
    final presensiData = guruController.presensiModel.value?.presensiData ?? {};
    if (kDebugMode) {
      print("Presensi Data (init): $presensiData");
    }

    expansionState = List.generate(presensiData.keys.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Riwayat Presensi",
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
      body: Obx(() {
        final presensiData = guruController.presensiModel.value?.presensiData;
        if (presensiData == null || presensiData.isEmpty) {
          return Center(
            child: Text(
              "Tidak ada data presensi",
              style: TextstyleConstant.nunitoSansMedium.copyWith(
                fontSize: 14,
                color: ColorConstant.gray30,
              ),
            ),
          );
        }

        // Update jumlah expansionState jika jumlah tahun berubah
        if (expansionState.length != presensiData.keys.length) {
          setState(() {
            expansionState = List.generate(
              presensiData.keys.length,
              (_) => false,
            );
          });
        }

        return ListView.builder(
          itemCount: presensiData.keys.length,
          itemBuilder: (context, yearIndex) {
            String year = presensiData.keys.toList()[yearIndex];
            List<Presensi> presensiList = presensiData[year]!;

            // Sorting bulan
            presensiList.sort((a, b) =>
                _bulanToIndex(b.bulan).compareTo(_bulanToIndex(a.bulan)));

            return ExpansionPanelList(
              expansionCallback: (panelIndex, isExpanded) {
                setState(() {
                  expansionState[yearIndex] = isExpanded;
                });
              },
              children: [
                ExpansionPanel(
                  backgroundColor: ColorConstant.white,
                  headerBuilder: (context, isExpanded) {
                    return ListTile(
                      title: Text(
                        "Data Presensi Tahun $year",
                        style: TextstyleConstant.nunitoSansBold.copyWith(
                          color: ColorConstant.black,
                          fontSize: 14,
                        ),
                      ),
                    );
                  },
                  isExpanded: expansionState[yearIndex],
                  body: Column(
                    children: presensiList.map((presensi) {
                      return ListTile(
                        title: Text(
                          presensi.bulan,
                          style: TextstyleConstant.nunitoSansMedium.copyWith(
                            fontSize: 14,
                            color: ColorConstant.black,
                          ),
                        ),
                        trailing: TextButton(
                          onPressed: () {
                            // Handle lihat rekap
                            Get.to(()=> GuruRekapPresensiView(month: presensi.bulan, year: year));
                          },
                          child: Text(
                            "lihat rekap",
                            style: TextstyleConstant.nunitoSansMedium.copyWith(
                              fontSize: 14,
                              color: ColorConstant.blue,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }

  int _bulanToIndex(String bulan) {
    return DatetimeGetters.bulanIndo.indexOf(bulan);
  }
}
