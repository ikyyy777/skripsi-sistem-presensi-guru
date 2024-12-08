import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:presensi_guru/utils/routes.dart';
import 'package:presensi_guru/views/admin_dashboard/admin_dashboard_view.dart';
import 'package:presensi_guru/views/formulir_tambah_guru/formulir_tambah_guru_view.dart';
import 'package:presensi_guru/views/guru_dashboard/guru_dashboard_view.dart';
import 'package:presensi_guru/views/guru_rekap_presensi/guru_riwayat_presensi_view.dart';
import 'package:presensi_guru/views/login/login_view.dart';
import 'package:presensi_guru/views/splashscreen/splashscreen_view.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart'; // Import for locale data initialization

void main() async{
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  initializeDateFormatting('id_ID', null).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: const SplashscreenView(),
      getPages: [
        GetPage(
          name: Routes.splashScreen,
          page: () => SplashscreenView(),
        ),
        GetPage(
          name: Routes.loginView,
          page: () => LoginView(),
        ),
        GetPage(
          name: Routes.guruDashboardView,
          page: () => GuruDashboardView(),
        ),
        GetPage(
          name: Routes.adminDashboardView,
          page: () => AdminDashboardView(),
        ),
        GetPage(
          name: Routes.formulirTambahGuruView,
          page: () => FormulirTambahGuruView(),
        ),
        GetPage(
          name: Routes.guruRiwayatPresensiView,
          page: () => GuruRiwayatPresensiView(),
        ),
      ],
    );
  }
}
