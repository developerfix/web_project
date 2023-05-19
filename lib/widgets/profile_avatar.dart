import 'package:ava/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/style.dart';
import 'cached_image.dart';

GetBuilder<ProfileController> profileAvatar(
  BuildContext context, {
  double? fontSize,
  double? maxRadius,
  bool? isDrawer,
  bool? isAppBar,
}) {
  return GetBuilder<ProfileController>(
    init: ProfileController(),
    builder: (controller) => controller.currentUser.value.profilePhoto !=
                null &&
            controller.currentUser.value.profilePhoto!.isNotEmpty
        ? cachedImage(
            context,
            fontSize: fontSize,
            isUploading: controller.isProfileUploading.value,
            isAppBar: isAppBar,
            isDrawer: isDrawer,
            maxRadius: maxRadius,
            url: controller.currentUser.value.profilePhoto!,
          )
        : CircleAvatar(
            backgroundColor: isDrawer != null
                ? const Color(mainColor)
                : const Color(secondaryColor),
            maxRadius: maxRadius ?? 20,
            child: Center(
              child: txt(
                  txt: controller.currentUser.value.name?[0].toUpperCase() ??
                      'U',
                  fontSize: fontSize ?? 20,
                  fontColor: Colors.white),
            ),
          ),
  );
}
