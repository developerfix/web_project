import 'package:ava/controllers/profile_controller.dart';
import 'package:ava/widgets/popup_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ava/controllers/project_controller.dart';
import 'package:ava/widgets/popup_textfield.dart';

import '../constants/style.dart';
import '../controllers/auth_controller.dart';

String categoryValue = '3D Design';
Future<dynamic> editNamePopUp(
  BuildContext context,
) {
  final nameController = TextEditingController();
  final ProfileController profileController = Get.find();

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
                    height: 400,
                    width: 650,
                    child: Column(
                      children: [
                        popUpCloseButton,
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: <Widget>[
                                txt(
                                  txt: 'Edit name',
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
                                  child: itemRow(context,
                                      widget: popUpTextField(
                                        context,
                                        hint: '...',
                                        controller: nameController,
                                      ),
                                      title: 'Name'),
                                ),
                                SizedBox(
                                  height: screenHeight(context) * 0.025,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    popupButton(context, ontap: () {
                                      if (formKey.currentState!.validate()) {
                                        profileController
                                            .editName(nameController.text);
                                        Get.back();
                                      }
                                    }, text: 'Edit'),
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
  final AuthController authController = Get.find();
  return Row(
    children: [
      txt(
          txt: '$title:',
          fontSize: 30,
          fontColor: authController.isDarkTheme.value
              ? Colors.white54
              : Colors.black54),
      const Spacer(),
      widget,
      // const Spacer(),
    ],
  );
}
