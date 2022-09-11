import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Ava/constants/style.dart';
import 'package:Ava/controllers/auth_controller.dart';
import 'package:Ava/controllers/profile_controller.dart';
import 'package:Ava/controllers/project_controller.dart';
import 'package:Ava/models/project_member.dart';
import 'package:Ava/widgets/custom_appbar.dart';
import 'package:Ava/widgets/loading_indicator.dart';

import '../widgets/custom_drawer.dart';
import '../widgets/select_from_users_popup.dart';
import '../widgets/select_task_members_popup.dart';
import '../widgets/textFieldThemeDec.dart';

class SelectProjectMembers extends StatefulWidget {
  final String? projectId;
  const SelectProjectMembers({Key? key, this.projectId}) : super(key: key);

  @override
  State<SelectProjectMembers> createState() => _SelectProjectMembersState();
}

class _SelectProjectMembersState extends State<SelectProjectMembers> {
  final ProjectController projectController = Get.find();
  final ProfileController profileController = Get.find();
  final _uid = AuthController.instance.user!.uid;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  String taskPilot = '';
  String taskCoPilot = '';
  String taskPilotId = '';
  String taskCoPilotId = '';

  List<ProjectMember> users = [];
  List<ProjectMember> usersList2 = [];
  List<ProjectMember> removedUsers = [];
  List<ProjectMember> finalUserList = [];

