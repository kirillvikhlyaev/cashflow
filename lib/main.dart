import 'dart:io';
import 'package:cashflow/core/appcolors.dart';
import 'package:cashflow/ui/pages/add_slip_page.dart';
import 'package:cashflow/ui/pages/home_page.dart';
import 'package:cashflow/ui/pages/unknown_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'controller/controller.dart';
import 'model/slip.dart';

void main() async {  
  WidgetsFlutterBinding.ensureInitialized();
  Directory appDocDir = await getApplicationDocumentsDirectory();
  tz.initializeTimeZones();
  Hive.init(appDocDir.path);
  Hive.registerAdapter(SlipAdapter());
  var box = await Hive.openBox<Slip>('slips');

    Controller c = Get.put(Controller());
    c.slips.addAll(box.values);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Управление подписками',
      theme: CustomThemData.getLightTheme(),
      darkTheme: CustomThemData.getDarkTheme(),
      themeMode: ThemeMode.system,
      initialRoute: '/main',
      getPages: [
        GetPage(
            name: '/main', page: () => const HomePage(title: 'Управление подписками')),
        GetPage(
            name: '/addslip',
            page: () => const AddSlipPage(),
            transition: Transition.zoom),
        GetPage(name: '/unknown', page: () => const UnknownPage()),
      ],
    );
  }
}

class CustomThemData {
  static ThemeData getLightTheme() {
    return ThemeData(
        colorScheme: const ColorScheme.light(
            brightness: Brightness.light, secondary: Colors.indigoAccent),
        appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.grey),
            color: Colors.white,
            titleTextStyle: TextStyle(color: Colors.black)),
        backgroundColor: const Color.fromARGB(255, 213, 213, 213),
        listTileTheme: const ListTileThemeData(
          tileColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyText1: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
          bodyText2: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          headline1: TextStyle(
              color: Colors.green, fontSize: 21, fontWeight: FontWeight.bold),
          headline2: TextStyle(color: Colors.grey, fontSize: 14),
          headline3:  TextStyle(fontSize: 16, color: Colors.black),
          headline4: TextStyle(color: Colors.black, fontSize: 32),
        ),
        iconTheme: const IconThemeData(color: Colors.grey),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0))),
            backgroundColor: MaterialStateProperty.all(Colors.white),
            minimumSize: MaterialStateProperty.all(Size(Get.width, 45)),
            overlayColor: MaterialStateProperty.all(
                const Color.fromARGB(50, 63, 81, 181)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: const BorderSide(width: 0.5, color: Colors.black54)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: const BorderSide(width: 1, color: Colors.black)),
          labelStyle: const TextStyle(color: Colors.black, fontSize: 14),
          filled: true,
          fillColor: Colors.white,
        ));
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
        colorScheme: const ColorScheme.dark(
            brightness: Brightness.dark, secondary: Colors.indigo),
        appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
            color: AppColors.lightBgColor,
            titleTextStyle: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.darkBgColor,
        listTileTheme: const ListTileThemeData(
          tileColor: AppColors.lightBgColor,
        ),
        textTheme:  const TextTheme(
          bodyText1: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          bodyText2: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          headline1: TextStyle(
              color: Colors.green, fontSize: 21, fontWeight: FontWeight.bold),
          headline2: TextStyle(color: Colors.grey, fontSize: 14),
          headline3:  TextStyle(fontSize: 16, color: Colors.white),
          headline4: TextStyle(color: Colors.white, fontSize: 32),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0))),
            backgroundColor: MaterialStateProperty.all(AppColors.lightBgColor),
            minimumSize: MaterialStateProperty.all(Size(Get.width, 45)),
            overlayColor: MaterialStateProperty.all(
                const Color.fromARGB(50, 63, 81, 181)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: const BorderSide(width: 0.5, color: AppColors.overlayColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: const BorderSide(width: 1, color: AppColors.overlayColor)),
          labelStyle: const TextStyle(color: Colors.white, fontSize: 14),
          filled: true,
          fillColor: AppColors.lightBgColor,
        ));
  }
}
