import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ava/constants/style.dart';
import 'package:ava/controllers/profile_controller.dart';
import 'package:ava/controllers/project_controller.dart';
import 'package:ava/pages/select_project_members.dart';
import 'package:ava/widgets/custom_appbar.dart';
import 'package:ava/widgets/loading_indicator.dart';

import '../widgets/custom_drawer.dart';

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
          appBar: customAppBar(
            context,
          ),
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
                                      Get.to(
                                          () => const SelectProjectMembers());
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
                                      Get.to(
                                          () => const SelectProjectMembers());
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
                                    txt: projectController
                                        .currentProject.value.lead!,
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
                                    txt: projectController
                                        .currentProject.value.lead!,
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
                                    txt: projectController
                                        .currentProject.value.copilot!,
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
                                    txt: projectController
                                        .currentProject.value.copilot!,
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
