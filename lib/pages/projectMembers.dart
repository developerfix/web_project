import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectx/constants/style.dart';
import 'package:projectx/controllers/auth_controller.dart';
import 'package:projectx/controllers/profile_controller.dart';
import 'package:projectx/controllers/project_controller.dart';
import 'package:projectx/pages/select_project_members.dart';
import 'package:projectx/widgets/customAppBar.dart';
import 'package:projectx/widgets/loadingIndicator.dart';
import 'package:projectx/widgets/popup_textfield.dart';

import '../widgets/custom_drawer.dart';
import '../widgets/select_task_members_popup.dart';

class ProjectMembersList extends StatefulWidget {
  const ProjectMembersList({
    Key? key,
  }) : super(key: key);

  @override
  State<ProjectMembersList> createState() => _ProjectMembersListState();
}

class _ProjectMembersListState extends State<ProjectMembersList> {
  final ProjectController projectController = Get.find();
  final ProfileController profileController = Get.find();

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Obx(() {
        return Scaffold(
          key: _key,
          appBar:
              customAppBar(context, username: profileController.user['name']),
          endDrawer: const EndDrawerWidget(),
          body: projectController.isMembersUpdating.isTrue
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const LoadingIndicator(),
                    SizedBox(
                      height: screenHeight(context) * 0.02,
                    ),
                    txt(
                        txt: 'Please wait, members are being updated',
                        fontSize: 14)
                  ],
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(100, 30, 100, 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: screenHeight(context) * 0.05,
                        ),
                        constraints.maxWidth < 1200
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.to(const SelectProjectMembers());
                                    },
                                    child: txt(
                                        txt:
                                            '+ Click here to manage members for this project',
                                        fontSize: 30,
                                        maxLines: 5,
                                        fontColor: const Color(secondaryColor)),
                                  ),
                                  SizedBox(
                                    height: screenHeight(context) * 0.05,
                                  ),
                                  txt(
                                      txt: 'Project Members List',
                                      maxLines: 5,
                                      fontSize: 30,
                                      fontColor: const Color(secondaryColor)),
                                ],
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  txt(
                                      txt: 'Project Members List',
                                      fontSize: 30,
                                      fontColor: const Color(secondaryColor)),
                                  InkWell(
                                    onTap: () {
                                      Get.to(const SelectProjectMembers());
                                    },
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.add,
                                          size: 30,
                                        ),
                                        txt(
                                            txt:
                                                'Click here to manage members for this project',
                                            fontSize: 30,
                                            fontColor:
                                                const Color(secondaryColor)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                        SizedBox(
                          height: screenHeight(context) * 0.05,
                        ),
                        constraints.maxWidth < 600
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  txt(
                                    minFontSize: 18,
                                    maxLines: 1,
                                    txt: 'Project Lead:',
                                    fontSize: 30,
                                  ),
                                  SizedBox(
                                    width: screenWidth(context) * 0.04,
                                  ),
                                  txt(
                                    minFontSize: 18,
                                    maxLines: 1,
                                    txt: projectController.project['lead'],
                                    fontSize: 30,
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  txt(
                                    minFontSize: 18,
                                    maxLines: 1,
                                    txt: 'Project Lead:',
                                    fontSize: 30,
                                  ),
                                  SizedBox(
                                    width: screenWidth(context) * 0.04,
                                  ),
                                  txt(
                                    minFontSize: 18,
                                    maxLines: 1,
                                    txt: projectController.project['lead'],
                                    fontSize: 30,
                                  ),
                                ],
                              ),
                        SizedBox(
                          height: screenHeight(context) * 0.03,
                        ),
                        constraints.maxWidth < 600
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  txt(
                                    minFontSize: 18,
                                    maxLines: 1,
                                    txt: 'Project Co-Pilot:',
                                    fontSize: 30,
                                  ),
                                  SizedBox(
                                    width: screenWidth(context) * 0.04,
                                  ),
                                  txt(
                                    minFontSize: 18,
                                    maxLines: 1,
                                    txt: projectController.project['copilot'],
                                    fontSize: 30,
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  txt(
                                    minFontSize: 18,
                                    maxLines: 1,
                                    txt: 'Project Co-Pilot:',
                                    fontSize: 30,
                                  ),
                                  SizedBox(
                                    width: screenWidth(context) * 0.04,
                                  ),
                                  txt(
                                    minFontSize: 18,
                                    maxLines: 1,
                                    txt: projectController.project['copilot'],
                                    fontSize: 30,
                                  ),
                                ],
                              ),
                        SizedBox(
                          height: screenHeight(context) * 0.03,
                        ),
                        txt(
                            txt: 'Other members list',
                            fontSize: 30,
                            fontColor: const Color(secondaryColor)),
                        SizedBox(
                          height: screenHeight(context) * 0.03,
                        ),
                        SizedBox(
                          height: screenHeight(context) * 0.5,
                          // width: screenWidth(context) * 0.25,
                          child: Obx(() {
                            return ListView.builder(
                                itemCount:
                                    projectController.projectMembers.length,
                                itemBuilder: (context, i) {
                                  String username = projectController
                                      .projectMembers[i]['username'];

                                  return txt(
                                    minFontSize: 18,
                                    maxLines: 1,
                                    txt: username,
                                    fontSize: 30,
                                  );
                                });
                          }),
                        ),
                        SizedBox(
                          height: screenHeight(context) * 0.03,
                        ),
                      ],
                    ),
                  ),
                ),
        );
      });
    });
  }
}
