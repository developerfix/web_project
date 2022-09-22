import 'dart:async';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firedart/auth/client.dart';
import 'package:firedart/auth/token_store.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:Ava/constants/style.dart';
import 'package:Ava/controllers/project_controller.dart';
import 'package:Ava/splash.dart';
import 'package:Ava/widgets/edit_task_popup.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:firedart/firedart.dart' as firedart;
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/auth_controller.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

import 'package:firebase_dart/implementation/pure_dart.dart'
    as pure_dart_implementation;

ThemeData _darkTheme = ThemeData(
  brightness: Brightness.dark,
);

ThemeData _lightTheme = ThemeData(
  brightness: Brightness.light,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    firedart.Firestore.initialize("ava-project-ab57c");
    pure_dart_implementation.FirebaseDart.setup();
  }
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyC9Jzj22llAEY9Zj1LjVMOxI8kVIFjP2VY",
        authDomain: "ava-project-ab57c.firebaseapp.com",
        projectId: "ava-project-ab57c",
        storageBucket: "ava-project-ab57c.appspot.com",
        messagingSenderId: "69104603518",
        appId: "1:69104603518:web:4ff45ea30c6e823b1fe32f"),
  );

  Get.put(AuthController());

  runApp(const MyApp());

  doWhenWindowReady(() {
    const initialSize = Size(1200, 1000);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;

    appWindow.show();

    Timer(const Duration(seconds: 2), () {
      appWindow.maximize();
    });
  });
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  ProjectController projectController = Get.put(ProjectController());

  _getThemeStatus() async {
    // Rx<Future<bool?>>? isDark = _prefs.then((SharedPreferences? prefs) {
    //   return prefs!.getBool('theme');
    // }).obs;
    // print(isDark.value);
    projectController.isDarkTheme.value = false;
    // ignore: unnecessary_null_comparison
    // isDark.value == null ? false : (await isDark.value)!;

    Get.changeThemeMode(
        projectController.isDarkTheme.value ? ThemeMode.dark : ThemeMode.light);
  }

  @override
  void initState() {
    super.initState();
    _getThemeStatus();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: _lightTheme,
        darkTheme: _darkTheme,
        themeMode: ThemeMode.system,
        defaultTransition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 600),
        builder: (context, child) => ResponsiveWrapper.builder(
            BouncingScrollWrapper.builder(context, child!),
            // maxWidth: 1200,
            minWidth: 450,
            defaultScale: true,
            breakpoints: [
              const ResponsiveBreakpoint.resize(450, name: MOBILE),
              const ResponsiveBreakpoint.autoScale(800, name: TABLET),
              const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
              const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
              const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
            ],
            background: Container(color: const Color(0xFFF5F5F5))),
        scrollBehavior: MyCustomScrollBehavior(),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen());
  }
}
