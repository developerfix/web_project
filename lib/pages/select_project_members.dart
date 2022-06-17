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
import 'package:projectx/widgets/customAppBar.dart';
import 'package:projectx/widgets/popup_textfield.dart';

import '../widgets/custom_drawer.dart';
import '../widgets/select_task_members_popup.dart';

class SelectProjectMembers extends StatefulWidget {
  final String? projectId;
  const SelectProjectMembers({Key? key, this.projectId}) : super(key: key);

  @override
  State<SelectProjectMembers> createState() => _SelectProjectMembersState();
}

class _SelectProjectMembersState extends State<SelectProjectMembers> {
  final ProjectController projectController = Get.find();
  // final ProfileController profileController = Get.put(ProfileController());
  final _uid = AuthController.instance.user!.uid;
  int _value = 1;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  // @override
  // void initState() {
  //   super.initState();
  //   projectController.updateProjectAndUserId(
  //       projectId: widget.projectId, uid: _uid);
  //   // profileController.updateUserId(_uid);
  // }

  String taskPilot = 'Select from members';
  String taskCoPilot = 'Select from members';

  List<String> users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: customAppBar(context),
      endDrawer: const EndDrawerWidget(),
      body: SingleChildScrollView(
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
              Row(
                children: [
                  SizedBox(
                    width: screenWidth(context) * 0.07,
                    child: txt(
                      minFontSize: 18,
                      maxLines: 1,
                      txt: 'Pilot:',
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(
                    width: screenWidth(context) * 0.04,
                  ),
                  Container(
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
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 5),
                      child: InkWell(
                        onTap: () {
                          selectTaskMembersPopup(context,
                                  title: 'Select Pilot for this task')
                              .then((value) {
                            if (value != null) {
                              setState(() {
                                taskPilot = '@$value';
                              });
                            }
                          });
                        },
                        child: TextFormField(
                          enabled: false,

                          maxLines: null,
                          // controller: commentController,
                          decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.person_add),
                              suffixIconColor: const Color(secondaryColor),
                              border: InputBorder.none,
                              hintText: taskPilot,
                              hintStyle: const TextStyle(
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
              Row(
                children: [
                  SizedBox(
                    width: screenWidth(context) * 0.07,
                    child: txt(
                      minFontSize: 18,
                      maxLines: 1,
                      txt: 'Co-Pilot:',
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(
                    width: screenWidth(context) * 0.04,
                  ),
                  Container(
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
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 5),
                      child: InkWell(
                        onTap: () {
                          selectTaskMembersPopup(context,
                                  title: 'Select Co-Pilot for this task')
                              .then((value) {
                            if (value != null) {
                              setState(() {
                                taskCoPilot = '@$value';
                              });
                            }
                          });
                        },
                        child: TextFormField(
                          enabled: false,
                          maxLines: null,
                          decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.person_add),
                              suffixIconColor: const Color(secondaryColor),
                              border: InputBorder.none,
                              hintText: taskCoPilot,
                              hintStyle: const TextStyle(
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
              SizedBox(
                height: screenHeight(context) * 0.5,
                width: screenWidth(context) * 0.25,
                child: Obx(() {
                  return ListView.builder(
                      itemCount: projectController.users.length,
                      itemBuilder: (context, i) {
                        String username = projectController.users[i]['name'];
                        return CheckboxListTile(
                          side: const BorderSide(color: Color(secondaryColor)),
                          checkColor: Colors.white,
                          activeColor: Color(secondaryColor),
                          title: txt(
                              txt: username,
                              fontSize: 18,
                              fontColor: Color(secondaryColor)),
                          value: true,
                          onChanged: (value) {
                            users.add(username);
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        // if (titleController.text.isNotEmpty &&
                        //     descriptionController.text.isNotEmpty &&
                        //     taskCoPilot != 'Select from members' &&
                        //     taskPilot != 'Select from members' &&
                        //     startdate != endDate) {
                        //   projectController.addNewTask(
                        //       taskTitle: titleController.text,
                        //       phase: phaseValue,
                        //       taskDescription: descriptionController.text,
                        //       uid: _uid,
                        //       projectId: widget.projectId,
                        //       pilot: taskPilot,
                        //       copilot: taskCoPilot,
                        //       startDate:
                        //           '${startdate.year}/${startdate.month}/${startdate.day}',
                        //       endDate:
                        //           '${endDate.year}/${endDate.month}/${endDate.day}',
                        //       status: 'todo',
                        //       priorityLevel: _value);
                        //   Get.back();
                        // } else {
                        //   // getErrorSnackBar(
                        //   //     "Please fillout all the details", '');
                        // }
                      },
                      child: Container(
                        width: screenWidth(context) * 0.1,
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
                                txt: 'Proceed',
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
}
