import 'package:cloud_firestore/cloud_firestore.dart';

class GuruModel {
  final String username;
  final String password;
  final String nama;
  final String jenisKelamin;
  final String tempatTanggalLahir;
  final String agama;
  final String alamat;
  final String email;
  final String noHp;
  final String nip;
  final String nuptk;
  final String imei;
  final DateTime? dibuatPada;

  GuruModel({
    required this.username,
    required this.password,
    required this.nama,
    required this.jenisKelamin,
    required this.tempatTanggalLahir,
    required this.agama,
    required this.alamat,
    required this.email,
    required this.noHp,
    required this.nip,
    required this.nuptk,
    required this.imei,
    this.dibuatPada,
  });

  factory GuruModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GuruModel(
      username: data['username'] ?? '',
      password: data['password'] ?? '',
      nama: data['nama'] ?? '',
      jenisKelamin: data['jenis_kelamin'] ?? '',
      tempatTanggalLahir: data['tempat_tanggal_lahir'] ?? '',
      agama: data['agama'] ?? '',
      alamat: data['alamat'] ?? '',
      email: data['email'] ?? '',
      noHp: data['no_hp'] ?? '',
      nip: data['NIP'] ?? '',
      nuptk: data['NUPTK'] ?? '',
      imei: data['IMEI'] ?? '',
      dibuatPada: (data['dibuat_pada'] as Timestamp?)?.toDate(),
    );
  }
}
