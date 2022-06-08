import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectx/pages/auth/authScreen.dart';
import 'package:projectx/splash.dart';

import 'controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthScreen(),
    );
  }
}
