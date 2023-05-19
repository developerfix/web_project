import 'package:ava/controllers/department_controller.dart';
import 'package:ava/controllers/project_controller.dart';
import 'package:ava/models/project.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ava/constants/style.dart';
import 'package:ava/widgets/loading_indicator.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';
import '../widgets/create_project_popup.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/left_side_icons.dart';
import '../widgets/plus_icon_widget.dart';
import '../widgets/project_box.dart';

class ProjectsGrid extends StatefulWidget {
  final String departmentId;
  const ProjectsGrid({Key? key, required this.departmentId}) : super(key: key);

  @override
  State<ProjectsGrid> createState() => _ProjectsGridState();
}

class _ProjectsGridState extends State<ProjectsGrid> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  final ProfileController profileController = Get.find<ProfileController>();
  final DepartmentController departmentController =
      Get.find<DepartmentController>();
  final ProjectController projectController = Get.find<ProjectController>();
  final _uid = AuthController.instance.user!.uid;
  final ScrollController _scrollController = ScrollController();
  List tempList = [];
  List projectsCategoriesList = [];
  List<Project> projectsListCount = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileController.getDepartmentProjects(widget.departmentId);
      departmentController.getDepartmentInfo(_uid, widget.departmentId);
      projectController.getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Form(
          key: _formKey,
          child: Obx(() {
            for (var project in profileController.departmentProjects) {
              tempList.add(project.category);
            }
            projectsCategoriesList = tempList.toSet().toList();
            projectsCategoriesList
                .sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

            return Scaffold(
              key: _key,
              drawerEnableOpenDragGesture: false,
              appBar: customAppBar(
                context,
                isNeedAppbar: false,
                pageName:
                    departmentController.currentDepartment.value.title ?? '',
              ),
              endDrawer: const EndDrawerWidget(),
              backgroundColor: const Color(mainColor),
              body: Row(
                children: [
                  leftSideIcons(context, isProjectsScreen: true),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                departmentController
                                            .currentDepartment.value.iconCode !=
                                        null
                                    ? SizedBox(
                                        width: 75,
                                        height: 75,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2)),
                                          child: Icon(
                                            color: Colors.white,
                                            IconData(
                                                departmentController
                                                    .currentDepartment
                                                    .value
                                                    .iconCode!,
                                                fontFamily: 'MaterialIcons'),
                                            size: 40,
                                          ),
                                        ),
                                      )
                                    : Container(),
                                const SizedBox(
                                  width: 20,
                                ),
                                txt(
                                    txt:
                                        departmentController.currentDepartment
                                                    .value.title !=
                                                null
                                            ? departmentController
                                                .currentDepartment.value.title!
                                                .toUpperCase()
                                            : ''.toUpperCase(),
                                    font: 'comfortaa',
                                    textAlign: TextAlign.center,
                                    fontSize:
                                        constraints.maxWidth < 800 ? 40 : 80,
                                    letterSpacing: 8.0,
                                    fontColor: Colors.white),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight(context) * 0.03,
                            ),
                            profileController.departmentProjects.isEmpty
                                ? Container()
                                : searchProjectsWidget(context),
                            profileController.isFetchingProjects.isTrue
                                ? SizedBox(
                                    height: screenHeight(context) * 0.5,
                                    width: screenWidth(context) * 0.7,
                                    child: const LoadingIndicator(
                                      color: Colors.white,
                                    ))
                                : profileController.departmentProjects.isEmpty
                                    ? SizedBox(
                                        height: screenHeight(context) * 0.5,
                                        width: screenWidth(context) * 0.7,
                                        child: Center(
                                          child: txt(
                                              txt:
                                                  'Click below to make your first project in this department',
                                              fontSize: 24,
                                              fontColor: Colors.white),
                                        ),
                                      )
                                    : projectController.searchedProject.isEmpty
                                        ? projectTilesWidget(context)
                                        : searchedProjectTilesWidget(context)
                          ],
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            plusIconWidget(
                              context,
                              color: Colors.white,
                              ontap: () {
                                profileController.projectCategory.value =
                                    designCategory;
                                profileController.update();

                                createProjectPopUp(context, uid: _uid);
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight(context) * 0.05,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }));
    });
  }

  Padding projectTilesWidget(BuildContext context) {
    bool isHovering = false;
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          final metrices = notification.metrics;
          if (metrices.pixels != 0) {
            projectController.isRecentProjectsListAtTop.value = false;
            projectController.update();
            // });
          } else {
            projectController.isRecentProjectsListAtTop.value = true;
            projectController.update();
          }

          return false;
        },
        child: AnimatedSize(
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
          child: SizedBox(
            height: projectController.isRecentProjectsListAtTop.value
                ? screenHeight(context) * 0.5
                : screenHeight(context) * 0.6,
            width: screenWidth(context) * 0.5,
            child: RawScrollbar(
              thumbColor: Colors.white,
              thumbVisibility: true,
              trackColor: const Color(secondaryColor),
              trackRadius: const Radius.circular(50),
              thickness: 15,
              trackVisibility: true,
              interactive: true,
              controller: _scrollController,
              shape: const CircleBorder(
                side: BorderSide(
                  style: BorderStyle.none,
                ),
              ),
              child: FadingEdgeScrollView.fromScrollView(
                child: ListView.separated(
                    controller: _scrollController,
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 24,
                      );
                    },
                    scrollDirection: Axis.vertical,
                    itemCount: projectsCategoriesList.length,
                    itemBuilder: (context, i) {
                      projectsListCount.clear();
                      for (var project
                          in profileController.departmentProjects) {
                        if (project.category == projectsCategoriesList[i]) {
                          projectsListCount.add(project);
                        }
                      }
                      projectsListCount = projectsListCount.reversed.toList();

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10, right: 100),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: txt(
                                    txt: projectsCategoriesList[i]
                                        .toString()
                                        .toUpperCase(),
                                    fontColor: Colors.white,
                                    fontSize: 24),
                              ),
                              GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 200,
                                          crossAxisSpacing: 20,
                                          mainAxisSpacing: 20),
                                  shrinkWrap: true,
                                  itemCount: projectsListCount.length,
                                  itemBuilder: (context, i) {
                                    String projectTitle =
                                        projectsListCount[i].title!;
                                    String projectId =
                                        projectsListCount[i].projectId!;
                                    DateTime dateTime =
                                        projectsListCount[i].lastOpened!;
                                    return MouseRegion(
                                      onEnter: (event) {
                                        setState(() {
                                          isHovering = true;
                                        });
                                      },
                                      onExit: (event) {
                                        setState(() {
                                          isHovering = false;
                                        });
                                      },
                                      child: InkWell(
                                        onTap: (() {
                                          profileController
                                              .updateLastOpenedProject(
                                                  projectId,
                                                  widget.departmentId);
                                          projectController
                                              .updateProjectLastOpenedParameter(
                                                  projectId: projectId,
                                                  deepartmentId:
                                                      departmentController
                                                          .currentDepartment
                                                          .value
                                                          .departmentId!,
                                                  uid: _uid,
                                                  lastOpened: DateTime.now());
                                        }),
                                        child: isHovering
                                            ? hoveredProjectBox(context,
                                                text: projectTitle)
                                            : projectBox(context,
                                                dateTime: dateTime,
                                                text: projectTitle),
                                      ),
                                    );
                                  })
                            ]),
                      );
                    }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding searchedProjectTilesWidget(BuildContext context) {
    bool isHovering = false;
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          final metrices = notification.metrics;
          if (metrices.pixels != 0) {
            projectController.isRecentProjectsListAtTop.value = false;
            projectController.update();
            // });
          } else {
            projectController.isRecentProjectsListAtTop.value = true;
            projectController.update();
          }

          return false;
        },
        child: AnimatedSize(
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
          child: SizedBox(
            height: projectController.isRecentProjectsListAtTop.value
                ? screenHeight(context) * 0.5
                : screenHeight(context) * 0.6,
            width: screenWidth(context) * 0.5,
            child: RawScrollbar(
              thumbColor: Colors.white,
              thumbVisibility: true,
              trackColor: const Color(secondaryColor),
              trackRadius: const Radius.circular(50),
              thickness: 15,
              trackVisibility: true,
              interactive: true,
              controller: _scrollController,
              shape: const CircleBorder(
                side: BorderSide(
                  style: BorderStyle.none,
                ),
              ),
              child: FadingEdgeScrollView.fromScrollView(
                child: ListView.separated(
                    controller: _scrollController,
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 24,
                      );
                    },
                    scrollDirection: Axis.vertical,
                    itemCount:
                        projectController.searchedProjectsCategories.length,
                    itemBuilder: (context, i) {
                      projectController.getSearchedProjects(
                          projectController.searchedProjectsCategories[i]);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10, right: 100),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: txt(
                                    txt: projectController
                                        .searchedProjectsCategories[i]
                                        .toString()
                                        .toUpperCase(),
                                    fontColor: Colors.white,
                                    fontSize: 24),
                              ),
                              GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 200,
                                          crossAxisSpacing: 20,
                                          mainAxisSpacing: 20),
                                  shrinkWrap: true,
                                  itemCount:
                                      projectController.searchedProjects.length,
                                  itemBuilder: (context, i) {
                                    String projectTitle = projectController
                                        .searchedProjects[i].title!;
                                    String projectId = projectController
                                        .searchedProjects[i].projectId!;
                                    DateTime dateTime = projectController
                                        .searchedProjects[i].lastOpened!;

                                    return MouseRegion(
                                      onEnter: (event) {
                                        setState(() {
                                          isHovering = true;
                                        });
                                      },
                                      onExit: (event) {
                                        setState(() {
                                          isHovering = false;
                                        });
                                      },
                                      child: InkWell(
                                        onTap: (() {
                                          profileController
                                              .updateLastOpenedProject(
                                                  projectId,
                                                  widget.departmentId);
                                          projectController
                                              .updateProjectLastOpenedParameter(
                                                  projectId: projectId,
                                                  deepartmentId:
                                                      departmentController
                                                          .currentDepartment
                                                          .value
                                                          .departmentId!,
                                                  uid: _uid,
                                                  lastOpened: DateTime.now());
                                        }),
                                        child: isHovering
                                            ? hoveredProjectBox(context,
                                                text: projectTitle)
                                            : projectBox(context,
                                                dateTime: dateTime,
                                                text: projectTitle),
                                      ),
                                    );
                                  })
                            ]),
                      );
                    }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row searchProjectsWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
            width: screenWidth(context) * 0.17,
            child: TextField(
              cursorColor: Colors.white,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  projectController.isSearchingProject.value = true;
                  projectController.searchedProject.value = value;
                  projectController.getSearchedProjectsCategories();
                } else {
                  projectController.isSearchingProject.value = true;
                  projectController.searchedProject.value = '';
                }
                projectController.update();
              },
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  overflow: TextOverflow.visible,
                  letterSpacing: 2,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            )),
        SizedBox(
          height: screenHeight(context) * 0.015,
          child: InkWell(
              onTap: () {},
              child: SvgPicture.asset(
                'assets/svgs/search_icon.svg',
                color: Colors.white,
              )),
        ),
      ],
    );
  }
}
