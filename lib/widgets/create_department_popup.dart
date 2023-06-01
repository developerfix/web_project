import 'package:ava/controllers/department_controller.dart';
import 'package:ava/widgets/popup_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ava/controllers/project_controller.dart';
import 'package:ava/widgets/popup_textfield.dart';

import '../constants/style.dart';
import 'add_new_task_popup.dart';
import 'icon_drop_down.dart';

String categoryValue = '3D Design';
Future<dynamic> createDepartmentPopUp(BuildContext context,
    {required final String uid}) {
  final titleController = TextEditingController();
  final DepartmentController departmentController =
      Get.find<DepartmentController>();
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
                    height: screenHeight(context) * 0.4,
                    width: 800,
                    child: Column(
                      children: [
                        popupHeader(
                          'NEW DEPARTMENT',
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: <Widget>[
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
                                        title: 'Title'),
                                    Row(
                                      children: [
                                        txt(
                                          txt: 'Icon:',
                                          fontColor: const Color(0XFFab9eab),
                                          fontSize: 30,
                                        ),
                                        const Spacer(),
                                        StatefulBuilder(
                                            builder: (context, setState) {
                                          return iconDropdown(
                                            context,
                                            setState,
                                          );
                                        }),
                                        const Spacer(),
                                      ],
                                    )
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
                                        departmentController.newDepartment(
                                          uid: uid,
                                          created: DateTime.now(),
                                          title: titleController.text,
                                        );
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
        fontColor: const Color(0XFFab9eab),
      ),
      const Spacer(),
      widget,
      // const Spacer(),
    ],
  );
}
