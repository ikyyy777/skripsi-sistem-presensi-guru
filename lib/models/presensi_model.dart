class RiwayatPresensi {
  final String riwayatId;
  final String presensiId;
  final String tanggalPresensi;
  final String jamMasuk;
  final String? jamKeluar;
  final String keterangan;

  RiwayatPresensi({
    required this.riwayatId,
    required this.presensiId,
    required this.tanggalPresensi,
    required this.jamMasuk,
    this.jamKeluar,
    required this.keterangan,
  });

  factory RiwayatPresensi.fromMap(Map<String, dynamic> map) {
    return RiwayatPresensi(
      riwayatId: map['riwayat_id'],
      presensiId: map['presensi_id'],
      tanggalPresensi: map['tanggal_presensi'],
      jamMasuk: map['jam_masuk'],
      jamKeluar: map['jam_keluar'],
      keterangan: map['keterangan'],
    );
  }
}

class Presensi {
  final String presensiId;
  final String username;
  final int tahun;
  final int bulan;
  final int totalHadir;
  final int totalCuti;
  final int totalTelat;
  final List<RiwayatPresensi> riwayatPresensi;

  Presensi({
    required this.presensiId,
    required this.username,
    required this.tahun,
    required this.bulan,
    required this.totalHadir,
    required this.totalCuti,
    required this.totalTelat,
    required this.riwayatPresensi,
  });

  factory Presensi.fromMap(Map<String, dynamic> map, List<RiwayatPresensi> riwayatPresensi) {
    return Presensi(
      presensiId: map['presensi_id'],
      username: map['username'],
      tahun: map['tahun'],
      bulan: map['bulan'],
      totalHadir: map['total_hadir'],
      totalCuti: map['total_cuti'],
      totalTelat: map['total_telat'],
      riwayatPresensi: riwayatPresensi,
    );
  }
}
