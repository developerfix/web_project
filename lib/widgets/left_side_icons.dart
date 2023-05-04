import 'package:ava/controllers/auth_controller.dart';
import 'package:ava/pages/departments_grid.dart';
import 'package:ava/widgets/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../constants/style.dart';
import '../pages/project_dashboard.dart';

SizedBox leftSideIcons(BuildContext context, {bool? isProjectsScreen}) {
  final AuthController authController = Get.find();
  return SizedBox(
    width: 100,
    child: Drawer(
      backgroundColor: isProjectsScreen != null ? const Color(mainColor) : null,
      child: Column(children: [
        homeScreenIcon(context, 'home_icon', ontap: () {
          Get.offAll(const DepartmentsGrid());
        }, isProjectsScreen: isProjectsScreen),
        homeScreenIcon(context, 'Group 13', ontap: () {
          if (SharedPrefs.getData(
                  key: authController.user!.uid + lastOpenedProjectId) !=
              null) {
            Get.to(() => ProjectDashboard(
                  projectId: SharedPrefs.getData(
                      key: authController.user!.uid + lastOpenedProjectId),
                ));
          }
        }, isProjectsScreen: isProjectsScreen),
        homeScreenIcon(context, 'Group 12', ontap: () {
          Get.to(() => const DepartmentsGrid());
        }, isProjectsScreen: isProjectsScreen),
        homeScreenIcon(context, 'comment_icon',
            isProjectsScreen: isProjectsScreen),
      ]),
    ),
  );
}

Padding homeScreenIcon(BuildContext context, String icon,
    {Function()? ontap, bool? isProjectsScreen, double? width}) {
  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: InkWell(
        onTap: ontap,
        child: SvgPicture.asset(
          'assets/svgs/$icon.svg',
          color:
              isProjectsScreen != null ? Colors.white : checkThemeColorwhite54,
          height: screenHeight(context) * 0.04,
        )),
  );
}
