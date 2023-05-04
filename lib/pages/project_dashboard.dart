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
  const ProjectDashboard({Key? key, required this.projectId}) : super(key: key);

  @override
  State<ProjectDashboard> createState() => _ProjectDashboardState();
}

class _ProjectDashboardState extends State<ProjectDashboard> {
  final ProjectController projectController = Get.find();
  final ProfileController profileController = Get.find();
  final DepartmentController departmentController = Get.find();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  @override
  void initState() {
    super.initState();

    projectController.updateProject(widget.projectId);
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
                    key: _key,
                    drawerEnableOpenDragGesture: false,
                    appBar: customAppBar(context,
                        pageName:
                            '${departmentController.currentDepartment.value.title} - ${projectController.currentProject.value.title}',
                        isNeedAppbar: false),
                    drawer: assetsSection(context),
                    endDrawer: const EndDrawerWidget(),
                    body: Row(
                      children: [
                        leftSideIcons(context),
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
