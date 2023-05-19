import 'package:ava/controllers/auth_controller.dart';
import 'package:ava/controllers/department_controller.dart';
import 'package:ava/controllers/profile_controller.dart';
import 'package:ava/controllers/project_controller.dart';
import 'package:ava/pages/departments_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../constants/style.dart';
import '../pages/GanttChart/timeline.dart';
import '../pages/project_dashboard.dart';

SizedBox leftSideIcons(
  BuildContext context, {
  bool? isProjectsScreen,
  bool? isMainProjectsScreen,
}) {
  return SizedBox(
    width: 100,
    child: Drawer(
        backgroundColor:
            isProjectsScreen != null ? const Color(mainColor) : null,
        child: Column(children: [
          homeScreenSvg(context, 'home_icon',
              isRecentProjectIcon: false,
              isRecentGanttchartIcon: false, ontap: () {
            Get.offAll(const DepartmentsGrid());
          }, isProjectsScreen: isProjectsScreen),
          homeScreenSvg(context, 'Group 13',
              isRecentGanttchartIcon: false,
              isRecentProjectIcon: true,
              isProjectsScreen: isProjectsScreen),
          homeScreenSvg(context, 'Group 12',
              isRecentGanttchartIcon: true,
              isRecentProjectIcon: true,
              isProjectsScreen: isProjectsScreen),
          isMainProjectsScreen != null && screenWidth(context) < 1800
              ? homeScreenIcon(
                  context,
                  Icons.folder_open_outlined,
                  ontap: () {
                    scaffoldAssetsDrawerKey.currentState!.openDrawer();
                  },
                )
              : Container(),
          isMainProjectsScreen != null && screenWidth(context) < 1500
              ? GetBuilder<ProfileController>(
                  init: ProfileController(),
                  builder: (controller) => homeScreenSvg(
                          context, 'comment_icon',
                          isRecentProjectIcon: false,
                          isRecentGanttchartIcon: false, ontap: () {
                        controller.isNotesDrawer.value = true;
                        controller.update();
                        scaffoldAssetsDrawerKey.currentState!.openEndDrawer();
                      }, isProjectsScreen: isProjectsScreen))
              : Container()
        ])),
  );
}

Padding homeScreenSvg(
  BuildContext context,
  String icon, {
  Function()? ontap,
  bool? isProjectsScreen,
  required bool isRecentProjectIcon,
  required bool isRecentGanttchartIcon,
}) {
  final ProfileController profileController = Get.find<ProfileController>();
  final ProjectController projectController = Get.find<ProjectController>();
  final AuthController authController = Get.find<AuthController>();
  final DepartmentController departmentController =
      Get.find<DepartmentController>();

  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: InkWell(
        onTap: isRecentProjectIcon
            ? profileController.currentUser.value.lastOpenedProjectId != null
                ? profileController
                        .currentUser.value.lastOpenedProjectId!.isEmpty
                    ? null
                    : () {
                        for (var element in profileController.departments) {
                          if (element.departmentId ==
                              profileController
                                  .currentUser.value.lastOpenedDocumentId) {
                            departmentController.currentDepartment.value =
                                element;
                            departmentController.update();
                          }
                        }
                        projectController.deepartmentId.value =
                            profileController
                                .currentUser.value.lastOpenedDocumentId!;
                        projectController.uuid.value =
                            profileController.currentUser.value.uid!;
                        projectController.update();

                        if (isRecentGanttchartIcon) {
                          projectController.updateProject(
                              projectId: profileController
                                  .currentUser.value.lastOpenedProjectId!,
                              departmentId: departmentController
                                  .currentDepartment.value.departmentId,
                              uid: profileController.currentUser.value.uid);

                          Get.to(() => const Timelinee());
                        } else {
                          Get.to(() => ProjectDashboard(
                              projectId: profileController
                                  .currentUser.value.lastOpenedProjectId!));
                        }
                      }
                : null
            : ontap,
        child: SvgPicture.asset(
          'assets/svgs/$icon.svg',
          color: isProjectsScreen != null
              ? isRecentProjectIcon
                  ? profileController.currentUser.value.lastOpenedProjectId !=
                          null
                      ? profileController
                              .currentUser.value.lastOpenedProjectId!.isEmpty
                          ? Colors.white.withOpacity(0.5)
                          : Colors.white
                      : Colors.white
                  : Colors.white
              : (authController.isDarkTheme.value
                  ? Colors.white60
                  : brownishColor),
          height: screenHeight(context) * 0.04,
        )),
  );
}

Padding homeScreenIcon(
  BuildContext context,
  IconData icon, {
  Function()? ontap,
}) {
  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: InkWell(
        onTap: ontap,
        child: Icon(
          icon,
          size: 50,
        )),
  );
}
