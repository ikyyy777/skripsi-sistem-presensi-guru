import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:presensi_guru/constants/color_constant.dart';
import 'package:presensi_guru/constants/textstyle_constant.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presensi_guru/controllers/admin_controller.dart';
import 'package:presensi_guru/utils/datetime_getters.dart';
import 'package:presensi_guru/utils/get_dialogs.dart';

class AdminLihatRekapPresensiView extends StatefulWidget {
  const AdminLihatRekapPresensiView({super.key});

  @override
  State<AdminLihatRekapPresensiView> createState() => _AdminLihatRekapPresensiViewState();
}

class _AdminLihatRekapPresensiViewState extends State<AdminLihatRekapPresensiView> {
  final adminController = Get.find<AdminController>();
  late List<bool> expansionState;
  final firestore = FirebaseFirestore.instance;
  
  late Future<Map<int, Set<int>>> yearDataFuture;

  @override
  void initState() {
    super.initState();
    expansionState = [];
    yearDataFuture = fetchYearData();
  }

  Future<Map<int, Set<int>>> fetchYearData() async {
    Map<int, Set<int>> yearMonthData = {};
    
    try {
      QuerySnapshot presensiSnapshot = await firestore.collection('presensi').get();
      
      for (var doc in presensiSnapshot.docs) {
        String presensiId = doc.id;
        List<String> parts = presensiId.split('_');
        if (parts.length >= 3) {
          int year = int.parse(parts[1]);
          int month = int.parse(parts[2]);
          
          yearMonthData.putIfAbsent(year, () => {}).add(month);
        }
      }
      
      setState(() {
        expansionState = List.generate(yearMonthData.length, (_) => false);
      });
      
      return yearMonthData;
    } catch (e) {
      log('Error fetching year data: $e');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          centerTitle: true,
          title: Text(
            "Lihat & Rekap Presensi",
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
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<Map<int, Set<int>>>(
              future: yearDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Mengambil data presensi...'),
                      ],
                    ),
                  );
                }
            
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
            
                final yearData = snapshot.data!;
                final years = yearData.keys.toList()..sort((a, b) => b.compareTo(a));
            
                return ListView.builder(
                  itemCount: years.length,
                  itemBuilder: (context, yearIndex) {
                    final year = years[yearIndex];
                    final months = yearData[year]!.toList()..sort();
            
                    return Column(
                      children: [
                        ExpansionPanelList(
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
                                children: months.map((month) {
                                  return ListTile(
                                    title: Text(
                                      DatetimeGetters.bulanIndo[month - 1],
                                      style: TextstyleConstant.nunitoSansMedium.copyWith(
                                        fontSize: 14,
                                        color: ColorConstant.black50,
                                      ),
                                    ),
                                    trailing: TextButton(
                                      onPressed: () async {
                                        try {
                                          final rekapData = await adminController
                                              .cetakRekapPresensi(
                                                  tahun: year, bulan: month);
                                          // Implementasi cetak rekap di sini
                                          log("Cetak rekap untuk bulan $month tahun $year");
                                          log("Data rekap: $rekapData");
                                          await adminController.exportToExcel(rekapData);
                                        } catch (e) {
                                          GetDialogs.showDialog1(
                                            "Kesalahan",
                                            "Gagal mencetak rekap presensi: $e",
                                          );
                                        }
                                      },
                                      child: Text(
                                        "cetak rekap",
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
                        ),

                        // Implementasi daftar guru untuk melihat data presensi
                        Text("Example Text"),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}