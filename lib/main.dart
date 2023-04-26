import 'dart:async';

import 'package:ava/widgets/shared_preferences.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ava/controllers/project_controller.dart';
import 'package:ava/splash.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:firedart/firedart.dart' as firedart;
import 'package:firebase_dart/core.dart' as firebase_dart;
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/auth_controller.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:firebase_dart/implementation/pure_dart.dart'
    as pure_dart_implementation;

ThemeData _darkTheme =
    ThemeData(brightness: Brightness.dark, primarySwatch: Colors.brown);

ThemeData _lightTheme =
    ThemeData(brightness: Brightness.light, primarySwatch: Colors.brown);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.sharedPreferencesInitialization();

  if (!kIsWeb) {
    firedart.Firestore.initialize("ava-project-ab57c");
    pure_dart_implementation.FirebaseDart.setup();
    await firebase_dart.Firebase.initializeApp(
      options: const firebase_dart.FirebaseOptions(
          apiKey: "AIzaSyC9Jzj22llAEY9Zj1LjVMOxI8kVIFjP2VY",
          authDomain: "ava-project-ab57c.firebaseapp.com",
          projectId: "ava-project-ab57c",
          storageBucket: "ava-project-ab57c.appspot.com",
          messagingSenderId: "69104603518",
          appId: "1:69104603518:web:4ff45ea30c6e823b1fe32f"),
    );
  } else {
    pure_dart_implementation.FirebaseDart.setup();
  }
  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 15));
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyC9Jzj22llAEY9Zj1LjVMOxI8kVIFjP2VY",
        authDomain: "ava-project-ab57c.firebaseapp.com",
        projectId: "ava-project-ab57c",
        storageBucket: "ava-project-ab57c.appspot.com",
        messagingSenderId: "69104603518",
        appId: "1:69104603518:web:4ff45ea30c6e823b1fe32f"),
  );

  Get.put(AuthController(), permanent: true);

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
        PointerDeviceKind.stylus,
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
  final AuthController authController = Get.find();
  _getThemeStatus() async {
    Rx<Future<bool?>> isDark = _prefs.then((SharedPreferences prefs) {
      return prefs.getBool('theme');
    }).obs;
    authController.isDarkTheme.value = (await isDark.value)!;

    Get.changeThemeMode(
        authController.isDarkTheme.value ? ThemeMode.dark : ThemeMode.light);
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
        transitionDuration: const Duration(milliseconds: 300),
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
