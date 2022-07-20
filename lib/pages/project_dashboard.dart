import 'dart:typed_data';

import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_saver/file_saver.dart';
import 'package:projectx/constants/style.dart';
import 'package:projectx/controllers/auth_controller.dart';
import 'package:projectx/controllers/profile_controller.dart';
import 'package:projectx/controllers/project_controller.dart';
import 'package:projectx/pages/add_new_task.dart';
import 'package:projectx/pages/project_members.dart';
import 'package:projectx/pages/update_task.dart';
import 'package:projectx/pages/recent_project.dart';
import 'package:projectx/pages/timeline.dart';
import 'package:projectx/widgets/asset_popup.dart';
import 'package:projectx/widgets/loading_indicator.dart';

import '../widgets/custom_drawer.dart';

class ProjectDashboard extends StatefulWidget {
  final String projectId;
  const ProjectDashboard({Key? key, required this.projectId}) : super(key: key);

  @override
  State<ProjectDashboard> createState() => _ProjectDashboardState();
}

class _ProjectDashboardState extends State<ProjectDashboard> {
  final ProjectController projectController = Get.put(ProjectController());
  final ProfileController profileController = Get.find();
  final _uid = AuthController.instance.user!.uid;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  bool isAssetsRefreshing = false;
  bool isCommentsRefreshing = false;

