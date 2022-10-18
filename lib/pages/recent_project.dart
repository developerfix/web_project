import 'package:ava/controllers/project_controller.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ava/constants/style.dart';
import 'package:ava/pages/project_dashboard.dart' as dashboard;
import 'package:ava/widgets/loading_indicator.dart';

import '../controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';
import '../widgets/create_project_popup.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/project_box.dart';

class RecentProjects extends StatefulWidget {
  const RecentProjects({Key? key}) : super(key: key);

  @override
  State<RecentProjects> createState() => _RecentProjectsState();
}

class _RecentProjectsState extends State<RecentProjects> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  final ProfileController profileController = Get.put(ProfileController());
  final ProjectController projectController = Get.put(ProjectController());
  final _uid = AuthController.instance.user!.uid;
  final ScrollController _scrollController = ScrollController();
  List tempList = [];
  List projectsCategoriesList = [];
  List projectsListCount = [];
  // bool isAtTop = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileController.updateUserData(_uid);
      projectController.updateUsers(uid: _uid);
      // executes after build
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Form(
          key: _formKey,
          child: Obx(() {
            for (var project in profileController.projects) {
              tempList.add(project['category']);
            }
            projectsCategoriesList = tempList.toSet().toList();

            return Scaffold(
              key: _key,
              drawerEnableOpenDragGesture: false,
              appBar: customAppBar(context,
                  isNeedAppbar: false,
                  username: profileController.user['name']),
              endDrawer: const EndDrawerWidget(),
              backgroundColor: const Color(mainColor),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  profileController.isFetchingProjects.isTrue
                      ? const LoadingIndicator(
                          color: Colors.white,
                        )
                      : profileController.projects.isEmpty
                          ? txt(
                              txt:
                                  'Click below to make your first project with ava',
                              fontSize: 24,
                              fontColor: Colors.white)
                          : Column(
                              children: [
                                txt(
                                    txt: 'PROJECTS',
                                    font: 'comfortaa',
                                    fontSize:
                                        constraints.maxWidth < 800 ? 50 : 100,
                                    letterSpacing: 8.0,
                                    fontColor: Colors.white),
                                SizedBox(
                                  height: screenHeight(context) * 0.05,
                                ),
                                NotificationListener<ScrollNotification>(
                                  onNotification: (notification) {
                                    final metrices = notification.metrics;
                                    if (metrices.pixels != 0) {
                                      projectController
                                          .isRecentProjectsListAtTop
                                          .value = false;
                                      projectController.update();
                                      // });
                                    } else {
                                      projectController
                                          .isRecentProjectsListAtTop
                                          .value = true;
                                      projectController.update();
                                    }

                                    return false;
                                  },
                                  child: AnimatedSize(
                                    duration: const Duration(seconds: 1),
                                    curve: Curves.easeInOut,
                                    child: SizedBox(
                                      height:
                                          // projectController
                                          //         .isRecentProjectsListAtTop.value
                                          //     ? screenHeight(context) * 0.5
                                          // :
                                          screenHeight(context) * 0.5,
                                      width: screenWidth(context) * 0.75,
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
                                        child:
                                            FadingEdgeScrollView.fromScrollView(
                                          child: ListView.separated(
                                              controller: _scrollController,
                                              separatorBuilder:
                                                  (context, index) {
                                                return const SizedBox(
                                                  height: 24,
                                                );
                                              },
                                              scrollDirection: Axis.vertical,
                                              itemCount:
                                                  projectsCategoriesList.length,
                                              itemBuilder: (context, i) {
                                                projectsListCount.clear();
                                                for (var project
                                                    in profileController
                                                        .projects) {
                                                  if (project['category'] ==
                                                      projectsCategoriesList[
                                                          i]) {
                                                    projectsListCount
                                                        .add(project);
                                                  }
                                                }
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 0,
                                                          top: 0,
                                                          bottom: 10,
                                                          right: 100),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: txt(
                                                              txt: projectsCategoriesList[
                                                                      i]
                                                                  .toString()
                                                                  .toUpperCase(),
                                                              fontColor:
                                                                  Colors.white,
                                                              fontSize: 24),
                                                        ),
                                                        GridView.builder(
                                                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                                                maxCrossAxisExtent:
                                                                    250,
                                                                crossAxisSpacing:
                                                                    20,
                                                                mainAxisSpacing:
                                                                    20),
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                projectsListCount
                                                                    .length,
                                                            itemBuilder:
                                                                (context, i) {
                                                              String
                                                                  projectTitle =
                                                                  projectsListCount[
                                                                          i]
                                                                      ['title'];
                                                              String projectId =
                                                                  projectsListCount[
                                                                          i][
                                                                      'projectId'];
                                                              return InkWell(
                                                                onTap: (() {
                                                                  Get.to(() =>
                                                                      dashboard
                                                                          .ProjectDashboard(
                                                                        projectId:
                                                                            projectId,
                                                                      ));
                                                                }),
                                                                child: projectBox(
                                                                    context,
                                                                    text:
                                                                        projectTitle),
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
                              ],
                            ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          projecttController.projectPilot.value = '';
                          projecttController.projectCoPilot.value = '';
                          projectController.phaseValue.value = '3D Design';
                          createProjectPopUp(context, uid: _uid);
                        },
                        child: Row(
                          children: [
                            txt(
                                txt: 'Create New Project',
                                fontSize: 40.0,
                                font: 'Comfortaa',
                                fontColor: Colors.white,
                                letterSpacing: 2),
                            SizedBox(
                              width: screenWidth(context) * 0.003,
                            ),
                            const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 50,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight(context) * 0.05,
                  ),
                ],
              ),
            );
          }));
    });
  }
}
