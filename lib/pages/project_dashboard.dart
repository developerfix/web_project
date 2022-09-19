import 'package:Ava/widgets/custom_appbar.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Ava/constants/style.dart';
import 'package:Ava/controllers/auth_controller.dart';
import 'package:Ava/controllers/profile_controller.dart';
import 'package:Ava/controllers/project_controller.dart';
import 'package:Ava/widgets/loading_indicator.dart';

import '../widgets/assets_section.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/dashboard_main_section.dart';
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
  final _uid = AuthController.instance.user!.uid;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  @override
  void initState() {
    super.initState();

    projectController.updateProject(projectId: widget.projectId, uid: _uid);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
            if (controller.project.isEmpty) {
              return const LoadingIndicator();
            } else {
              return Obx(() {
                return Scaffold(
                    key: _key,
                    drawerEnableOpenDragGesture: false,
                    appBar: customAppBar(context,
                        username: profileController.user['name'],
                        isNeedAppbar: false),
                    drawer: assetsSection(context),
                    endDrawer: const EndDrawerWidget(),
                    body: Row(
                      children: [
                        constraints.maxWidth > 1800
                            ? assetsSection(context,
                                projectController: projectController)
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
