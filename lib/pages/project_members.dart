import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ava/constants/style.dart';
import 'package:ava/controllers/profile_controller.dart';
import 'package:ava/controllers/project_controller.dart';
import 'package:ava/widgets/custom_appbar.dart';
import 'package:ava/widgets/loading_indicator.dart';

import '../controllers/department_controller.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/left_side_icons.dart';
import '../widgets/select_proj_members_popup.dart';

class ProjectMembersList extends StatefulWidget {
  const ProjectMembersList({
    Key? key,
  }) : super(key: key);

  @override
  State<ProjectMembersList> createState() => _ProjectMembersListState();
}

class _ProjectMembersListState extends State<ProjectMembersList> {
  final ProjectController projectController = Get.find<ProjectController>();
  final ProfileController profileController = Get.find<ProfileController>();
  final DepartmentController departmentController =
      Get.find<DepartmentController>();

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  bool containsOnlyOneItem(List<dynamic> list, dynamic item) {
    return list.length == 1 && list.every((element) => element['uid'] == item);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Obx(() {
        return Scaffold(
          key: _key,
          appBar: customAppBar(
            context,
            pageName:
                '${departmentController.currentDepartment.value.title} - ${projectController.currentProject.value.title}',
          ),
          endDrawer: const EndDrawerWidget(),
          body: Row(
            children: [
              leftSideIcons(context),
              projectController.isMembersUpdating.isTrue
                  ? Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const LoadingIndicator(),
                          SizedBox(
                            height: screenHeight(context) * 0.02,
                          ),
                          txt(
                              txt: 'Please wait, members are being updated',
                              fontSize: 14)
                        ],
                      ),
                    )
                  : Expanded(
                      child: Stack(
                        children: [
                          containsOnlyOneItem(projectController.projectMembers,
                                  profileController.currentUser.value.uid)
                              ? Center(
                                  child: txt(
                                      txt:
                                          'Added projects members will be listed here',
                                      fontSize: 26),
                                )
                              : SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        100, 30, 100, 50),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        txt(
                                            txt: 'Project Members',
                                            fontSize: 60,
                                            fontColor:
                                                const Color(secondaryColor)),
                                        SizedBox(
                                          height: screenHeight(context) * 0.05,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            txt(
                                                txt: 'Project Lead',
                                                fontSize: 30,
                                                fontColor: const Color(
                                                    secondaryColor)),
                                          ],
                                        ),
                                        SizedBox(
                                          height: screenHeight(context) * 0.05,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 100,
                                              child: txt(
                                                minFontSize: 18,
                                                maxLines: 1,
                                                txt: 'Pilot:',
                                                fontSize: 30,
                                              ),
                                            ),
                                            SizedBox(
                                              width:
                                                  screenWidth(context) * 0.04,
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
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 100,
                                              child: txt(
                                                minFontSize: 18,
                                                maxLines: 1,
                                                txt: 'Co-Pilot:',
                                                fontSize: 30,
                                              ),
                                            ),
                                            SizedBox(
                                              width:
                                                  screenWidth(context) * 0.04,
                                            ),
                                            txt(
                                              minFontSize: 18,
                                              maxLines: 1,
                                              txt: projectController
                                                  .currentProject
                                                  .value
                                                  .copilot!,
                                              fontSize: 30,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: screenHeight(context) * 0.03,
                                        ),
                                        txt(
                                            txt: 'Other members',
                                            fontSize: 30,
                                            fontColor:
                                                const Color(secondaryColor)),
                                        SizedBox(
                                          height: screenHeight(context) * 0.03,
                                        ),
                                        ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: projectController
                                                .projectMembers.length,
                                            itemBuilder: (context, i) {
                                              String username =
                                                  projectController
                                                          .projectMembers[i]
                                                      ['username'];

                                              return txt(
                                                minFontSize: 18,
                                                maxLines: 1,
                                                txt: username,
                                                fontSize: 30,
                                              );
                                            }),
                                        SizedBox(
                                          height: screenHeight(context) * 0.03,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    selectProjectMembersPopUp(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(400, 100),
                                    maximumSize: const Size(700, 100),
                                    padding: EdgeInsets
                                        .zero, // Remove default padding

                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ), // Set border radius to 8.0
                                    backgroundColor: const Color(
                                        secondaryColor), // Set button color to secondaryColor
                                    elevation:
                                        6.0, // Set button elevation to 6.0
                                    shadowColor: Colors.black
                                        .withOpacity(0.16), // Set shadow color
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        txt(
                                            txt: 'Manage project members',
                                            font: 'comfortaa',
                                            fontWeight: FontWeight.bold,
                                            fontColor: Colors.white,
                                            fontSize: 26),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Icon(
                                          Icons.manage_accounts,
                                          size: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
            ],
          ),
        );
      });
    });
  }
}
