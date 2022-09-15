import 'package:Ava/widgets/select_from_users_popup.dart';
import 'package:flutter/material.dart';

import '../constants/style.dart';
import '../controllers/project_controller.dart';

Container usersSelectionTextField(BuildContext context,
    {ProjectController? projectController,
    String? taskPilotorCopit,
    String? title,
    String? valuee}) {
  return Container(
    width: screenWidth(context) * 0.2,
    height: screenHeight(context) * 0.05,
    decoration: boxDecoration,
    child: Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
      child: InkWell(
        onTap: () {
          selectFromUsersPopup(context, title: title).then((value) {
            if (value != null) {
              valuee = value;
              projectController!.update();
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
              hintText: projectController!.projectPilot.value != ''
                  ? '@${projectController.projectPilot.value}'
                  : taskPilotorCopit,
              hintStyle: const TextStyle(
                  fontSize: 14,
                  color: Color(brownishColor),
                  fontWeight: FontWeight.w600)),
        ),
      ),
    ),
  );
}
