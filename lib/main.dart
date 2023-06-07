import 'dart:async';

import 'package:ava/widgets/shared_preferences.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ava/splash.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:firedart/firedart.dart' as firedart;
import 'package:firebase_dart/core.dart' as firebase_dart;
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/auth_controller.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:firebase_dart/implementation/pure_dart.dart'
    as pure_dart_implementation;

const Color customColor = Color(0xff707070);

final MaterialColor customSwatch = MaterialColor(
  customColor.value,
  <int, Color>{
    50: customColor.withOpacity(0.1),
    100: customColor.withOpacity(0.2),
    200: customColor.withOpacity(0.3),
    300: customColor.withOpacity(0.4),
    400: customColor.withOpacity(0.5),
    500: customColor.withOpacity(0.6),
    600: customColor.withOpacity(0.7),
    700: customColor.withOpacity(0.8),
    800: customColor.withOpacity(0.9),
    900: customColor.withOpacity(1),
  },
);

ThemeData _darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: customSwatch,
  iconTheme: const IconThemeData(color: Colors.white60),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white60),
  ),
);

ThemeData _lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: customSwatch,
  iconTheme: const IconThemeData(color: Color(0xff707070)),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Color(0xff707070)),
  ),
);
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

  _getThemeStatus() async {
    final AuthController authController = Get.find<AuthController>();
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
    if (!kIsWeb) {
      _getThemeStatus();
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        key: const Key('MyAppKey'),
        theme: _lightTheme,
        darkTheme: _darkTheme,
        navigatorKey: Get.nestedKey(0), // provide navigation context
        initialRoute: '/',
        // onGenerateRoute: Get.routeTree,
        themeMode: ThemeMode.system,
        defaultTransition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 300),
        builder: (context, child) => ResponsiveBreakpoints.builder(
              child: child!,
              breakpoints: [
                const Breakpoint(start: 0, end: 450, name: MOBILE),
                const Breakpoint(start: 451, end: 800, name: TABLET),
                const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
              ],
            ),
        scrollBehavior: MyCustomScrollBehavior(),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen());
  }
}
