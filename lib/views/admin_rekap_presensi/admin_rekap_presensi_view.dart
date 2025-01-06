import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:presensi_guru/constants/color_constant.dart';
import 'package:presensi_guru/constants/textstyle_constant.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presensi_guru/controllers/admin_controller.dart';
import 'package:presensi_guru/utils/datetime_getters.dart';
import 'package:presensi_guru/utils/get_dialogs.dart';
import 'package:presensi_guru/views/admin_lihat_presensi_guru/admin_lihat_presensi_guru_view.dart';

class AdminRekapPresensiView extends StatefulWidget {
  const AdminRekapPresensiView({super.key});

  @override
  State<AdminRekapPresensiView> createState() => _AdminRekapPresensiViewState();
}

class _AdminRekapPresensiViewState extends State<AdminRekapPresensiView> {
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
      QuerySnapshot presensiSnapshot =
          await firestore.collection('presensi').get();

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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: FutureBuilder<Map<int, Set<int>>>(
              future: yearDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: ColorConstant.blue,
                        ),
                        const SizedBox(height: 16),
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
                final years = yearData.keys.toList()
                  ..sort((a, b) => b.compareTo(a));

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: years.length,
                        itemBuilder: (context, yearIndex) {
                          final year = years[yearIndex];
                          final months = yearData[year]!.toList()..sort();

                          return Column(
                            children: [
                              ExpansionPanelList(
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
                                          style: TextstyleConstant
                                              .nunitoSansBold
                                              .copyWith(
                                            color: ColorConstant.white,
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
                                            DatetimeGetters
                                                .bulanIndo[month - 1],
                                            style: TextstyleConstant
                                                .nunitoSansMedium
                                                .copyWith(
                                              fontSize: 14,
                                              color: ColorConstant.white,
                                            ),
                                          ),
                                          trailing: TextButton(
                                            style: TextButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(90),
                                              ),
                                            ),
                                            onPressed: () async {
                                              try {
                                                final rekapData =
                                                    await adminController
                                                        .getPresenceRecap(
                                                            tahun: year,
                                                            bulan: month);
                                                // Implementasi cetak rekap di sini
                                                log("Cetak rekap untuk bulan $month tahun $year");
                                                log("Data rekap: $rekapData");
                                                await adminController
                                                    .exportPresenceDataToExcel(
                                                        rekapData);
                                              } catch (e) {
                                                GetDialogs.showDialog1(
                                                  "Kesalahan",
                                                  "Gagal mencetak rekap presensi: $e",
                                                );
                                              }
                                            },
                                            child: Icon(
                                              Icons.print,
                                              color: ColorConstant.white,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
                      // Daftar Presensi Guru section moved outside the ListView.builder
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Daftar Presensi Guru",
                              style: TextstyleConstant.nunitoSansBold.copyWith(
                                color: ColorConstant.black,
                                fontSize: 14,
                              ),
                            ),
                            Divider(
                              color: ColorConstant.grayBorder,
                              thickness: 1,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: adminController.daftarGuru.length,
                              itemBuilder: (BuildContext context, int index) {
                                final guru = adminController.daftarGuru[index];
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const Icon(Icons.person),
                                  title: Text(
                                    guru.nama,
                                    style: TextstyleConstant.nunitoSansMedium
                                        .copyWith(
                                      fontSize: 14,
                                      color: ColorConstant.black,
                                    ),
                                  ),
                                  subtitle: Text("NIP ${guru.nip}"),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              String? selectedOption;
                                              TextEditingController
                                                  keteranganController =
                                                  TextEditingController();

                                              return StatefulBuilder(
                                                builder: (context, setState) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      "Presensi Manual Hari Ini",
                                                      style: TextstyleConstant
                                                          .nunitoSansBold
                                                          .copyWith(
                                                        color:
                                                            ColorConstant.black,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        DropdownButtonFormField<
                                                            String>(
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                "Pilih Kehadiran",
                                                            labelStyle:
                                                                TextstyleConstant
                                                                    .nunitoSansMedium,
                                                            border:
                                                                OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: ColorConstant
                                                                      .grayBorder),
                                                            ),
                                                          ),
                                                          style: TextstyleConstant
                                                              .nunitoSansMedium,
                                                          items: [
                                                            "Cuti",
                                                            "Hadir"
                                                          ].map((String value) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: value,
                                                              child: Text(
                                                                value,
                                                                style: TextstyleConstant
                                                                    .nunitoSansMedium
                                                                    .copyWith(
                                                                  color:
                                                                      ColorConstant
                                                                          .black,
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),
                                                          onChanged:
                                                              (newValue) {
                                                            setState(() {
                                                              selectedOption =
                                                                  newValue;
                                                            });
                                                          },
                                                        ),
                                                        if (selectedOption ==
                                                            "Cuti")
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 16.0),
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  keteranganController,
                                                              style: TextstyleConstant
                                                                  .nunitoSansMedium,
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText:
                                                                    "Keterangan",
                                                                labelStyle:
                                                                    TextstyleConstant
                                                                        .nunitoSansMedium,
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              ColorConstant.grayBorder),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text(
                                                          "Batal",
                                                          style: TextstyleConstant
                                                              .nunitoSansMedium
                                                              .copyWith(
                                                            color: ColorConstant
                                                                .black,
                                                          ),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          if (selectedOption ==
                                                              "Cuti") {
                                                            adminController.postPresenceManual(
                                                                guru.username,
                                                                DateTime.now()
                                                                    .toString(),
                                                                "Cuti ${keteranganController.text}");
                                                          } else if (selectedOption ==
                                                              "Hadir") {
                                                            adminController
                                                                .postPresenceManual(
                                                                    guru
                                                                        .username,
                                                                    DateTime.now()
                                                                        .toString(),
                                                                    "Hadir");
                                                          }
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text(
                                                          "OK",
                                                          style: TextstyleConstant
                                                              .nunitoSansMedium
                                                              .copyWith(
                                                            color: ColorConstant
                                                                .blue,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                        child: const Icon(
                                          Icons.my_library_books_rounded,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(() =>
                                              AdminLihatPresensiGuruView(
                                                  usernameGuru: guru.username));
                                        },
                                        child: const Icon(
                                          Icons.date_range_outlined,
                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
