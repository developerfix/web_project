import 'package:ava/constants/style.dart';
import 'package:ava/controllers/auth_controller.dart';
import 'package:ava/controllers/department_controller.dart';
import 'package:ava/models/project.dart';
import 'package:ava/widgets/custom_appbar.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ava/controllers/profile_controller.dart';
import 'package:ava/controllers/project_controller.dart';
import 'package:ava/widgets/loading_indicator.dart';
import '../widgets/assets_section.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/dashboard_main_section.dart';
import '../widgets/left_side_icons.dart';
import '../widgets/notes_section.dart';

class ProjectDashboard extends StatefulWidget {
  final String projectId;

  const ProjectDashboard({
    Key? key,
    required this.projectId,
  }) : super(key: key);

  @override
  State<ProjectDashboard> createState() => _ProjectDashboardState();
}

class _ProjectDashboardState extends State<ProjectDashboard> {
  final ProjectController projectController = Get.find<ProjectController>();
  final ProfileController profileController = Get.find<ProfileController>();
  final AuthController authController = Get.find<AuthController>();
  final _uid = AuthController.instance.user!.uid;
  final DepartmentController departmentController =
      Get.find<DepartmentController>();
  final commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  @override
  void initState() {
    super.initState();

    projectController.updateProject(
        projectId: widget.projectId,
        departmentId: departmentController.currentDepartment.value.departmentId,
        uid: _uid);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return GetBuilder<ProjectController>(
          init: ProjectController(),
          builder: (controller) {
            if (controller.currentProject.value == Project()) {
              return const LoadingIndicator();
            } else {
              return Obx(() {
                return Scaffold(
                    key: scaffoldAssetsDrawerKey,
                    drawerEnableOpenDragGesture: false,
                    appBar: customAppBar(context,
                        pageName:
                            '${departmentController.currentDepartment.value.title} - ${projectController.currentProject.value.title}',
                        isNeedAppbar: false),
                    drawer: assetsSection(context),
                    endDrawer: profileController.isNotesDrawer.value
                        ? notesSection(constraints, context,
                            commentController: commentController,
                            profileController: profileController,
                            projectController: projectController,
                            scrollController: _scrollController)
                        : const EndDrawerWidget(),
                    body: Row(
                      children: [
                        leftSideIcons(context, isMainProjectsScreen: true),
                        constraints.maxWidth > 1800
                            ? assetsSection(
                                context,
                              )
                            : Container(),
                        dashboardMainSection(context, constraints,
                            profileController: profileController,
                            projectController: projectController),
                        constraints.maxWidth < 1500
                            ? Container()
                            : notesSection(constraints, context,
                                commentController: commentController,
                                profileController: profileController,
                                projectController: projectController,
                                scrollController: _scrollController)
                      ],
                    ));
              });
            }
          });
    });
  }
}