  void onUserSelected(bool selected, String userId, String username) {
    if (selected == true) {
      setState(() {
        users.add(ProjectMember(uid: userId, username: username));
      });
    } else {
      setState(() {
        users.removeWhere(
            (element) => element.uid == userId && element.username == username);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    updateUsersList();
  }

  updateUsersList() {
    for (int i = 0; i < projectController.projectMembers.length; i++) {
      users.add(ProjectMember(
          uid: projectController.projectMembers[i]['uid'],
          username: projectController.projectMembers[i]['username']));
      usersList2.add(ProjectMember(
          uid: projectController.projectMembers[i]['uid'],
          username: projectController.projectMembers[i]['username']));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Scaffold(
        key: _key,
        appBar: customAppBar(context, username: profileController.user['name']),
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
                      txt(
                          txt: 'Select members for this project',
                          fontSize: 30,
                          fontColor: const Color(secondaryColor)),
                      SizedBox(
                        height: screenHeight(context) * 0.05,
                      ),
                      constraints.maxWidth < 600
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                txt(
                                  minFontSize: 18,
                                  txt: 'Lead:',
                                  fontSize: 30,
                                ),
                                SizedBox(
                                  width: screenWidth(context) * 0.04,
                                ),
                                Container(
                                  width: constraints.maxWidth < 800
                                      ? screenWidth(context) * 0.4
                                      : screenWidth(context) * 0.2,
                                  height: screenHeight(context) * 0.05,
                                  decoration:
                                      projectController.isDarkTheme.value
                                          ? darkThemeDecoration()
                                          : lightThemeDecoration(),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15, top: 5),
                                    child: InkWell(
                                      onTap: () {
                                        selectTaskMembersPopup(context,
                                                title:
                                                    'Select Pilot for this task')
                                            .then((value) {
                                          if (value != null) {
                                            setState(() {
                                              taskPilot = value;
                                            });
                                          }
                                        });
                                      },
                                      child: TextFormField(
                                        enabled: false,

                                        maxLines: null,
                                        // controller: commentController,
                                        decoration: InputDecoration(
                                            suffixIcon:
                                                const Icon(Icons.person_add),
                                            suffixIconColor:
                                                const Color(secondaryColor),
                                            border: InputBorder.none,
                                            hintText: taskPilot != ''
                                                ? '@$taskPilot'
                                                : taskPilot,
                                            hintStyle: const TextStyle(
                                                fontSize: 14,
                                                color: Color(brownishColor),
                                                fontWeight: FontWeight.w600)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                txt(
                                  minFontSize: 18,
                                  txt: 'Lead:',
                                  fontSize: 30,
                                ),
                                SizedBox(
                                  width: screenWidth(context) * 0.04,
                                ),
                                Container(
                                  width: constraints.maxWidth < 800
                                      ? screenWidth(context) * 0.4
                                      : screenWidth(context) * 0.2,
                                  height: screenHeight(context) * 0.05,
                                  decoration:
                                      projectController.isDarkTheme.value
                                          ? darkThemeDecoration()
                                          : lightThemeDecoration(),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15, top: 5),
                                    child: InkWell(
                                      onTap: () {
                                        selectFromUsersPopup(context,
                                                title:
                                                    'Select Pilot for this task')
                                            .then((value) {
                                          if (value != null) {
                                            setState(() {
                                              taskPilot = value;
                                            });
                                          }
                                        });
                                      },
                                      child: TextFormField(
                                        enabled: false,

                                        maxLines: null,
                                        // controller: commentController,
                                        decoration: InputDecoration(
                                            suffixIcon:
                                                const Icon(Icons.person_add),
                                            suffixIconColor:
                                                const Color(secondaryColor),
                                            border: InputBorder.none,
                                            hintText: taskPilot != ''
                                                ? '@$taskPilot'
                                                : taskPilot,
                                            hintStyle: const TextStyle(
                                                fontSize: 14,
                                                color: Color(brownishColor),
                                                fontWeight: FontWeight.w600)),
                                      ),
                                    ),
                                  ),
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
                                  txt: 'Co-Pilot:',
                                  fontSize: 30,
                                ),
                                SizedBox(
                                  width: screenWidth(context) * 0.04,
                                ),
                                Container(
                                  width: constraints.maxWidth < 800
                                      ? screenWidth(context) * 0.4
                                      : screenWidth(context) * 0.2,
                                  height: screenHeight(context) * 0.05,
                                  decoration:
                                      projectController.isDarkTheme.value
                                          ? darkThemeDecoration()
                                          : lightThemeDecoration(),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15, top: 5),
                                    child: InkWell(
                                      onTap: () {
                                        selectFromUsersPopup(context,
                                                title:
                                                    'Select Co-Pilot for this task')
                                            .then((value) {
                                          if (value != null) {
                                            setState(() {
                                              taskCoPilot = value;
                                            });
                                          }
                                        });
                                      },
                                      child: TextFormField(
                                        enabled: false,
                                        maxLines: null,
                                        decoration: InputDecoration(
                                            suffixIcon:
                                                const Icon(Icons.person_add),
                                            suffixIconColor:
                                                const Color(secondaryColor),
                                            border: InputBorder.none,
                                            hintText: taskCoPilot != ''
                                                ? '@$taskCoPilot'
                                                : taskCoPilot,
                                            hintStyle: const TextStyle(
                                                fontSize: 14,
                                                color: Color(brownishColor),
                                                fontWeight: FontWeight.w600)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                txt(
                                  minFontSize: 18,
                                  txt: 'Co-Pilot:',
                                  fontSize: 30,
                                ),
                                SizedBox(
                                  width: screenWidth(context) * 0.04,
                                ),
                                Container(
                                  width: constraints.maxWidth < 800
                                      ? screenWidth(context) * 0.4
                                      : screenWidth(context) * 0.2,
                                  height: screenHeight(context) * 0.05,
                                  decoration:
                                      projectController.isDarkTheme.value
                                          ? darkThemeDecoration()
                                          : lightThemeDecoration(),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15, top: 5),
                                    child: InkWell(
                                      onTap: () {
                                        selectFromUsersPopup(context,
                                                title:
                                                    'Select Co-Pilot for this task')
                                            .then((value) {
                                          if (value != null) {
                                            setState(() {
                                              taskCoPilot = value;
                                            });
                                          }
                                        });
                                      },
                                      child: TextFormField(
                                        enabled: false,
                                        maxLines: null,
                                        decoration: InputDecoration(
                                            suffixIcon:
                                                const Icon(Icons.person_add),
                                            suffixIconColor:
                                                const Color(secondaryColor),
                                            border: InputBorder.none,
                                            hintText: taskCoPilot != ''
                                                ? '@$taskCoPilot'
                                                : taskCoPilot,
                                            hintStyle: const TextStyle(
                                                fontSize: 14,
                                                color: Color(brownishColor),
                                                fontWeight: FontWeight.w600)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      SizedBox(
                        height: screenHeight(context) * 0.05,
                      ),
                      SizedBox(
                        height: screenHeight(context) * 0.5,
                        width: constraints.maxWidth < 1000
                            ? double.infinity
                            : screenWidth(context) * 0.2,
                        child: Obx(() {
                          return ListView.builder(
                              itemCount: projectController.users.length,
                              itemBuilder: (context, i) {
                                String username =
                                    projectController.users[i]['name'];
                                String userId =
                                    projectController.users[i]['uid'];

                                if (username == taskPilot) {
                                  taskPilotId = userId;
                                }
                                if (username == taskCoPilot) {
                                  taskCoPilotId = userId;
                                }

                                return username == taskPilot ||
                                        username == taskCoPilot ||
                                        userId == _uid
                                    ? Container()
                                    : CheckboxListTile(
                                        side: const BorderSide(
                                            color: Color(secondaryColor)),
                                        checkColor: Colors.white,
                                        activeColor:
                                            const Color(secondaryColor),
                                        title: txt(
                                            txt: username,
                                            fontSize: 18,
                                            fontColor:
                                                const Color(secondaryColor)),
                                        value: users
                                            .map((item) => item.uid)
                                            .contains(userId),
                                        onChanged: (value) {
                                          onUserSelected(
                                              value!, userId, username);
                                        },
                                      );
                              });
                        }),
                      ),
                      SizedBox(
                        height: screenHeight(context) * 0.03,
                      ),
                      SizedBox(
                        width: screenWidth(context) * 0.5,
                        child: Row(
                          mainAxisAlignment: constraints.maxWidth < 600
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                if (taskPilot == '' || taskCoPilot == '') {
                                } else {
                                  users.add(ProjectMember(
                                      uid: taskPilotId, username: taskPilot));
                                  users.add(ProjectMember(
                                      uid: taskCoPilotId,
                                      username: taskCoPilot));
                                  users.add(ProjectMember(
                                      uid: _uid,
                                      username:
                                          profileController.user['name']));

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

                                  projectController.manageProjectMembers(
                                      copilot: taskCoPilot,
                                      removedMembers: removedUsers,
                                      lead: taskPilot,
                                      members: finalUserList,
                                      subtitle:
                                          projectController.project['subtitle'],
                                      title:
                                          projectController.project['title']);

                                  Get.back();
                                }
                              },
                              child: Container(
                                width: constraints.maxWidth < 600
                                    ? screenWidth(context) * 0.3
                                    : screenWidth(context) * 0.1,
                                height: screenHeight(context) * 0.05,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: const Color(0xFF958890),
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
                                        txt: 'Done',
                                        fontSize: 15,
                                        fontColor: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      );
    });
  }
}

Container dropdownContainer(BuildContext context) {
  return Container(
    width: screenWidth(context) * 0.2,
    height: screenHeight(context) * 0.05,
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.16),
          offset: const Offset(0, 3.0),
          blurRadius: 6.0,
        ),
      ],
      borderRadius: BorderRadius.circular(10.0),
    ),
  );
}