  @override
  void initState() {
    super.initState();

    projectController.updateProjectAndUserId(
        projectId: widget.projectId, uid: _uid);
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
                    appBar: AppBar(
                      backgroundColor: const Color(mainColor),
                      leadingWidth: screenWidth(context) > 1000
                          ? screenWidth(context) * 0.04
                          : null,
                      leading: constraints.maxWidth < 1800
                          ? Row(
                              children: [
                                Expanded(
                                  child: Builder(
                                      builder: (context) => InkWell(
                                          onTap: () {
                                            Scaffold.of(context).openDrawer();
                                          },
                                          child: const Icon(Icons.menu))),
                                ),
                                Expanded(
                                  child: InkWell(
                                      onTap: () {
                                        Get.to(const RecentProjects());
                                      },
                                      child: Image.asset(
                                        'assets/images/logoMini.png',
                                      )),
                                ),
                              ],
                            )
                          : Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: InkWell(
                                  onTap: () {
                                    Get.to(const RecentProjects());
                                  },
                                  child: Image.asset(
                                    'assets/images/logoMini.png',
                                  )),
                            ),
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
                                      txt: profileController.user['name']
                                          .toString()[0]
                                          .capitalizeFirst!,
                                      fontSize: 20,
                                      fontColor: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    drawer: Drawer(
                      child: Column(
                        children: <Widget>[
                          DrawerHeader(
                            margin: EdgeInsets.zero,
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  addAssetPopUp(context);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.add,
                                      color: Color(brownishColor),
                                      size: 30,
                                    ),
                                    // txt(
                                    //   txt: "ASSETS",
                                    //   font: 'comfortaa',
                                    //   fontSize: 30.0,
                                    //   fontColor: const Color(brownishColor),
                                    //   letterSpacing: 5,
                                    //   fontWeight: FontWeight.bold,
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Obx(() {
                            return SizedBox(
                              height: screenHeight(context) * 0.6,
                              width: screenWidth(context) * 0.12,
                              child: projectController.assets.isEmpty
                                  ? Center(
                                      child: txt(
                                          txt: 'Add assets here', fontSize: 14),
                                    )
                                  : ListView.builder(
                                      itemCount:
                                          projectController.assets.length,
                                      itemBuilder: (context, i) {
                                        String path =
                                            projectController.assets[i]['path'];
                                        return constraints.maxWidth < 1200
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Icon(
                                                      Icons.link,
                                                      color:
                                                          Color(secondaryColor),
                                                    ),
                                                    txt(
                                                        txt: path,
                                                        fontSize: 14,
                                                        fontColor: const Color(
                                                            secondaryColor),
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                    InkWell(
                                                        onTap: () async {
                                                          setState(() {
                                                            isAssetsRefreshing =
                                                                true;
                                                          });
                                                          await projectController
                                                              .deleteProjectAsset(
                                                                  path: projectController
                                                                          .assets[i]
                                                                      ['path']);
                                                          setState(() {
                                                            isAssetsRefreshing =
                                                                false;
                                                          });
                                                        },
                                                        child: const Icon(
                                                          Icons.delete_sharp,
                                                          color: Color(
                                                              secondaryColor),
                                                        )),
                                                  ],
                                                ),
                                              )
                                            : ListTile(
                                                leading: const Icon(
                                                  Icons.link,
                                                ),
                                                title: txt(
                                                    txt: path,
                                                    fontSize: 14,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                                trailing: InkWell(
                                                    onTap: () async {
                                                      setState(() {
                                                        isAssetsRefreshing =
                                                            true;
                                                      });
                                                      await projectController
                                                          .deleteProjectAsset(
                                                              path: projectController
                                                                      .assets[i]
                                                                  ['path']);
                                                      setState(() {
                                                        isAssetsRefreshing =
                                                            false;
                                                      });
                                                    },
                                                    child: const Icon(
                                                      Icons.delete_sharp,
                                                    )),
                                                onTap: () {},
                                              );
                                      }),
                            );
                          }),
                          const Spacer(),
                          ListTile(
                              onTap: () {
                                Get.to(AddNewTask(
                                  projectId: widget.projectId,
                                ));
                              },
                              leading: const Icon(
                                Icons.task,
                              ),
                              title: txt(txt: 'Add new task', fontSize: 14)),
                          ListTile(
                              onTap: () {
                                Get.to(const ProjectMembersList());
                              },
                              leading: const Icon(
                                Icons.person_add,
                              ),
                              title: txt(
                                  txt: 'Manage project members', fontSize: 14)),
                          const Divider(),
                          constraints.maxWidth < 800
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Get.to(const RecentProjects());
                                      },
                                      child: const Icon(
                                        Icons.home,
                                        size: 50,
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenHeight(context) * 0.03,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.to(const Timeline());
                                      },
                                      child: const Icon(
                                        Icons.timeline,
                                        size: 50,
                                      ),
                                    ),
                                  ],
                                )
                              : ListTile(
                                  leading: InkWell(
                                    onTap: () {
                                      Get.to(const RecentProjects());
                                    },
                                    child: const Icon(
                                      Icons.home,
                                      size: 50,
                                    ),
                                  ),
                                  trailing: InkWell(
                                    onTap: () {
                                      Get.to(const Timeline());
                                    },
                                    child: const Icon(
                                      Icons.timeline,
                                      size: 50,
                                    ),
                                  ),
                                  onTap: null,
                                ),
                          SizedBox(height: screenHeight(context) * 0.01)
                        ],
                      ),
                    ),
                    endDrawer: const EndDrawerWidget(),
                    body: SizedBox(
                      height: screenHeight(context),
                      width: screenWidth(context),
                      child: Row(
                        children: [
                          constraints.maxWidth > 1800
                              ? Drawer(
                                  child: Column(
                                    children: <Widget>[
                                      DrawerHeader(
                                        margin: EdgeInsets.zero,
                                        child: Center(
                                          child: InkWell(
                                            onTap: () {
                                              addAssetPopUp(context);
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.add,
                                                  color: Color(brownishColor),
                                                  size: 30,
                                                ),
                                                txt(
                                                  txt: "ASSETS",
                                                  fontSize: 30.0,
                                                  fontColor: const Color(
                                                      brownishColor),
                                                  letterSpacing: 5,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Obx(() {
                                        return SizedBox(
                                          height: screenHeight(context) * 0.6,
                                          width: screenWidth(context) * 0.12,
                                          child: projectController
                                                  .assets.isEmpty
                                              ? Center(
                                                  child: txt(
                                                      txt: 'Add assets here',
                                                      fontSize: 14),
                                                )
                                              : ListView.builder(
                                                  itemCount: projectController
                                                      .assets.length,
                                                  itemBuilder: (context, i) {
                                                    String path =
                                                        projectController
                                                            .assets[i]['path'];
                                                    return ListTile(
                                                      leading: const Icon(
                                                        Icons.link,
                                                      ),
                                                      title: txt(
                                                          txt: path,
                                                          fontSize: 14,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                      trailing: InkWell(
                                                          onTap: () async {
                                                            setState(() {
                                                              isAssetsRefreshing =
                                                                  true;
                                                            });
                                                            await projectController
                                                                .deleteProjectAsset(
                                                                    path: projectController
                                                                            .assets[i]
                                                                        [
                                                                        'path']);
                                                            setState(() {
                                                              isAssetsRefreshing =
                                                                  false;
                                                            });
                                                          },
                                                          child: const Icon(
                                                            Icons.delete_sharp,
                                                          )),
                                                      onTap: () {},
                                                    );
                                                  }),
                                        );
                                      }),
                                      const Spacer(),
                                      ListTile(
                                          onTap: () {
                                            Get.to(AddNewTask(
                                              projectId: widget.projectId,
                                            ));
                                          },
                                          leading: const Icon(
                                            Icons.task,
                                          ),
                                          title: txt(
                                              txt: 'Add new task',
                                              fontSize: 14)),
                                      ListTile(
                                          onTap: () {
                                            Get.to(const ProjectMembersList());
                                          },
                                          leading: const Icon(
                                            Icons.person_add,
                                          ),
                                          title: txt(
                                              txt: 'Manage project members',
                                              fontSize: 14)),
                                      const Divider(),
                                      ListTile(
                                        leading: InkWell(
                                          onTap: () {
                                            Get.to(const RecentProjects());
                                          },
                                          child: const Icon(
                                            Icons.home,
                                            size: 50,
                                          ),
                                        ),
                                        trailing: InkWell(
                                          onTap: () {
                                            Get.to(const Timeline());
                                          },
                                          child: const Icon(
                                            Icons.timeline,
                                            size: 50,
                                          ),
                                        ),
                                        onTap: null,
                                      ),
                                      SizedBox(
                                          height: screenHeight(context) * 0.01)
                                    ],
                                  ),
                                )
                              : Container(),
                          Expanded(
                            flex: 5,
                            child: SizedBox(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 30, 50, 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        txt(
                                          txt: projectController
                                              .project['title'],
                                          fontSize: 60,
                                          maxLines: 1,
                                          minFontSize: 14,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 5,
                                        ),
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                txt(
                                                  txt: 'LEAD :',
                                                  fontSize: 20,
                                                  minFontSize: 8,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                txt(
                                                  txt: 'CO-PILOT :',
                                                  fontSize: 20,
                                                  minFontSize: 8,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width:
                                                  screenWidth(context) * 0.005,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                txt(
                                                  txt: projectController
                                                                  .project[
                                                              'lead'] ==
                                                          'assign lead'
                                                      ? projectController
                                                          .project['lead']
                                                      : '@${projectController.project['lead']} ',
                                                  fontSize: 20,
                                                  minFontSize: 8,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                txt(
                                                  txt: projectController
                                                                  .project[
                                                              'copilot'] ==
                                                          'assign co-pilot'
                                                      ? projectController
                                                          .project['copilot']
                                                      : '@${projectController.project['copilot']} ',
                                                  fontSize: 20,
                                                  minFontSize: 8,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: screenWidth(context) * 0.47,
                                      child: txt(
                                        txt: projectController
                                            .project['subtitle'],
                                        fontSize: 30,
                                        minFontSize: 14,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenHeight(context) * 0.05,
                                    ),
                                    // BoardSection(),
                                    Obx(() {
                                      return Expanded(
                                          child:
                                              projectController
                                                          .toDoTasks.isEmpty &&
                                                      projectController
                                                          .inProgressTasks
                                                          .isEmpty &&
                                                      projectController
                                                          .completedTasks
                                                          .isEmpty
                                                  ? Center(
                                                      child: txt(
                                                          txt:
                                                              'Added tasks will be listed here',
                                                          fontSize: 14),
                                                    )
                                                  : constraints.maxWidth < 1200
                                                      ? ListView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          children: [
                                                            SizedBox(
                                                              width: 400,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                child: Column(
                                                                  children: [
                                                                    statusContainer(
                                                                        context,
                                                                        'TODO'),
                                                                    SizedBox(
                                                                      height: screenHeight(
                                                                              context) *
                                                                          0.02,
                                                                    ),
                                                                    Container(
                                                                      height: screenHeight(
                                                                              context) *
                                                                          0.73,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        color: Color(
                                                                            0xfff0f2f5),
                                                                        borderRadius:
                                                                            BorderRadius.only(
                                                                          topLeft:
                                                                              Radius.circular(10),
                                                                          topRight:
                                                                              Radius.circular(10),
                                                                        ),
                                                                      ),
                                                                      child: projectController.isTasksUpdating.isTrue ||
                                                                              projectController.isNewTasksUpdating.isTrue
                                                                          ? Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                const LoadingIndicator(),
                                                                                txt(txt: 'Please wait\n Task is being updated', fontSize: 14)
                                                                              ],
                                                                            )
                                                                          : projectController.toDoTasks.isEmpty
                                                                              ? Center(
                                                                                  child: txt(txt: 'No task in Todo list', fontSize: 14),
                                                                                )
                                                                              : ListView.builder(
                                                                                  // shrinkWrap: true,
                                                                                  // reverse: true,
                                                                                  itemCount: projectController.toDoTasks.length,

                                                                                  itemBuilder: (context, i) {
                                                                                    final String taskTitle = projectController.toDoTasks[i]['taskTitle'];
                                                                                    final String phase = projectController.toDoTasks[i]['phase'];
                                                                                    final String taskDescription = projectController.toDoTasks[i]['taskDescription'];
                                                                                    final String pilot = projectController.toDoTasks[i]['pilot'];
                                                                                    final String copilot = projectController.toDoTasks[i]['copilot'];
                                                                                    final String startDate = projectController.toDoTasks[i]['startDate'];
                                                                                    final String endDate = projectController.toDoTasks[i]['endDate'];

                                                                                    final int priorityLevel = projectController.toDoTasks[i]['priorityLevel'];
                                                                                    final String status = projectController.toDoTasks[i]['status'];
                                                                                    return listOfTasks(context, 'todo', taskTitle, phase, taskDescription, pilot, copilot, priorityLevel, status, startDate, endDate);
                                                                                  },
                                                                                ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 400,
                                                              child: Column(
                                                                children: [
                                                                  statusContainer(
                                                                      context,
                                                                      'INPROGRESS'),
                                                                  SizedBox(
                                                                    height: screenHeight(
                                                                            context) *
                                                                        0.02,
                                                                  ),
                                                                  Container(
                                                                    height: screenHeight(
                                                                            context) *
                                                                        0.73,
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      color: Color(
                                                                          0xfff0f2f5),
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .only(
                                                                        topLeft:
                                                                            Radius.circular(10),
                                                                        topRight:
                                                                            Radius.circular(10),
                                                                      ),
                                                                    ),
                                                                    child: projectController
                                                                            .isTasksUpdating
                                                                            .isTrue
                                                                        ? Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              const LoadingIndicator(),
                                                                              txt(txt: 'Please wait\n Task is being updated', fontSize: 14)
                                                                            ],
                                                                          )
                                                                        : projectController.inProgressTasks.isEmpty
                                                                            ? Center(
                                                                                child: txt(txt: 'No task in progress', fontSize: 14),
                                                                              )
                                                                            : ListView.builder(
                                                                                // shrinkWrap: true,
                                                                                // reverse: true,
                                                                                itemCount: projectController.inProgressTasks.length,

                                                                                itemBuilder: (context, i) {
                                                                                  final String taskTitle = projectController.inProgressTasks[i]['taskTitle'];
                                                                                  final String phase = projectController.inProgressTasks[i]['phase'];
                                                                                  final String taskDescription = projectController.inProgressTasks[i]['taskDescription'];
                                                                                  final String pilot = projectController.inProgressTasks[i]['pilot'];
                                                                                  final String copilot = projectController.inProgressTasks[i]['copilot'];
                                                                                  final String startDate = projectController.inProgressTasks[i]['startDate'];
                                                                                  final String endDate = projectController.inProgressTasks[i]['endDate'];

                                                                                  final int priorityLevel = projectController.inProgressTasks[i]['priorityLevel'];
                                                                                  final String status = projectController.inProgressTasks[i]['status'];
                                                                                  return listOfTasks(context, 'inProgress', taskTitle, phase, taskDescription, pilot, copilot, priorityLevel, status, startDate, endDate);
                                                                                },
                                                                              ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 400,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                child: Column(
                                                                  children: [
                                                                    statusContainer(
                                                                        context,
                                                                        'COMPLETED'),
                                                                    SizedBox(
                                                                      height: screenHeight(
                                                                              context) *
                                                                          0.02,
                                                                    ),
                                                                    Container(
                                                                      height: screenHeight(
                                                                              context) *
                                                                          0.73,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        color: Color(
                                                                            0xfff0f2f5),
                                                                        borderRadius:
                                                                            BorderRadius.only(
                                                                          topLeft:
                                                                              Radius.circular(10),
                                                                          topRight:
                                                                              Radius.circular(10),
                                                                        ),
                                                                      ),
                                                                      child: projectController
                                                                              .isTasksUpdating
                                                                              .isTrue
                                                                          ? Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                const LoadingIndicator(),
                                                                                txt(txt: 'Please wait\n Task is being updated', fontSize: 14)
                                                                              ],
                                                                            )
                                                                          : projectController.completedTasks.isEmpty
                                                                              ? Center(
                                                                                  child: txt(txt: 'No task in completed list', fontSize: 14),
                                                                                )
                                                                              : ListView.builder(
                                                                                  // shrinkWrap: true,
                                                                                  // reverse: true,
                                                                                  itemCount: projectController.completedTasks.length,

                                                                                  itemBuilder: (context, i) {
                                                                                    final String taskTitle = projectController.completedTasks[i]['taskTitle'];
                                                                                    final String phase = projectController.completedTasks[i]['phase'];
                                                                                    final String taskDescription = projectController.completedTasks[i]['taskDescription'];
                                                                                    final String pilot = projectController.completedTasks[i]['pilot'];
                                                                                    final String copilot = projectController.completedTasks[i]['copilot'];
                                                                                    final String startDate = projectController.completedTasks[i]['startDate'];
                                                                                    final String endDate = projectController.completedTasks[i]['endDate'];

                                                                                    final int priorityLevel = projectController.completedTasks[i]['priorityLevel'];
                                                                                    final String status = projectController.completedTasks[i]['status'];
                                                                                    return listOfTasks(context, 'completed', taskTitle, phase, taskDescription, pilot, copilot, priorityLevel, status, startDate, endDate);
                                                                                  },
                                                                                ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : Row(
                                                          children: [
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                child: Column(
                                                                  children: [
                                                                    statusContainer(
                                                                        context,
                                                                        'TODO'),
                                                                    SizedBox(
                                                                      height: screenHeight(
                                                                              context) *
                                                                          0.02,
                                                                    ),
                                                                    Container(
                                                                      height: screenHeight(
                                                                              context) *
                                                                          0.73,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        color: Color(
                                                                            0xfff0f2f5),
                                                                        borderRadius:
                                                                            BorderRadius.only(
                                                                          topLeft:
                                                                              Radius.circular(10),
                                                                          topRight:
                                                                              Radius.circular(10),
                                                                        ),
                                                                      ),
                                                                      child: projectController
                                                                              .isTasksUpdating
                                                                              .isTrue
                                                                          ? Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                const LoadingIndicator(),
                                                                                txt(txt: 'Please wait\n Task is being updated', fontSize: 14)
                                                                              ],
                                                                            )
                                                                          : projectController.toDoTasks.isEmpty
                                                                              ? Center(
                                                                                  child: txt(txt: 'No task in Todo list', fontSize: 14),
                                                                                )
                                                                              : ListView.builder(
                                                                                  // shrinkWrap: true,
                                                                                  // reverse: true,
                                                                                  itemCount: projectController.toDoTasks.length,

                                                                                  itemBuilder: (context, i) {
                                                                                    final String taskTitle = projectController.toDoTasks[i]['taskTitle'];
                                                                                    final String phase = projectController.toDoTasks[i]['phase'];
                                                                                    final String taskDescription = projectController.toDoTasks[i]['taskDescription'];
                                                                                    final String pilot = projectController.toDoTasks[i]['pilot'];
                                                                                    final String copilot = projectController.toDoTasks[i]['copilot'];
                                                                                    final String startDate = projectController.toDoTasks[i]['startDate'];
                                                                                    final String endDate = projectController.toDoTasks[i]['endDate'];

                                                                                    final int priorityLevel = projectController.toDoTasks[i]['priorityLevel'];
                                                                                    final String status = projectController.toDoTasks[i]['status'];
                                                                                    return listOfTasks(context, 'todo', taskTitle, phase, taskDescription, pilot, copilot, priorityLevel, status, startDate, endDate);
                                                                                  },
                                                                                ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                children: [
                                                                  statusContainer(
                                                                      context,
                                                                      'INPROGRESS'),
                                                                  SizedBox(
                                                                    height: screenHeight(
                                                                            context) *
                                                                        0.02,
                                                                  ),
                                                                  Container(
                                                                    height: screenHeight(
                                                                            context) *
                                                                        0.73,
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      color: Color(
                                                                          0xfff0f2f5),
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .only(
                                                                        topLeft:
                                                                            Radius.circular(10),
                                                                        topRight:
                                                                            Radius.circular(10),
                                                                      ),
                                                                    ),
                                                                    child: projectController
                                                                            .isTasksUpdating
                                                                            .isTrue
                                                                        ? Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              const LoadingIndicator(),
                                                                              txt(txt: 'Please wait\n Task is being updated', fontSize: 14)
                                                                            ],
                                                                          )
                                                                        : projectController.inProgressTasks.isEmpty
                                                                            ? Center(
                                                                                child: txt(txt: 'No task in progress', fontSize: 14),
                                                                              )
                                                                            : ListView.builder(
                                                                                // shrinkWrap: true,
                                                                                // reverse: true,
                                                                                itemCount: projectController.inProgressTasks.length,

                                                                                itemBuilder: (context, i) {
                                                                                  final String taskTitle = projectController.inProgressTasks[i]['taskTitle'];
                                                                                  final String phase = projectController.inProgressTasks[i]['phase'];
                                                                                  final String taskDescription = projectController.inProgressTasks[i]['taskDescription'];
                                                                                  final String pilot = projectController.inProgressTasks[i]['pilot'];
                                                                                  final String copilot = projectController.inProgressTasks[i]['copilot'];
                                                                                  final String startDate = projectController.inProgressTasks[i]['startDate'];
                                                                                  final String endDate = projectController.inProgressTasks[i]['endDate'];

                                                                                  final int priorityLevel = projectController.inProgressTasks[i]['priorityLevel'];
                                                                                  final String status = projectController.inProgressTasks[i]['status'];
                                                                                  return listOfTasks(context, 'inProgress', taskTitle, phase, taskDescription, pilot, copilot, priorityLevel, status, startDate, endDate);
                                                                                },
                                                                              ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                child: Column(
                                                                  children: [
                                                                    statusContainer(
                                                                        context,
                                                                        'COMPLETED'),
                                                                    SizedBox(
                                                                      height: screenHeight(
                                                                              context) *
                                                                          0.02,
                                                                    ),
                                                                    Container(
                                                                      height: screenHeight(
                                                                              context) *
                                                                          0.73,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        color: Color(
                                                                            0xfff0f2f5),
                                                                        borderRadius:
                                                                            BorderRadius.only(
                                                                          topLeft:
                                                                              Radius.circular(10),
                                                                          topRight:
                                                                              Radius.circular(10),
                                                                        ),
                                                                      ),
                                                                      child: projectController
                                                                              .isTasksUpdating
                                                                              .isTrue
                                                                          ? Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                const LoadingIndicator(),
                                                                                txt(txt: 'Please wait\n Task is being updated', fontSize: 14)
                                                                              ],
                                                                            )
                                                                          : projectController.completedTasks.isEmpty
                                                                              ? Center(
                                                                                  child: txt(txt: 'No task in completed list', fontSize: 14),
                                                                                )
                                                                              : ListView.builder(
                                                                                  // shrinkWrap: true,
                                                                                  // reverse: true,
                                                                                  itemCount: projectController.completedTasks.length,

                                                                                  itemBuilder: (context, i) {
                                                                                    final String taskTitle = projectController.completedTasks[i]['taskTitle'];
                                                                                    final String phase = projectController.completedTasks[i]['phase'];
                                                                                    final String taskDescription = projectController.completedTasks[i]['taskDescription'];
                                                                                    final String pilot = projectController.completedTasks[i]['pilot'];
                                                                                    final String copilot = projectController.completedTasks[i]['copilot'];
                                                                                    final String startDate = projectController.completedTasks[i]['startDate'];
                                                                                    final String endDate = projectController.completedTasks[i]['endDate'];

                                                                                    final int priorityLevel = projectController.completedTasks[i]['priorityLevel'];
                                                                                    final String status = projectController.completedTasks[i]['status'];
                                                                                    return listOfTasks(context, 'completed', taskTitle, phase, taskDescription, pilot, copilot, priorityLevel, status, startDate, endDate);
                                                                                  },
                                                                                ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ));
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          constraints.maxWidth < 1500
                              ? Container()
                              : Expanded(
                                  flex: 2,
                                  child: GetBuilder<ProfileController>(
                                      init: ProfileController(),
                                      builder: (controller) {
                                        if (controller.user.isEmpty) {
                                          return const LoadingIndicator();
                                        } else {
                                          return Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white,
                                                  offset: Offset(0, 3.0),
                                                  blurRadius: 9.0,
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding: constraints.maxWidth <
                                                      800
                                                  ? const EdgeInsets.all(16.0)
                                                  : const EdgeInsets.fromLTRB(
                                                      50, 30, 30, 80),
                                              child: Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      _scrollController.animateTo(
                                                          _scrollController
                                                              .position
                                                              .maxScrollExtent,
                                                          duration:
                                                              const Duration(
                                                                  seconds: 2),
                                                          curve:
                                                              Curves.easeOut);
                                                    },
                                                    child: txt(
                                                      txt: 'NOTES',
                                                      fontSize: 50,
                                                      font: 'comfortaa',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      minFontSize:
                                                          constraints.maxWidth <
                                                                  800
                                                              ? 24
                                                              : 40,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 5,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        screenHeight(context) *
                                                            0.03,
                                                  ),
                                                  Obx(() {
                                                    return SizedBox(
                                                        height: screenHeight(
                                                                context) *
                                                            0.55,
                                                        width:
                                                            screenWidth(context) *
                                                                0.3,
                                                        child:
                                                            projectController
                                                                            .progress
                                                                            .value !=
                                                                        100 &&
                                                                    projectController
                                                                            .progress
                                                                            .value !=
                                                                        0.0
                                                                ? Stack(
                                                                    children: [
                                                                      Positioned
                                                                          .fill(
                                                                              child: Opacity(
                                                                        opacity:
                                                                            0.5,
                                                                        child: Container(
                                                                            color:
                                                                                Colors.white),
                                                                      )),
                                                                      Align(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 200,
                                                                              width: 300,
                                                                              child: LiquidCircularProgressIndicator(
                                                                                value: projectController.progress.value / 100,
                                                                                valueColor: const AlwaysStoppedAnimation(Color(secondaryColor)),
                                                                                backgroundColor: Colors.white,
                                                                                direction: Axis.vertical,
                                                                                center: Text(
                                                                                  "${projectController.progress.value.ceil()}%",
                                                                                  style: GoogleFonts.poppins(color: Colors.black, fontSize: 18),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: txt(txt: 'Please wait\n File is being uploaded', fontSize: 14),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : projectController
                                                                        .comments
                                                                        .isEmpty
                                                                    ? Center(
                                                                        child: txt(
                                                                            txt:
                                                                                'Add comments here',
                                                                            fontSize:
                                                                                14),
                                                                      )
                                                                    : ListView.builder(
                                                                        controller: _scrollController,
                                                                        itemCount: projectController.comments.length,
                                                                        itemBuilder: (context, i) {
                                                                          String
                                                                              comment =
                                                                              projectController.comments[i]['comment'].toString();
                                                                          String
                                                                              type =
                                                                              projectController.comments[i]['type'].toString();
                                                                          String
                                                                              username =
                                                                              projectController.comments[i]['username'].toString();
                                                                          String
                                                                              firstChar =
                                                                              '';

                                                                          for (int i = 0;
                                                                              i < username.length;
                                                                              i++) {
                                                                            firstChar +=
                                                                                username[i];
                                                                          }

                                                                          return usersMsg(
                                                                              context,
                                                                              username: username,
                                                                              nameFirstChar: firstChar[0],
                                                                              type: type,
                                                                              comment: comment);
                                                                        }));
                                                  }),
                                                  const Spacer(),
                                                  Container(
                                                    width:
                                                        screenWidth(context) *
                                                            0.2,
                                                    height:
                                                        screenHeight(context) *
                                                            0.2,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.16),
                                                          offset: const Offset(
                                                              0, 3.0),
                                                          blurRadius: 6.0,
                                                        ),
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 15,
                                                              right: 15,
                                                              top: 5),
                                                      child: TextFormField(
                                                        maxLines: null,
                                                        controller:
                                                            commentController,
                                                        decoration:
                                                            InputDecoration(
                                                          suffixIcon: SizedBox(
                                                            width: 50,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Builder(builder:
                                                                    (context) {
                                                                  return InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      await projectController
                                                                          .addNewCommentFile(
                                                                        username:
                                                                            profileController.user['name'],
                                                                      );

                                                                      WidgetsBinding
                                                                          .instance
                                                                          .addPostFrameCallback(
                                                                              (_) {
                                                                        if (_scrollController
                                                                            .hasClients) {
                                                                          _scrollController.animateTo(
                                                                              _scrollController.position.maxScrollExtent,
                                                                              duration: const Duration(milliseconds: 300),
                                                                              curve: Curves.easeOut);
                                                                        }
                                                                      });
                                                                    },
                                                                    child: const Icon(
                                                                        Icons
                                                                            .attach_file,
                                                                        color: Color(
                                                                            brownishColor)),
                                                                  );
                                                                }),
                                                                InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    await projectController
                                                                        .addNewComment(
                                                                      comment:
                                                                          commentController
                                                                              .text,
                                                                      username:
                                                                          profileController
                                                                              .user['name'],
                                                                    );
                                                                    commentController
                                                                        .clear();

                                                                    WidgetsBinding
                                                                        .instance
                                                                        .addPostFrameCallback(
                                                                            (_) {
                                                                      if (_scrollController
                                                                          .hasClients) {
                                                                        _scrollController.animateTo(
                                                                            _scrollController
                                                                                .position.maxScrollExtent,
                                                                            duration:
                                                                                const Duration(milliseconds: 300),
                                                                            curve: Curves.easeOut);
                                                                      }
                                                                    });
                                                                  },
                                                                  child: const Icon(
                                                                      Icons
                                                                          .send,
                                                                      color: Color(
                                                                          brownishColor)),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          border:
                                                              InputBorder.none,
                                                          hintText:
                                                              'Add Comment...',
                                                          hintStyle: GoogleFonts
                                                              .montserrat(
                                                            textStyle:
                                                                const TextStyle(
                                                              overflow:
                                                                  TextOverflow
                                                                      .visible,
                                                              letterSpacing: 0,
                                                              color: Color(
                                                                  brownishColor),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                      }),
                                )
                        ],
                      ),
                    ));
              });
            }
          });
    });
  }

  Container statusContainer(BuildContext context, String title) {
    return Container(
      // width: screenWidth(context) * 0.15,
      height: screenHeight(context) * 0.03,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: const Color(secondaryColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            offset: const Offset(0, 3.0),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Center(
        child: txt(
            txt: title,
            font: 'comfortaa',
            fontWeight: FontWeight.bold,
            fontColor: Colors.white,
            fontSize: 18),
      ),
    );
  }

  Container listOfTasks(
      BuildContext context,
      String? board,
      String taskTitle,
      String phase,
      String taskDescription,
      String pilot,
      String copilot,
      int priorityLevel,
      String status,
      String startDate,
      String endDate) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.2),
              blurRadius: 10,
            )
          ]),
      child: Column(
        children: [
          Container(
              height: screenHeight(context) * 0.008,
              decoration: BoxDecoration(
                color: board == 'todo'
                    ? Colors.grey.shade500
                    : board == 'inProgress'
                        ? Colors.yellow.shade600
                        : Colors.greenAccent,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              )),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: txt(
                          txt: 'Title:',
                          maxLines: 1,
                          fontColor: Colors.black,
                          fontSize: 16),
                    ),
                    Expanded(
                        flex: 3,
                        child:
                            txt(txt: taskTitle, maxLines: 1000, fontSize: 16)),
                    // const Spacer(),
                    PopupMenuButton(
                        onSelected: (value) async {
                          if (value == 1) {
                            status == 'todo'
                                ? projectController.addToInProgress(
                                    copilot: copilot,
                                    endDate: endDate,
                                    phase: phase,
                                    pilot: pilot,
                                    priorityLevel: priorityLevel,
                                    startDate: startDate,
                                    status: status,
                                    taskDescription: taskDescription,
                                    taskTitle: taskTitle)
                                : status == 'inProgress'
                                    ? projectController.addToTodo(
                                        copilot: copilot,
                                        endDate: endDate,
                                        phase: phase,
                                        pilot: pilot,
                                        priorityLevel: priorityLevel,
                                        startDate: startDate,
                                        status: status,
                                        taskDescription: taskDescription,
                                        taskTitle: taskTitle)
                                    : projectController.addToTodo(
                                        copilot: copilot,
                                        endDate: endDate,
                                        phase: phase,
                                        pilot: pilot,
                                        priorityLevel: priorityLevel,
                                        startDate: startDate,
                                        status: status,
                                        taskDescription: taskDescription,
                                        taskTitle: taskTitle);
                          } else if (value == 2) {
                            status == 'todo'
                                ? projectController.addToCompleted(
                                    copilot: copilot,
                                    endDate: endDate,
                                    phase: phase,
                                    pilot: pilot,
                                    priorityLevel: priorityLevel,
                                    startDate: startDate,
                                    status: status,
                                    taskDescription: taskDescription,
                                    taskTitle: taskTitle)
                                : status == 'inProgress'
                                    ? projectController.addToCompleted(
                                        copilot: copilot,
                                        endDate: endDate,
                                        phase: phase,
                                        pilot: pilot,
                                        priorityLevel: priorityLevel,
                                        startDate: startDate,
                                        status: status,
                                        taskDescription: taskDescription,
                                        taskTitle: taskTitle)
                                    : projectController.addToInProgress(
                                        copilot: copilot,
                                        endDate: endDate,
                                        phase: phase,
                                        pilot: pilot,
                                        priorityLevel: priorityLevel,
                                        startDate: startDate,
                                        status: status,
                                        taskDescription: taskDescription,
                                        taskTitle: taskTitle);
                          } else if (value == 3) {
                            Get.to(UpdateTask(
                              projectId: widget.projectId,
                              copilot: copilot,
                              endDate: endDate,
                              phase: phase,
                              pilot: pilot,
                              priorityLevel: priorityLevel,
                              startDate: startDate,
                              status: status,
                              taskDescription: taskDescription,
                              taskTitle: taskTitle,
                            ));
                          } else {
                            projectController.deleteProjectTask(
                                status: status,
                                taskDescription: taskDescription,
                                taskTitle: taskTitle);
                          }
                        },
                        elevation: 3.2,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                child: Text(
                                  status == 'todo'
                                      ? 'Add to Inprogress'
                                      : status == 'inProgress'
                                          ? 'Add to Todo'
                                          : 'Add to Todo',
                                  maxLines: 1,
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      overflow: TextOverflow.visible,
                                      color: Color(brownishColor),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: Text(
                                  status == 'todo'
                                      ? 'Add to Completed'
                                      : status == 'inProgress'
                                          ? 'Add to Completed'
                                          : 'Add to Inprogress',
                                  maxLines: 1,
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      overflow: TextOverflow.visible,
                                      color: Color(brownishColor),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                value: 3,
                                child: Text(
                                  'Edit',
                                  maxLines: 1,
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      overflow: TextOverflow.visible,
                                      color: Color(brownishColor),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                value: 4,
                                child: Text(
                                  'Delete',
                                  maxLines: 1,
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      overflow: TextOverflow.visible,
                                      color: Color(brownishColor),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                        child: const Icon(Icons.edit,
                            color: Color(
                              secondaryColor,
                            ),
                            size: 18))
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: txt(
                          txt: 'Phase:',
                          maxLines: 1,
                          fontColor: Colors.black,
                          fontSize: 16),
                    ),
                    Expanded(
                        flex: 3,
                        child: txt(txt: phase, maxLines: 1000, fontSize: 16)),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: txt(
                          txt: 'Description:',
                          maxLines: 1,
                          fontColor: Colors.black,
                          fontSize: 16),
                    ),
                    Expanded(
                        flex: 3,
                        child: txt(
                            txt: taskDescription,
                            maxLines: 1000,
                            fontSize: 16)),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: txt(
                          txt: 'Pilot:',
                          maxLines: 1,
                          fontColor: Colors.black,
                          fontSize: 16),
                    ),
                    Expanded(
                        flex: 3,
                        child: txt(txt: pilot, maxLines: 1000, fontSize: 16)),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: txt(
                          txt: 'Co-pilot:',
                          maxLines: 1,
                          fontColor: Colors.black,
                          fontSize: 16),
                    ),
                    Expanded(
                        flex: 3,
                        child: txt(txt: copilot, maxLines: 1000, fontSize: 16)),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: txt(
                          txt: 'Start Date:',
                          maxLines: 1,
                          fontColor: Colors.black,
                          fontSize: 16),
                    ),
                    Expanded(
                        flex: 3,
                        child:
                            txt(txt: startDate, maxLines: 1000, fontSize: 16)),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: txt(
                          txt: 'End Date:',
                          maxLines: 1,
                          fontColor: Colors.black,
                          fontSize: 16),
                    ),
                    Expanded(
                        flex: 3,
                        child: txt(txt: endDate, maxLines: 1000, fontSize: 16)),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: txt(
                          maxLines: 1,
                          txt: 'Priority Level:',
                          fontColor: Colors.black,
                          fontSize: 16),
                    ),
                    Expanded(
                        flex: 3,
                        child: txt(txt: 'High', maxLines: 1000, fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding usersMsg(BuildContext context,
      {String? comment,
      String? type,
      String? username,
      String? nameFirstChar}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: const Color(brownishColor),
            maxRadius: 25,
            child: Center(
              child: txt(
                  txt: nameFirstChar!.capitalize.toString(),
                  fontSize: 20,
                  fontColor: Colors.white),
            ),
          ),
          SizedBox(
            width: screenWidth(context) * 0.005,
          ),
          // txt(
          //   txt: '@${username!}:',
          //   fontSize: 12,
          //   maxLines: 1,
          // ),
          type == 'text'
              ? Flexible(
                  child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: '@${username!}:\n',
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                                overflow: TextOverflow.visible,
                                color: Color(brownishColor),
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                          )),
                      TextSpan(
                          text: comment!,
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                                overflow: TextOverflow.visible,
                                color: Color(brownishColor),
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          )),
                    ],
                  ),
                ))
              : InkWell(
                  onTap: () {
                    downloadFile(comment);
                  },
                  child: screenWidth(context) < 1800
                      ? Container(
                          width: screenWidth(context) * 0.1,
                          height: screenHeight(context) * 0.05,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: const Color(secondaryColor),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.16),
                                offset: const Offset(0, 3.0),
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: Center(
                            child: txt(
                                txt: 'Download file',
                                fontSize: 14,
                                fontColor: Colors.white),
                          ),
                        )
                      : Container(
                          width: screenWidth(context) * 0.1,
                          height: screenHeight(context) * 0.05,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: const Color(secondaryColor),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.16),
                                offset: const Offset(0, 3.0),
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.download,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: screenWidth(context) * 0.005,
                                ),
                                txt(
                                    txt: 'click to download',
                                    fontSize: 14,
                                    fontColor: Colors.white),
                              ],
                            ),
                          ),
                        ),
                )
        ],
      ),
    );
  }

  Container taskBox() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.23),
            offset: const Offset(0, 3.0),
            blurRadius: 9.0,
          ),
        ],
      ),
    );
  }

  downloadFile(url) async {
//    Uri uri = Uri.parse(url);

// Uint8List bytes = await readBytes(uri);
// Uint8List imgbytes = await url. readAsBytes();
// await FileSaver.instance.saveFile(filename, bytes, 'jpg',
//     mimeType: MimeType.JPEG); /

//     final File file = File(url);
//     final filename = basename(file.path);
//     final exxtension = extension(file.path);
//     print(bytes);
//     print(filename);
//     print(exxtension);
//     await FileSaver.instance.saveFile(filename, bytes, exxtension);
//     print('success');

    // html.AnchorElement anchorElement = html.AnchorElement(href: url);
    // anchorElement.click();
  }
}
