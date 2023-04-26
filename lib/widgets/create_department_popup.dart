import 'package:ava/widgets/popup_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ava/controllers/project_controller.dart';
import 'package:ava/widgets/popup_textfield.dart';

import '../constants/style.dart';
import 'icon_drop_down.dart';

String categoryValue = '3D Design';
Future<dynamic> createDepartmentPopUp(BuildContext context,
    {required final String uid}) {
  final titleController = TextEditingController();
  final ProjectController projectController = Get.find();
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
                                  txt: 'NEW DEPARTMENT',
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
                                        title: 'Title'),
                                    Row(
                                      children: [
                                        txt(
                                          txt: 'Icon:',
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
                                        projectController.newDepartment(
                                          uid: uid,
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
      ),
      const Spacer(),
      widget,
      // const Spacer(),
    ],
  );
}
