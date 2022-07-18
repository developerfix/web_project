import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectx/splash.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:firedart/firedart.dart' as firedart;
import 'controllers/auth_controller.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:firebase_dart/implementation/pure_dart.dart'
    as pure_dart_implementation;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    var firebaseAuth = firedart.FirebaseAuth(
        'AIzaSyC9Jzj22llAEY9Zj1LjVMOxI8kVIFjP2VY', firedart.VolatileStore());
    firedart.Firestore('ava-project-ab57c', auth: firebaseAuth);
    firedart.Firestore.initialize("ava-project-ab57c");
  }
  pure_dart_implementation.FirebaseDart.setup();

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

  runApp(GetMaterialApp(
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyApp()));
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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
