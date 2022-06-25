import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:projectx/pages/recent_project.dart';

import '../constants/style.dart';
import '../pages/profile.dart';

AppBar customAppBar(BuildContext context, {Widget? title, String? username}) {
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
    leadingWidth:
        screenWidth(context) > 1000 ? screenWidth(context) * 0.04 : null,
    leading: Padding(
      padding: const EdgeInsets.only(left: 30),
      child: InkWell(
          onTap: () {
            Get.to(const RecentProjects());
          },
          child: Image.asset(
            'assets/images/logoMini.png',
          )),
    ),
    centerTitle: true,
    title: title ?? Container(),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 50),
        child: Builder(
          builder: (context) => InkWell(
            onTap: () {
              Scaffold.of(context).openEndDrawer();
            },
            child: CircleAvatar(
              backgroundColor: const Color(secondaryColor),
              maxRadius: 25,
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
    ],
  );
}
