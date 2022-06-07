import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:projectx/constants/style.dart';
import 'package:projectx/controllers/auth_controller.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(mainColor),
        leading: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: SvgPicture.asset(
            'assets/svgs/ava_logo.svg',
            height: 50,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 30,
                ),
                SizedBox(
                  width: screenWidth(context) * 0.01,
                ),
                InkWell(
                  onTap: () {
                    Get.to(const Profile());
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.lightGreen,
                    maxRadius: 20,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: screenHeight(context) * 0.05,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: screenWidth(context) * 0.1,
                height: screenHeight(context) * 0.15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: const Color(secondaryColor),
                ),
              ),
              SizedBox(
                width: screenWidth(context) * 0.02,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  txt(txt: 'John kelly', fontSize: 22),
                  txt(txt: 'Johnkelly@gmail.com', fontSize: 22),
                  txt(txt: 'Project: 34', fontSize: 22),
                ],
              )
            ],
          ),
          SizedBox(
            height: screenHeight(context) * 0.03,
          ),

          // Group: Group 65
          Container(
              width: screenWidth(context) * 0.3,
              height: screenHeight(context) * 0.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: const Color(secondaryColor),
              ),
              child: Center(
                  child: txt(
                      txt: 'Active Projects List',
                      fontSize: 22,
                      fontColor: Colors.white))),
          SizedBox(
            height: screenHeight(context) * 0.01,
          ),
          Container(
              width: screenWidth(context) * 0.3,
              height: screenHeight(context) * 0.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: const Color(secondaryColor),
              ),
              child: Center(
                  child: txt(
                      txt: 'Previous Projects List',
                      fontSize: 22,
                      fontColor: Colors.white))),
          SizedBox(
            height: screenHeight(context) * 0.01,
          ),
          InkWell(
            onTap: () {
              AuthController.instance.signOut();
            },
            child: Container(
                width: screenWidth(context) * 0.3,
                height: screenHeight(context) * 0.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: const Color(secondaryColor),
                ),
                child: Center(
                    child: txt(
                        txt: 'Logout', fontSize: 22, fontColor: Colors.white))),
          ),
        ],
      ),
    );
  }
}
