import 'package:intl/intl.dart';

class DatetimeGetters {
  static Map<String, String> bulanIndoInt = {
    'Januari': '01',
    'Februari': '02',
    'Maret': '03',
    'April': '04',
    'Mei': '05',
    'Juni': '06',
    'Juli': '07',
    'Agustus': '08',
    'September': '09',
    'Oktober': '10',
    'November': '11',
    'Desember': '12',
  };

  static List<String> bulanIndo = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];

  static List<String> hariIndo = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu'
  ];

  static int getYearNow() {
    final now = DateTime.now();
    return now.year;
  }

  static String getTimeOfDay() {
    // dapatkan waktu sekarang
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 0 && hour <= 9) {
      return "pagi";
    } else if (hour >= 10 && hour <= 14) {
      return "siang";
    } else if (hour >= 15 && hour <= 18) {
      return "sore";
    } else if (hour >= 19 && hour <= 23) {
      return "malam";
    }

    return "pagi";
  }

  static String getDateNowInt() {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';
  }

  static String getFormattedDateTimeNow() {
    // Mendapatkan tanggal sekarang
    DateTime now = DateTime.now();

    // Mengambil nama hari dalam bahasa Indonesia
    String hari = hariIndo[now.weekday - 1];

    // Mengambil nama bulan dalam bahasa Indonesia
    String bulan = bulanIndo[now.month - 1];

    // Format tanggal dalam bentuk "Day, Date Month Year"
    return '$hari, ${now.day} $bulan ${now.year}';
  }

  static String getFormattedDateNow() {
    // Mendapatkan tanggal sekarang
    DateTime now = DateTime.now();

    // Mengambil nama bulan dalam bahasa Indonesia
    String bulan = bulanIndo[now.month - 1];

    // Format tanggal dalam bentuk "Day, Date Month Year"
    return '${now.day} $bulan ${now.year}';
  }

  static DateTime parseFormattedDate(String dateString) {
    // Remove the day of the week and parse the rest
    final dateFormat =
        DateFormat('d MMMM yyyy', 'id_ID'); // 'id_ID' for Indonesian locale
    return dateFormat.parse(dateString.split(',')[1].trim());
  }
}
