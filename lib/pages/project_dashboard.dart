import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:projectx/widgets/edit_task_popup.dart';
import 'package:universal_html/html.dart' as html;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:projectx/constants/style.dart';
import 'package:projectx/controllers/auth_controller.dart';
import 'package:projectx/controllers/profile_controller.dart';
import 'package:projectx/controllers/project_controller.dart';
import 'package:projectx/pages/project_members.dart';
import 'package:projectx/pages/recent_project.dart';
import 'package:projectx/pages/timeline.dart';
import 'package:projectx/widgets/asset_popup.dart';
import 'package:projectx/widgets/loading_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/add_new_task_popup.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/listOfTasks.dart';
import '../widgets/usersmsg.dart';

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
  bool showBorder = false;

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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                txt(
                                  txt: "ASSETS",
                                  font: 'comfortaa',
                                  fontSize: 30.0,
                                  fontColor: const Color(brownishColor),
                                  letterSpacing: 5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            ),
                          ),
                          Obx(() {
                            return SizedBox(
                              height: screenHeight(context) * 0.6,
                              width: screenWidth(context) * 0.12,
                              child: projectController.assets.isEmpty
                                  ? Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            addAssetPopUp(context);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Icon(
                                                Icons.add,
                                                color: Color(brownishColor),
                                                size: 50,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : ListView.builder(
                                      itemCount:
                                          projectController.assets.length,
                                      itemBuilder: (context, i) {
                                        String path =
                                            projectController.assets[i]['path'];
                                        String pathName = projectController
                                            .assets[i]['pathName'];
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
                                                        txt: pathName,
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
                                                onTap: () async {
                                                  await canLaunchUrl(
                                                          Uri.parse(path))
                                                      ? await launchUrl(
                                                          Uri.parse(path))
                                                      : null;
                                                },
                                              );
                                      }),
                            );
                          }),
                          const Spacer(),
                          ListTile(
                              onTap: () {
                                Get.to(addNewTaskPopUp(context));
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
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          Get.to(const RecentProjects());
                                        });
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
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              txt(
                                                txt: "ASSETS",
                                                font: 'comfortaa',
                                                fontSize: 30.0,
                                                fontColor:
                                                    const Color(brownishColor),
                                                letterSpacing: 5,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Obx(() {
                                        return Column(
                                          children: [
                                            SizedBox(
                                              height:
                                                  screenHeight(context) * 0.65,
                                              width:
                                                  screenWidth(context) * 0.12,
                                              child: ListView.builder(
                                                  itemCount: projectController
                                                      .assets.length,
                                                  itemBuilder: (context, i) {
                                                    String path =
                                                        projectController
                                                            .assets[i]['path'];
                                                    String pathName =
                                                        projectController
                                                                .assets[i]
                                                            ['pathName'];
                                                    return InkWell(
                                                        onTap: () async {
                                                          await canLaunchUrl(
                                                                  Uri.parse(
                                                                      path))
                                                              ? await launchUrl(
                                                                  Uri.parse(
                                                                      path))
                                                              : null;
                                                        },
                                                        onHover: (hovered) {
                                                          setState(() {
                                                            showBorder =
                                                                hovered;
                                                          });
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              const Icon(
                                                                Icons.link,
                                                                color: Color(
                                                                    secondaryColor),
                                                              ),
                                                              txt(
                                                                  txt: pathName,
                                                                  fontSize: 14,
                                                                  fontColor:
                                                                      const Color(
                                                                          secondaryColor),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis),
                                                              showBorder
                                                                  ? PopupMenuButton(
                                                                      onSelected:
                                                                          (value) async {
                                                                        // if (value ==
                                                                        //     1) {
                                                                        // } else if (value ==
                                                                        //     2) {
                                                                        print(
                                                                            'pressed');
                                                                        setState(
                                                                            () {
                                                                          isAssetsRefreshing =
                                                                              true;
                                                                        });
                                                                        await projectController.deleteProjectAsset(
                                                                            path:
                                                                                projectController.assets[i]['path']);
                                                                        setState(
                                                                            () {
                                                                          isAssetsRefreshing =
                                                                              false;
                                                                        });
                                                                        // }
                                                                      },
                                                                      elevation:
                                                                          3.2,
                                                                      shape:
                                                                          const RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(8.0)),
                                                                      ),
                                                                      itemBuilder:
                                                                          (context) =>
                                                                              [
                                                                                PopupMenuItem(
                                                                                  value: 1,
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
                                                                                  value: 2,
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
                                                                      child: const Icon(
                                                                          Icons
                                                                              .more_horiz,
                                                                          color:
                                                                              Color(
                                                                            secondaryColor,
                                                                          ),
                                                                          size:
                                                                              18))
                                                                  : Container(),
                                                            ],
                                                          ),
                                                        ));
                                                  }),
                                            ),
                                            // Spacer(),
                                            InkWell(
                                              onTap: () {
                                                addAssetPopUp(context);
                                              },
                                              child: Center(
                                                child: Icon(
                                                  Icons.add,
                                                  color: Color(brownishColor),
                                                  size: 50,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                      const Spacer(),
                                      ListTile(
                                          onTap: () {
                                            Get.to(addNewTaskPopUp(context));
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
                                                                                    return listOfTasks(context, projectController, 'todo', taskTitle, phase, taskDescription, pilot, copilot, priorityLevel, status, startDate, endDate);
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
                                                                                  return listOfTasks(context, projectController, 'inProgress', taskTitle, phase, taskDescription, pilot, copilot, priorityLevel, status, startDate, endDate);
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
                                                                                    return listOfTasks(context, projectController, 'completed', taskTitle, phase, taskDescription, pilot, copilot, priorityLevel, status, startDate, endDate);
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
                                                                                    return listOfTasks(context, projectController, 'todo', taskTitle, phase, taskDescription, pilot, copilot, priorityLevel, status, startDate, endDate);
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
                                                                                  return listOfTasks(context, projectController, 'inProgress', taskTitle, phase, taskDescription, pilot, copilot, priorityLevel, status, startDate, endDate);
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
                                                                                    return listOfTasks(context, projectController, 'completed', taskTitle, phase, taskDescription, pilot, copilot, priorityLevel, status, startDate, endDate);
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
                                                        child: projectController
                                                                .isCommentFileUpdatingBefore
                                                                .isTrue
                                                            ? Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  const LoadingIndicator(),
                                                                  txt(
                                                                      txt:
                                                                          'Please wait\n File is being uploaded',
                                                                      fontSize:
                                                                          14)
                                                                ],
                                                              )
                                                            : projectController
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
                                                                        .isCommentFileUpdatingAfter
                                                                        .isTrue
                                                                    ? Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          const LoadingIndicator(),
                                                                          txt(
                                                                              txt: 'Uploading, Almost finished',
                                                                              fontSize: 14)
                                                                        ],
                                                                      )
                                                                    : projectController
                                                                            .comments
                                                                            .isEmpty
                                                                        ? Center(
                                                                            child:
                                                                                txt(txt: 'Add comments here', fontSize: 14),
                                                                          )
                                                                        : ListView.builder(
                                                                            controller: _scrollController,
                                                                            itemCount: projectController.comments.length,
                                                                            itemBuilder: (context, i) {
                                                                              String comment = projectController.comments[i]['comment'].toString();
                                                                              String type = projectController.comments[i]['type'].toString();
                                                                              String username = projectController.comments[i]['username'].toString();
                                                                              String filename = projectController.comments[i]['filename'].toString();
                                                                              var created = !kIsWeb ? projectController.comments[i]['created'] : (projectController.comments[i]['created'] as Timestamp).toDate();

                                                                              String firstChar = '';

                                                                              for (int i = 0; i < username.length; i++) {
                                                                                firstChar += username[i];
                                                                              }

                                                                              return usersMsg(context, created: created, username: username, filename: filename, nameFirstChar: firstChar[0], type: type, comment: comment);
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
                                                                      await projectController.addNewCommentFile(
                                                                          username: profileController.user[
                                                                              'name'],
                                                                          created: !kIsWeb
                                                                              ? DateTime.now()
                                                                              : Timestamp.now());

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
                                                                    if (commentController
                                                                        .text
                                                                        .isNotEmpty) {
                                                                      await projectController.addNewComment(
                                                                          comment: commentController
                                                                              .text,
                                                                          username: profileController.user[
                                                                              'name'],
                                                                          created: !kIsWeb
                                                                              ? DateTime.now()
                                                                              : Timestamp.now());
                                                                      commentController
                                                                          .clear();

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
                                                                    }
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
}
