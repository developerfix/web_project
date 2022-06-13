import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../constants/style.dart';
import '../pages/profile.dart';

AppBar customAppBar(BuildContext context) {
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
                backgroundColor: Color(secondaryColor),
                maxRadius: 20,
              ),
            )
          ],
        ),
      ),
    ],
  );
}
