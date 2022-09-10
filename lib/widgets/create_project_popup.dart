import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectx/controllers/project_controller.dart';
import 'package:projectx/widgets/popup_textfield.dart';

import '../constants/style.dart';
import '../controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';
import 'add_new_task_popup.dart';
import 'loading_indicator.dart';

String categoryValue = '3D Design';
Future<dynamic> createProjectPopUp(
  BuildContext context,
) {
  final titleController = TextEditingController();
  final subTitleController = TextEditingController();

  final projectController = Get.put(ProjectController());

  final uid = AuthController.instance.user!.uid;
  String taskPilot = 'asdwed';
  String taskCoPilot = 'aas';

  final formKey = GlobalKey<FormState>();

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<ProfileController>(
            init: ProfileController(),
            builder: (controller) {
              if (controller.user.isEmpty) {
                return const LoadingIndicator();
              } else {
                return Form(
                  key: formKey,
                  child: AlertDialog(
                    content: SizedBox(
                      height: screenHeight(context) * 0.6,
                      width: screenWidth(context) * 0.3,
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
                            Row(
                              children: [
                                SizedBox(
                                  width: screenWidth(context) * 0.07,
                                  height: screenHeight(context) * 0.4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      txt(
                                        txt: 'Name:',
                                        fontSize: 30,
                                      ),
                                      txt(
                                        txt: 'Description:',
                                        fontSize: 30,
                                      ),
                                      txt(
                                        txt: 'Pilot:',
                                        fontSize: 30,
                                      ),
                                      txt(
                                        txt: 'CoPilot:',
                                        fontSize: 30,
                                      ),
                                      txt(
                                        txt: 'Category:',
                                        fontSize: 30,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth(context) * 0.2,
                                  height: screenHeight(context) * 0.4,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      popUpTextField(
                                        context,
                                        hint: '...',
                                        controller: titleController,
                                      ),
                                      popUpTextField(
                                        context,
                                        hint: '...',
                                        controller: subTitleController,
                                      ),
                                      selectMember(context,
                                          pilotOrCopilot: 'Pilot',
                                          pilotOrCopilotValue: projectController
                                              .projectPilot.value),
                                      selectMember(context,
                                          pilotOrCopilot: 'CoPilot',
                                          pilotOrCopilotValue: projectController
                                              .projectCoPilot.value),
                                      categoryWidget(context)
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: screenHeight(context) * 0.025,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Container(
                                    width: screenWidth(context) * 0.04,
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
                                            txt: 'Cancel',
                                            fontSize: 15,
                                            fontColor: Colors.white)),
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth(context) * 0.01,
                                ),
                                InkWell(
                                  onTap: () {
                                    print(projectController.projectPilot.value);
                                    print(
                                        projectController.projectCoPilot.value);
                                    if (formKey.currentState!.validate()) {
                                      if (projectController
                                              .projectPilot.value.isNotEmpty &&
                                          projectController.projectCoPilot.value
                                              .isNotEmpty) {
                                        projectController.newProject(
                                            username: controller.user['name'],
                                            uid: uid,
                                            title: titleController.text,
                                            subtitle: subTitleController.text,
                                            pilot: taskPilot,
                                            copilot: taskCoPilot);
                                      }
                                    }
                                  },
                                  child: Container(
                                    width: screenWidth(context) * 0.04,
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
                                            txt: 'create',
                                            fontSize: 15,
                                            fontColor: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            });
      });
}

StatefulBuilder categoryWidget(BuildContext context) {
  return StatefulBuilder(builder: (context, setState) {
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
        child: Center(
          child: DropdownButtonFormField(
            // itemHeight: 15,
            // menuMaxHeight: 30,
            items: <String>['3D Design', 'Optical Design'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),

            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                overflow: TextOverflow.ellipsis,
                letterSpacing: 0,
                color: Color(brownishColor),
                fontWeight: FontWeight.w600,
              ),
            ),
            onChanged: (value) {
              setState(() {
                categoryValue = value.toString();
              });
            },

            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              hintStyle: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  letterSpacing: 0,
                  color: Color(brownishColor),
                  fontWeight: FontWeight.w600,
                ),
              ),
              hintText: categoryValue,
              fillColor: Colors.white,
            ),
          ),
        ));
  });
}
