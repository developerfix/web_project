import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:projectx/constants/style.dart';
import 'package:projectx/pages/project_dashboard.dart';
import 'package:projectx/pages/see_all_projs.dart';
import 'package:projectx/pages/upload.dart';
import 'package:projectx/widgets/loading_indicator.dart';

import '../controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';
import '../widgets/create_project_popup.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_drawer.dart';

class RecentProjects extends StatefulWidget {
  const RecentProjects({Key? key}) : super(key: key);

  @override
  State<RecentProjects> createState() => _RecentProjectsState();
}

class _RecentProjectsState extends State<RecentProjects> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  final ProfileController profileController = Get.put(ProfileController());
  final _uid = AuthController.instance.user!.uid;

  @override
  void initState() {
    super.initState();

    profileController.updateUserId(_uid);
  }

  itemCount(int length) {
    if (length >= 5) {
      if (screenWidth(context) > 2200) {
        return 5;
      } else if (screenWidth(context) > 1800) {
        return 4;
      } else if (screenWidth(context) > 1200) {
        return 3;
      } else if (screenWidth(context) > 800) {
        return 2;
      } else if (screenWidth(context) > 600) {
        return 1;
      } else {
        return 0;
      }
    } else if (length >= 4) {
      if (screenWidth(context) > 1500) {
        return 4;
      } else if (screenWidth(context) > 1200) {
        return 3;
      } else if (screenWidth(context) > 800) {
        return 2;
      } else if (screenWidth(context) > 600) {
        return 1;
      } else {
        return 0;
      }
    } else if (length >= 3) {
      if (screenWidth(context) > 1500) {
        return 3;
      } else if (screenWidth(context) > 800) {
        return 2;
      } else if (screenWidth(context) > 600) {
        return 1;
      } else {
        return 1;
      }
    } else if (length >= 2) {
      if (screenWidth(context) > 800) {
        return 2;
      } else if (screenWidth(context) > 600) {
        return 1;
      } else {
        return 0;
      }
    } else if (length == 1) {
      if (screenWidth(context) > 600) {
        return 1;
      } else {
        return 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Form(
          key: _formKey,
          child: Obx(() {
            return Scaffold(
              key: _key,
              drawerEnableOpenDragGesture: false,
              appBar: customAppBar(context,
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
                                  'Click below to make your first project with Ava',
                              fontSize: 24,
                              fontColor: Colors.white)
                          : Column(
                              children: [
                                txt(
                                    txt: 'PROJECTS',
                                    fontSize:
                                        constraints.maxWidth < 800 ? 50 : 100,
                                    letterSpacing: 8.0,
                                    fontColor: Colors.white),
                                SizedBox(
                                  height: screenHeight(context) * 0.03,
                                ),
                                SizedBox(
                                  height: screenHeight(context) * 0.2,
                                  width: screenWidth(context) * 0.9,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: screenWidth(context) < 600
                                            ? 0
                                            : screenWidth(context) * 0.55,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: itemCount(
                                                profileController
                                                    .projects.length),
                                            itemBuilder: (context, i) {
                                              String projectTitle =
                                                  profileController.projects[i]
                                                      ['title'];
                                              String projectId =
                                                  profileController.projects[i]
                                                      ['projectId'];
                                              return InkWell(
                                                  onTap: (() {
                                                    Get.to(UplaodPage());
                                                    // Get.to(ProjectDashboard(
                                                    //   projectId: projectId,
                                                    // ));
                                                  }),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: recentProjectBox(
                                                        text: projectTitle),
                                                  ));
                                            }),
                                      ),
                                      profileController.projects.length > 5
                                          ? InkWell(
                                              onTap: (() {
                                                Get.to(const SeeAllProjects());
                                              }),
                                              child: Container(
                                                width: 230,
                                                height: screenHeight(context) *
                                                    0.18,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  color: const Color(
                                                          secondaryColor)
                                                      .withOpacity(0.5),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.23),
                                                      offset:
                                                          const Offset(0, 3.0),
                                                      blurRadius: 9.0,
                                                    ),
                                                  ],
                                                ),
                                                child: Center(
                                                    child: txt(
                                                        txt: 'See all',
                                                        fontSize: 30.0,
                                                        letterSpacing: 2,
                                                        fontColor:
                                                            Colors.white)),
                                              ),
                                            )
                                          : Container()
                                    ],
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
                          createProjectPopUp(context);
                        },
                        child: Row(
                          children: [
                            txt(
                                txt: 'Create New Project',
                                fontSize: 30.0,
                                fontColor: Colors.white,
                                letterSpacing: 2),
                            SizedBox(
                              width: screenWidth(context) * 0.003,
                            ),
                            SvgPicture.asset(
                              'assets/svgs/plus.svg',
                              color: Colors.white,
                            )
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

  Container recentProjectBox({String? text}) {
    return Container(
      width: 230,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: const Color(secondaryColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.23),
            offset: const Offset(0, 3.0),
            blurRadius: 9.0,
          ),
        ],
      ),
      child: Center(
          child: txt(
              txt: text!,
              fontSize: 30.0,
              maxLines: 1,
              minFontSize: 24,
              letterSpacing: 2,
              overflow: TextOverflow.ellipsis,
              fontColor: Colors.white)),
    );
  }
}
