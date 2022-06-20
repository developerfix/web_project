import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../constants/style.dart';
import '../pages/profile.dart';

AppBar customAppBar(BuildContext context, {Widget? title}) {
  return AppBar(
    backgroundColor: const Color(mainColor),
    leadingWidth: screenWidth(context) * 0.04,
    leading: Padding(
      padding: const EdgeInsets.only(left: 30),
      child: SvgPicture.asset(
        'assets/svgs/logoMini.svg',
        fit: BoxFit.contain,
      ),
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
            child: const CircleAvatar(
              backgroundColor: Color(secondaryColor),
              maxRadius: 20,
            ),
          ),
        ),
      ),
    ],
  );
}
