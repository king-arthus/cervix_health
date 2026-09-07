import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'localization/app_strings.dart';
import 'services/app_data.dart';
import 'services/notification_service.dart';
import 'screens/welcome_screen.dart';
import 'screens/patient/patient_home_screen.dart';
import 'screens/personnel/personnel_home_screen.dart';
import 'models/user_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppData(),
      child: const CervixHealthApp(),
    ),
  );
}

class CervixHealthApp extends StatefulWidget {
  const CervixHealthApp({super.key});

  @override
  State<CervixHealthApp> createState() => _CervixHealthAppState();
}

class _CervixHealthAppState extends State<CervixHealthApp> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await context.read<AppData>().init();
    await NotificationService.init();
    await NotificationService.requestPermission();
    setState(() => _ready = true);
  }

  @override
  Widget build(BuildContext context) {
    final appData = context.watch<AppData>();
    final isRtl = AppStrings.isRtl(appData.localeCode);

    if (!_ready) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    Widget home;
    if (appData.currentUser == null) {
      home = const WelcomeScreen();
    } else if (appData.currentUser!.profileType == ProfileType.patient) {
      home = const PatientHomeScreen();
    } else {
      home = const PersonnelHomeScreen();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cervix Health',
      theme: ThemeData(
        colorSchemeSeed: Colors.pink,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        );
      },
      home: home,
    );
  }
}
