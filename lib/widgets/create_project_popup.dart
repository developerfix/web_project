import 'package:ava/controllers/profile_controller.dart';
import 'package:ava/widgets/phase_drop_down_button.dart';
import 'package:ava/widgets/popup_button.dart';
import 'package:ava/widgets/users_selection_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ava/controllers/project_controller.dart';
import 'package:ava/widgets/popup_textfield.dart';

import '../constants/style.dart';
import '../models/project_member.dart';

String categoryValue = '3D Design';
Future<dynamic> createProjectPopUp(BuildContext context,
    {required final String uid}) {
  final titleController = TextEditingController();
  final subTitleController = TextEditingController();
  final ProfileController profileController = Get.find();
  final ProjectController projectController = Get.find();
  String taskPilot = 'select team member';
  String taskCoPilot = 'select team member';
  List<ProjectMember> initialProjectMembers = [];

  final formKey = GlobalKey<FormState>();

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<ProjectController>(
            init: ProjectController(),
            builder: (controller) {
              return Form(
                key: formKey,
                child: AlertDialog(
                  content: SizedBox(
                    height: screenHeight(context) * 0.6,
                    width: screenWidth(context) * 0.3,
                    child: Column(
                      children: [
                        popUpCloseButton,
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: <Widget>[
                                txt(
                                  txt: 'NEW PROJECT',
                                  fontSize: 50,
                                  fontColor: const Color(0XFFab9eab),
                                  font: 'Comfortaa',
                                  letterSpacing: 6,
                                  fontWeight: FontWeight.w700,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Divider(
                                      thickness: 3, color: Color(0xffab9eab)),
                                ),
                                Expanded(
                                    child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    itemRow(context,
                                        widget: popUpTextField(
                                          context,
                                          hint: '...',
                                          controller: titleController,
                                        ),
                                        title: 'Name'),
                                    itemRow(context,
                                        widget: popUpTextField(
                                          height: screenHeight(context) * 0.1,
                                          maxLines: 1000,
                                          context,
                                          hint: '...',
                                          controller: subTitleController,
                                        ),
                                        title: 'Description'),
                                    itemRow(context,
                                        widget: usersSelectionTextField(
                                          context,
                                          isPilot: true,
                                          taskPilotorCopit: taskPilot,
                                          title:
                                              'Select Pilot for this Project',
                                        ),
                                        title: 'Pilot'),
                                    itemRow(context,
                                        widget: usersSelectionTextField(
                                          context,
                                          isPilot: false,
                                          taskPilotorCopit: taskCoPilot,
                                          title:
                                              'Select CoPilot for this Project',
                                        ),
                                        title: 'Copilot'),
                                    itemRow(context, widget: StatefulBuilder(
                                        builder: (context, setState) {
                                      return phaseDropDownButton(
                                        context,
                                        setState,
                                      );
                                    }), title: 'Category'),
                                  ],
                                )),
                                SizedBox(
                                  height: screenHeight(context) * 0.025,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    popupButton(context, ontap: () {
                                      if (formKey.currentState!.validate()) {
                                        if (projectController.projectPilot.value
                                                .isNotEmpty &&
                                            projectController.projectCoPilot
                                                .value.isNotEmpty) {
                                          for (var user
                                              in projectController.users) {
                                            if (user['name'] ==
                                                    projectController
                                                        .projectPilot.value ||
                                                user['name'] ==
                                                    projectController
                                                        .projectCoPilot.value ||
                                                user['uid'] == uid) {
                                              initialProjectMembers.add(
                                                  ProjectMember(
                                                      uid: user['uid'],
                                                      username: user['name']));
                                            }
                                          }
                                          projectController.newProject(
                                              initialProjectMembers:
                                                  initialProjectMembers,
                                              username: profileController
                                                  .currentUser.value.name,
                                              uid: uid,
                                              title: titleController.text,
                                              subtitle: subTitleController.text,
                                              pilot: projectController
                                                  .projectPilot.value,
                                              catergory: projectController
                                                  .phaseValue.value,
                                              copilot: projectController
                                                  .projectCoPilot.value);
                                        } else {
                                          getErrorSnackBar(
                                            "Please select pilot and copilot for the project",
                                          );
                                        }
                                      }
                                    }, text: 'Create'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      });
}

Row itemRow(BuildContext context,
    {required Widget widget, required String title}) {
  return Row(
    children: [
      txt(
        txt: '$title:',
        fontSize: 30,
      ),
      const Spacer(),
      widget,
      // const Spacer(),
    ],
  );
}
