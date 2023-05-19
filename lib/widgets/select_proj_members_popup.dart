import 'package:ava/controllers/auth_controller.dart';
import 'package:ava/controllers/project_controller.dart';
import 'package:ava/widgets/users_selection_textfield.dart';
import 'package:get/get.dart';
import '../constants/style.dart';
import 'package:flutter/material.dart';

import '../controllers/profile_controller.dart';
import '../models/project_member.dart';

Future<dynamic> selectProjectMembersPopUp(BuildContext context) {
  final ProfileController profileController = Get.find<ProfileController>();
  final ProjectController projectController = Get.find<ProjectController>();
  final uid = AuthController.instance.user!.uid;

  List<ProjectMember> users = [];
  List<ProjectMember> usersList2 = [];
  List<ProjectMember> removedUsers = [];
  List<ProjectMember> finalUserList = [];

  void onUserSelected(bool selected, String userId, String username) {
    if (selected == true) {
      users.add(ProjectMember(uid: userId, username: username));
    } else {
      users.removeWhere(
          (element) => element.uid == userId && element.username == username);
    }
  }

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      for (int i = 0; i < projectController.projectMembers.length; i++) {
        users.add(ProjectMember(
            uid: projectController.projectMembers[i]['uid'],
            username: projectController.projectMembers[i]['username']));
        usersList2.add(ProjectMember(
            uid: projectController.projectMembers[i]['uid'],
            username: projectController.projectMembers[i]['username']));
      }

      return AlertDialog(
        content: SingleChildScrollView(
          child: StatefulBuilder(
            builder: (context, setState) => SizedBox(
              height: screenHeight(context) * 0.8,
              width: 1000,
              child: Column(
                children: [
                  popUpCloseButton,
                  Expanded(
                    child: GetBuilder<ProjectController>(
                      init: ProjectController(),
                      builder: (controller) {
                        return Stack(
                          children: [
                            SingleChildScrollView(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(100, 30, 100, 50),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: screenHeight(context) * 0.03,
                                    ),
                                    txt(
                                        txt: 'Select members for this project',
                                        fontSize: 40,
                                        fontColor: const Color(secondaryColor)),
                                    SizedBox(
                                      height: screenHeight(context) * 0.05,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: txt(
                                            minFontSize: 18,
                                            txt: 'Lead:',
                                            fontSize: 30,
                                          ),
                                        ),
                                        SizedBox(
                                          width: screenWidth(context) * 0.04,
                                        ),
                                        usersSelectionTextField(
                                          context,
                                          taskPilotorCopit: projectController
                                              .currentProject.value.lead,
                                          isPilot: true,
                                          title:
                                              'Select Pilot for this Project',
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
                                            txt: 'Co-Pilot:',
                                            fontSize: 30,
                                          ),
                                        ),
                                        SizedBox(
                                          width: screenWidth(context) * 0.04,
                                        ),
                                        usersSelectionTextField(
                                          context,
                                          taskPilotorCopit: projectController
                                              .currentProject.value.copilot,
                                          isPilot: false,
                                          title:
                                              'Select CoPilot for this Project',
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: screenHeight(context) * 0.05,
                                    ),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: controller.users.length,
                                        itemBuilder: (context, i) {
                                          String username =
                                              controller.users[i].name!;
                                          String userId =
                                              controller.users[i].uid!;

                                          if (username ==
                                              projectController
                                                  .currentProject.value.lead) {
                                            projectController.currentProject
                                                .value.leadID = userId;
                                          }
                                          if (username ==
                                              projectController.currentProject
                                                  .value.copilot) {
                                            projectController.currentProject
                                                .value.copilotID = userId;
                                          }

                                          return username ==
                                                      projectController
                                                          .currentProject
                                                          .value
                                                          .lead ||
                                                  username ==
                                                      projectController
                                                          .currentProject
                                                          .value
                                                          .copilot ||
                                                  userId == uid
                                              ? Container()
                                              : CheckboxListTile(
                                                  side: const BorderSide(
                                                      color: Color(
                                                          secondaryColor)),
                                                  checkColor: Colors.white,
                                                  activeColor: const Color(
                                                      secondaryColor),
                                                  title: txt(
                                                      txt: username,
                                                      fontSize: 18,
                                                      fontColor: const Color(
                                                          secondaryColor)),
                                                  value: users
                                                      .map((item) => item.uid)
                                                      .contains(userId),
                                                  onChanged: (value) {
                                                    onUserSelected(value!,
                                                        userId, username);
                                                    setState(
                                                      () {},
                                                    );
                                                  },
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
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      users.add(ProjectMember(
                                          uid: projectController
                                              .currentProject.value.leadID,
                                          username: projectController
                                              .currentProject.value.lead));
                                      users.add(ProjectMember(
                                          uid: projectController
                                              .currentProject.value.copilotID,
                                          username: projectController
                                              .currentProject.value.copilot));
                                      users.add(ProjectMember(
                                          uid: uid,
                                          username: profileController
                                              .currentUser.value.name));

                                      // removing duplicate values
                                      for (var element in users) {
                                        finalUserList.removeWhere(
                                            (e) => element.uid == e.uid);
                                        finalUserList.add(element);
                                      }
                                      // checking the removed users
                                      for (var element in users) {
                                        usersList2.removeWhere(
                                            (e) => element.uid == e.uid);
                                        removedUsers = usersList2;
                                      }

                                      controller.manageProjectMembers(
                                        removedMembers: removedUsers,
                                        members: finalUserList,
                                      );

                                      Get.back();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(200, 100),
                                      maximumSize: const Size(300, 100),
                                      padding: EdgeInsets
                                          .zero, // Remove default padding

                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ), // Set border radius to 8.0
                                      backgroundColor: const Color(
                                          secondaryColor), // Set button color to secondaryColor
                                      elevation:
                                          6.0, // Set button elevation to 6.0
                                      shadowColor: Colors.black.withOpacity(
                                          0.16), // Set shadow color
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          txt(
                                              txt: 'Done',
                                              font: 'comfortaa',
                                              fontWeight: FontWeight.bold,
                                              fontColor: Colors.white,
                                              fontSize: 26),
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
