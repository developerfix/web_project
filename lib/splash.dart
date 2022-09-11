import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Ava/constants/style.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // @override
  // void initState() {
  //   Timer(const Duration(seconds: 2), () {
  //     Get.to(const AuthScreen());
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(mainColor),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: SvgPicture.asset('assets/svgs/ava_logo.svg')),
          SizedBox(height: screenHeight(context) * 0.02),
          txt(
              txt: 'We manage your project from start to finish',
              fontSize: 22,
              fontColor: Colors.white)
        ],
      ),
    );
  }
}
