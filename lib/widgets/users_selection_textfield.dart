import 'package:ava/widgets/select_from_users_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/style.dart';
import '../controllers/auth_controller.dart';
import '../controllers/project_controller.dart';

Container usersSelectionTextField(
  BuildContext context, {
  required bool isPilot,
  String? taskPilotorCopit,
  String? title,
}) {
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
          selectFromUsersPopup(context, title: title).then((value) {
            if (value != null) {
              isPilot
                  ? projectController.projectPilot.value = value
                  : projectController.projectCoPilot.value = value;
              projectController.update();
            }
          });
        },
        child: TextFormField(
          enabled: false,
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              overflow: TextOverflow.ellipsis,
              letterSpacing: 0,
              color: brownishColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          maxLines: null,
          // controller: commentController,
          decoration: InputDecoration(
            suffixIcon: const Icon(Icons.person_add),
            suffixIconColor: const Color(secondaryColor),
            border: InputBorder.none,
            hintText: isPilot
                ? projectController.projectPilot.value.isNotEmpty
                    ? '@${projectController.projectPilot.value}'
                    : taskPilotorCopit
                : projectController.projectCoPilot.value.isNotEmpty
                    ? '@${projectController.projectCoPilot.value}'
                    : taskPilotorCopit,
            hintStyle: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                overflow: TextOverflow.ellipsis,
                letterSpacing: 0,
                color: brownishColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
