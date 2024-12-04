class Presensi {
  String bulan;
  int totalHadir;
  int totalCuti;
  int totalTelat;
  List<RiwayatPresensi> riwayatPresensi;

  Presensi({
    required this.bulan,
    required this.totalHadir,
    required this.totalCuti,
    required this.totalTelat,
    required this.riwayatPresensi,
  });

  // Dari Map ke Presensi
  factory Presensi.fromMap(Map<String, dynamic> map) {
    // Pastikan riwayat_presensi adalah list sebelum diproses
    List<RiwayatPresensi> riwayatPresensiList = [];
    if (map['riwayat_presensi'] is List) {
      riwayatPresensiList = (map['riwayat_presensi'] as List)
          .map((item) => RiwayatPresensi.fromMap(item))
          .toList();
    }

    return Presensi(
      bulan: map['bulan'],
      totalHadir: map['total_hadir'],
      totalCuti: map['total_cuti'],
      totalTelat: map['total_telat'],
      riwayatPresensi: riwayatPresensiList,
    );
  }

  // Dari Presensi ke Map
  Map<String, dynamic> toMap() {
    return {
      'bulan': bulan,
      'total_hadir': totalHadir,
      'total_cuti': totalCuti,
      'total_telat': totalTelat,
      'riwayat_presensi': riwayatPresensi.map((item) => item.toMap()).toList(),
    };
  }
}

class RiwayatPresensi {
  String keterangan;
  String jamMasuk;
  String tanggalPresensi;

  RiwayatPresensi({
    required this.keterangan,
    required this.jamMasuk,
    required this.tanggalPresensi,
  });

  // Dari Map ke RiwayatPresensi
  factory RiwayatPresensi.fromMap(Map<String, dynamic> map) {
    return RiwayatPresensi(
      keterangan: map['keterangan'],
      jamMasuk: map['jam_masuk'],
      tanggalPresensi: map['tanggal_presensi'],
    );
  }

  // Dari RiwayatPresensi ke Map
  Map<String, dynamic> toMap() {
    return {
      'keterangan': keterangan,
      'jam_masuk': jamMasuk,
      'tanggal_presensi': tanggalPresensi,
    };
  }
}

class PresensiModel {
  String username;
  Map<String, List<Presensi>> presensiData;

  PresensiModel({
    required this.username,
    required this.presensiData,
  });

  // Dari Map ke PresensiModel
  factory PresensiModel.fromMap(String username, Map<String, dynamic> map) {
    Map<String, List<Presensi>> presensiData = {};
    map.forEach((key, value) {
      presensiData[key] =
          (value as List).map((item) => Presensi.fromMap(item)).toList();
    });
    return PresensiModel(
      username: username,
      presensiData: presensiData,
    );
  }

  // Dari PresensiModel ke Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    presensiData.forEach((key, value) {
      map[key] = value.map((item) => item.toMap()).toList();
    });
    return map;
  }
}
