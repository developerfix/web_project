import 'package:ava/widgets/select_from_users_popup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/style.dart';

Container usersSelectionTextField(
  BuildContext context, {
  required bool isPilot,
  String? taskPilotorCopit,
  String? title,
}) {
  return Container(
    width: screenWidth(context) * 0.2,
    height: screenHeight(context) * 0.05,
    decoration: projecttController.isDarkTheme.value
        ? darkThemeBoxDecoration
        : lightThemeBoxDecoration,
    child: Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
      child: InkWell(
        onTap: () {
          selectFromUsersPopup(context, title: title).then((value) {
            if (value != null) {
              isPilot
                  ? projecttController.projectPilot.value = value
                  : projecttController.projectCoPilot.value = value;
              projecttController.update();
            }
          });
        },
        child: TextFormField(
          enabled: false,
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              overflow: TextOverflow.ellipsis,
              letterSpacing: 0,
              color: Color(brownishColor),
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
                ? projecttController.projectPilot.value.isNotEmpty
                    ? '@${projecttController.projectPilot.value}'
                    : taskPilotorCopit
                : projecttController.projectCoPilot.value.isNotEmpty
                    ? '@${projecttController.projectCoPilot.value}'
                    : taskPilotorCopit,
            hintStyle: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                overflow: TextOverflow.ellipsis,
                letterSpacing: 0,
                color: Color(brownishColor),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
