import 'package:ava/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/style.dart';
import 'cached_image.dart';

Obx profileAvatar(BuildContext context,
    {double? fontSize, double? maxRadius, bool? isDrawer}) {
  final ProfileController profileController = Get.find();
  return Obx(
    () => profileController.currentUser.value.profilePhoto != ''
        ? cachedImage(
            context,
            fontSize: fontSize,
            isDrawer: isDrawer,
            maxRadius: maxRadius,
            url: profileController.currentUser.value.profilePhoto ??
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdvd0bRebMPnsU2r46Hb_BGsRcoS687MMqug&usqp=CAU',
          )
        : CircleAvatar(
            backgroundColor: isDrawer != null
                ? const Color(mainColor)
                : const Color(secondaryColor),
            maxRadius: maxRadius ?? 20,
            child: Center(
              child: txt(
                  txt: profileController.currentUser.value.name?[0]
                          .toUpperCase() ??
                      'U',
                  fontSize: fontSize ?? 20,
                  fontColor: Colors.white),
            ),
          ),
  );
}
