import 'package:Ava/widgets/select_task_members_popup.dart';
import 'package:flutter/material.dart';

import '../constants/style.dart';

Container selectMember(BuildContext context,
    {String? pilotOrCopilot, String? pilotOrCopilotValue}) {
  return Container(
    width: screenWidth(context) * 0.2,
    height: screenHeight(context) * 0.05,
    decoration: boxDecoration,
    child: Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
      child: InkWell(
        onTap: () {
          selectTaskMembersPopup(context,
                  isUser: false,
                  listOfMembers: projecttController.projectMembers,
                  title:
                      'Select ${pilotOrCopilot == 'CoPilot' ? 'CoPilot' : 'Pilot'}  for this task')
              .then(
            (value) {
              if (value != null) {
                pilotOrCopilotValue = '@$value';
                projecttController.update();
              }
            },
          );
        },
        child: TextFormField(
          enabled: false,
          maxLines: null,
          decoration: InputDecoration(
              suffixIcon: const Icon(Icons.person_add),
              suffixIconColor: const Color(secondaryColor),
              border: InputBorder.none,
              hintText: pilotOrCopilotValue,
              hintStyle: const TextStyle(
                  color: Color(brownishColor), fontWeight: FontWeight.w600)),
        ),
      ),
    ),
  );
}
