import 'package:ava/controllers/profile_controller.dart';
import 'package:ava/widgets/popup_button.dart';
import 'package:ava/widgets/project_category_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ava/controllers/project_controller.dart';
import 'package:ava/widgets/popup_textfield.dart';

import '../constants/style.dart';
import '../controllers/auth_controller.dart';
import 'add_new_task_popup.dart';

String categoryValue = '3D Design';
Future<dynamic> createProjectPopUp(BuildContext context,
    {required final String uid}) {
  final titleController = TextEditingController();
  final subTitleController = TextEditingController();
  final projectCategoryTitleController = TextEditingController();
  final ProfileController profileController = Get.find<ProfileController>();
  final ProjectController projectController = Get.find<ProjectController>();
  final AuthController authController = Get.find<AuthController>();

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
                      content: SingleChildScrollView(
                    child: StatefulBuilder(
                      builder: (context, setState) => SizedBox(
                        height: screenHeight(context) *
                            (profileController.projectCategory.value ==
                                    newProjectCategory
                                ? 0.6
                                : 0.5),
                        width: 1000,
                        child: Column(
                          children: [
                            popupHeader('NEW PROJECT'),
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
                                            title: 'Name'),
                                        itemRow(context,
                                            widget: popUpTextField(
                                              height:
                                                  screenHeight(context) * 0.1,
                                              maxLines: 1000,
                                              context,
                                              hint: '...',
                                              controller: subTitleController,
                                            ),
                                            title: 'Description'),
                                        projectCategoryDropDown(
                                            context,
                                            authController,
                                            setState,
                                            profileController),
                                        profileController
                                                    .projectCategory.value ==
                                                newProjectCategory
                                            ? newProjectCategoryTextField(
                                                context,
                                                projectCategoryTitleController)
                                            : Container(),
                                      ],
                                    )),
                                    SizedBox(
                                      height: screenHeight(context) * 0.025,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        popupButton(context, ontap: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            projectController.newProject(
                                              lastOpened: DateTime.now(),
                                              username: profileController
                                                  .currentUser.value.name,
                                              uid: uid,
                                              title: titleController.text,
                                              subtitle: subTitleController.text,
                                              catergory: profileController
                                                          .projectCategory
                                                          .value ==
                                                      newProjectCategory
                                                  ? (projectCategoryTitleController
                                                          .text.isEmpty
                                                      ? designCategory
                                                      : projectCategoryTitleController
                                                          .text)
                                                  : profileController
                                                      .projectCategory.value,
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
                  )));
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
