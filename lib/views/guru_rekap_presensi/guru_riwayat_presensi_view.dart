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
  _GuruRiwayatPresensiViewState createState() =>
      _GuruRiwayatPresensiViewState();
}

class _GuruRiwayatPresensiViewState extends State<GuruRiwayatPresensiView> {
  final guruController = Get.find<GuruController>();
  late List<bool> expansionState;

  @override
  void initState() {
    super.initState();
    // Mengambil data riwayat presensi
    final riwayatPresensiData =
        guruController.presensiModel.value?.riwayatPresensi ?? [];
    if (kDebugMode) {
      print("Presensi Data (init): $riwayatPresensiData");
    }

    // Menginisialisasi expansion state
    expansionState = List.generate(riwayatPresensiData.length, (_) => false);
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
        final presensiData = guruController.presensiModel.value;
        final riwayatPresensiData = presensiData?.riwayatPresensi ?? [];
        if (riwayatPresensiData.isEmpty) {
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

        // Mengelompokkan riwayat presensi berdasarkan tahun
        final groupedByYear = _groupByYearAndMonth(riwayatPresensiData);

        // Update jumlah expansion state jika jumlah tahun berubah
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (expansionState.length != groupedByYear.keys.length) {
            setState(() {
              expansionState =
                  List.generate(groupedByYear.keys.length, (_) => false);
            });
          }
        });

        return ListView.builder(
          itemCount: groupedByYear.keys.length,
          itemBuilder: (context, yearIndex) {
            final year = groupedByYear.keys.elementAt(yearIndex);
            final presensiForYear = groupedByYear[year]!;

            return ExpansionPanelList(
              expandIconColor: ColorConstant.white,
              expansionCallback: (panelIndex, isExpanded) {
                setState(() {
                  expansionState[yearIndex] = isExpanded;
                });
              },
              children: [
                ExpansionPanel(
                  backgroundColor: ColorConstant.blue,
                  headerBuilder: (context, isExpanded) {
                    return ListTile(
                      title: Text(
                        "Data Presensi Tahun $year",
                        style: TextstyleConstant.nunitoSansBold.copyWith(
                          color: ColorConstant.white,
                          fontSize: 14,
                        ),
                      ),
                    );
                  },
                  isExpanded: expansionState[yearIndex],
                  body: Column(
                    children: presensiForYear.entries.map((entry) {
                      final month = entry.key;

                      return ListTile(
                        title: Text(
                          DatetimeGetters.bulanIndo[month - 1],
                          style: TextstyleConstant.nunitoSansMedium.copyWith(
                            fontSize: 14,
                            color: ColorConstant.white,
                          ),
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            Get.to(() => GuruRekapPresensiView(
                                  month: month.toString(),
                                  year: year.toString(),
                                  //riwayatPresensi: riwayatForMonth,
                                ));
                          },
                          child: Icon(
                            Icons.date_range_outlined,
                            color: ColorConstant.white,
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

  // Fungsi untuk mengelompokkan riwayat presensi berdasarkan tahun dan bulan
  Map<int, Map<int, List<RiwayatPresensi>>> _groupByYearAndMonth(
      List<RiwayatPresensi> riwayatPresensi) {
    final Map<int, Map<int, List<RiwayatPresensi>>> grouped = {};
    for (var presensi in riwayatPresensi) {
      // Remove the day of the week (e.g., "Minggu,") and split the rest of the date
      final dateParts =
          presensi.tanggalPresensi.split(',')[1].trim().split(' ');

      // Extract the month (as text), and year
      final monthString = dateParts[1];
      final year = int.parse(dateParts[2]);

      // Convert month string to month number
      final month = DatetimeGetters.bulanIndo.indexOf(monthString) + 1;

      // Group by year and month
      grouped
          .putIfAbsent(year, () => {})
          .putIfAbsent(month, () => [])
          .add(presensi);
    }
    return grouped;
  }
}
