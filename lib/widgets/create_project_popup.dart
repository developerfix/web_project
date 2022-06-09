import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectx/controllers/project_controller.dart';
import 'package:projectx/pages/project_dashboard.dart';
import 'package:projectx/widgets/popup_textfield.dart';

import '../constants/style.dart';
import '../controllers/auth_controller.dart';

Future<dynamic> createProjectPopUp(
  BuildContext context,
) {
  final titleController = TextEditingController();
  final subTitleController = TextEditingController();
  final pIDController = TextEditingController();

  final projectController = Get.put(ProjectController());
  final _uid = AuthController.instance.user!.uid;

  final _formKey = GlobalKey<FormState>();

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: AlertDialog(
            content: SizedBox(
              height: screenHeight(context) * 0.45,
              width: screenWidth(context) * 0.3,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    txt(
                      txt: 'Project Details',
                      fontSize: 50,
                      letterSpacing: 6,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(
                      height: screenHeight(context) * 0.025,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: screenWidth(context) * 0.07,
                          height: screenHeight(context) * 0.25,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              txt(
                                txt: 'Title:',
                                fontSize: 30,
                              ),
                              txt(
                                txt: 'Subtitle:',
                                fontSize: 30,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: screenWidth(context) * 0.2,
                          height: screenHeight(context) * 0.25,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              popUpTextField(
                                context,
                                hint: 'enter project ID',
                                controller: pIDController,
                              ),
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
                            if (_formKey.currentState!.validate()) {
                              projectController.newProject(
                                  title: titleController.text,
                                  projectId: pIDController.text,
                                  subtitle: subTitleController.text,
                                  uid: _uid);
                              Get.back();
                              Get.to(ProjectDashboard(
                                projectId: pIDController.text,
                              ));
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
                                    txt: 'Proceed',
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
      });
}
