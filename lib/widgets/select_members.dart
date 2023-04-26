import 'package:ava/controllers/auth_controller.dart';
import 'package:ava/widgets/select_task_members_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/style.dart';
import '../controllers/project_controller.dart';

Container selectMember(BuildContext context,
    {String? pilotOrCopilot,
    String? pilotOrCopilotValue,
    String? oldPilotorCopilot,
    required TextEditingController controller}) {
  final ProjectController projectController = Get.find();
  final AuthController authController = Get.find();

  return Container(
    width: screenWidth(context) * 0.2,
    height: screenHeight(context) * 0.05,
    decoration: authController.isDarkTheme.value
        ? darkThemeBoxDecoration
        : lightThemeBoxDecoration,
    child: Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
      child: InkWell(
        onTap: () {
          selectTaskMembersPopup(context,
                  isUser: false,
                  listOfMembers: projectController.projectMembers,
                  title:
                      'Select ${pilotOrCopilot == 'CoPilot' ? 'CoPilot' : 'Pilot'}  for this task')
              .then(
            (value) {
              if (value != null) {
                controller.text = value;
                pilotOrCopilotValue = '@$value';
                projectController.update();
              }
            },
          );
        },
        child: TextFormField(
          enabled: false,
          maxLines: null,
          controller: controller,
          style: const TextStyle(
              color: brownishColor, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
              suffixIcon: const Icon(Icons.person_add),
              suffixIconColor: const Color(secondaryColor),
              border: InputBorder.none,
              hintText: oldPilotorCopilot ?? pilotOrCopilotValue,
              hintStyle: const TextStyle(
                  color: brownishColor, fontWeight: FontWeight.w600)),
        ),
      ),
    ),
  );
}
