import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Ava/pages/recent_project.dart';

import '../constants/style.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

AppBar customAppBar(
  BuildContext context, {
  Widget? title,
  String? username,
  bool? isNeedAppbar,
}) {
  String firstChar = '';
  if (username != null) {
    for (int i = 0; i < username.length; i++) {
      firstChar += username[i];
    }
  } else {
    firstChar = "U";
  }

  return AppBar(
    backgroundColor: const Color(mainColor),
    leadingWidth: screenWidth(context) * 0.3,
    leading: Padding(
      padding: const EdgeInsets.only(left: 30),
      child: !kIsWeb
          ? Row(
              children: [
                isNeedAppbar == null
                    ? InkWell(
                        onTap: (() {
                          Get.back();
                        }),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.arrow_back_sharp),
                        ),
                      )
                    : Container(),
                InkWell(
                    onTap: () {
                      Get.to(() => const RecentProjects());
                    },
                    child: Image.asset(
                      'assets/images/logoMini.png',
                      height: 25,
                    )),
              ],
            )
          : InkWell(
              onTap: () {
                Get.to(() => const RecentProjects());
              },
              child: Image.asset(
                'assets/images/logoMini.png',
              )),
    ),
    centerTitle: true,
    title: title ?? Container(),
    actions: [
      Expanded(child: MoveWindow()),
      Padding(
        padding: const EdgeInsets.only(right: 50),
        child: Builder(
          builder: (context) => InkWell(
            onTap: () {
              Scaffold.of(context).openEndDrawer();
            },
            child: CircleAvatar(
              backgroundColor: const Color(secondaryColor),
              maxRadius: 20,
              child: Center(
                child: txt(
                    txt: firstChar[0].capitalize.toString(),
                    fontSize: 20,
                    fontColor: Colors.white),
              ),
            ),
          ),
        ),
      ),
      MinimizeWindowButton(colors: titleBarButtonColors),
      MaximizeWindowButton(
        colors: titleBarButtonColors,
      ),
      CloseWindowButton(
        colors: titleBarClosingButtonColors,
      )
    ],
  );
}
