import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:projectx/constants/style.dart';
import 'package:projectx/pages/profile.dart';
import 'package:projectx/pages/project_dashboard.dart';
import 'package:projectx/pages/see_all_projs.dart';
import 'package:projectx/widgets/loadingIndicator.dart';

import '../controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';
import '../widgets/create_project_popup.dart';
import '../widgets/customAppBar.dart';
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

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Obx(() {
          return Scaffold(
            key: _key,
            drawerEnableOpenDragGesture: false,
            appBar: customAppBar(context),
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
                                  fontSize: 100,
                                  letterSpacing: 8.0,
                                  fontColor: Colors.white),
                              SizedBox(
                                height: screenHeight(context) * 0.03,
                              ),
                              SizedBox(
                                height: screenHeight(context) * 0.2,
                                width: screenWidth(context) * 0.7,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: screenWidth(context) * 0.55,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: profileController
                                                      .projects.length >
                                                  5
                                              ? 5
                                              : profileController
                                                  .projects.length,
                                          itemBuilder: (context, i) {
                                            String projectTitle =
                                                profileController.projects[i]
                                                    ['title'];
                                            String projectId = profileController
                                                .projects[i]['projectId'];
                                            return InkWell(
                                                onTap: (() {
                                                  Get.to(ProjectDashboard(
                                                    projectId: projectId,
                                                  ));
                                                }),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
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
                                              width: screenWidth(context) * 0.1,
                                              height:
                                                  screenHeight(context) * 0.18,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                color:
                                                    const Color(secondaryColor)
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
                                                      fontColor: Colors.white)),
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
  }

  SizedBox recentProjectBox({String? text}) {
    return SizedBox(
      child: InkWell(
        onTap: (() {
          Get.to(const ProjectDashboard(
            projectId: '23',
          ));
        }),
        child: Container(
          width: screenWidth(context) * 0.1,
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
        ),
      ),
    );
  }
}
