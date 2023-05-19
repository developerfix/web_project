import 'package:ava/controllers/auth_controller.dart';
import 'package:ava/widgets/popup_textfield.dart';
import 'package:ava/widgets/select_members.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/style.dart';
import '../controllers/project_controller.dart';
import 'phase_drop_down_button.dart';

Container dateSelectorBox(BuildContext context,
    {required TextEditingController controller, required var date}) {
  // final ProjectController projectController = Get.find<ProjectController>();
  final AuthController authController = Get.find<AuthController>();
  return Container(
    width: screenWidth(context) * 0.2,
    height: screenHeight(context) * 0.05,
    decoration: authController.isDarkTheme.value
        ? darkThemeBoxDecoration
        : lightThemeBoxDecoration,
    child: Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
      child: InkWell(
        onTap: () async {
          DateTime? newDate = await showDatePicker(
            initialDate: DateTime.now(),
            context: context,
            firstDate: DateTime.now().subtract(const Duration(days: 0)),
            lastDate: DateTime(2100),
          );

          if (newDate == null) {
            return;
          } else {
            controller.text = '${newDate.year}/${newDate.month}/${newDate.day}';
          }
        },
        child: TextFormField(
          enabled: false,
          maxLines: null,
          controller: controller,
          decoration: InputDecoration(
              suffixIcon: const Icon(Icons.date_range),
              suffixIconColor: const Color(secondaryColor),
              border: InputBorder.none,
              hintText: date.runtimeType == DateTime
                  ? '${date.year}/${date.month}/${date.day}'
                  : date,
              hintStyle: const TextStyle(
                  color: brownishColor, fontWeight: FontWeight.w600)),
        ),
      ),
    ),
  );
}

SizedBox deliverableQuestionBox(
  BuildContext context,
  BoxConstraints constraints,
) {
  final ProjectController projectController = Get.find<ProjectController>();
  return SizedBox(
      height: screenHeight(context) * 0.1,
      width: constraints.maxWidth < 800
          ? screenWidth(context) * 0.5
          : screenWidth(context) * 0.3,
      child: StatefulBuilder(builder: (context, setState) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            priorityWidget(
              constraints,
              context,
              projectController.taskSelectedValue.value,
              'Yes',
              1,
              (int? val) {
                setState(
                  () {
                    projectController.taskSelectedValue.value = val!;
                    projectController.update();
                  },
                );
              },
            ),
            priorityWidget(
              constraints,
              context,
              projectController.taskSelectedValue.value,
              'No',
              2,
              (int? val) {
                setState(
                  () {
                    projectController.taskSelectedValue.value = val!;
                    projectController.update();
                  },
                );
              },
            ),
          ],
        );
      }));
}

SizedBox priorityBox(
  BuildContext context,
  BoxConstraints constraints,
  // {required int prioritySelectedValue}
) {
  final ProjectController projectController = Get.find<ProjectController>();
  return SizedBox(
      height: screenHeight(context) * 0.2,
      width: constraints.maxWidth < 800
          ? screenWidth(context) * 0.5
          : screenWidth(context) * 0.3,
      child: StatefulBuilder(builder: (context, setState) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            priorityWidget(
              constraints,
              context,
              projectController.taskPrioritySelectedValue.value,
              'High Priority',
              1,
              (int? val) {
                setState(
                  () {
                    projectController.taskPrioritySelectedValue.value = val!;
                    projectController.update();
                  },
                );
              },
            ),
            priorityWidget(
              constraints,
              context,
              projectController.taskPrioritySelectedValue.value,
              'Medium Priority',
              2,
              (int? val) {
                setState(
                  () {
                    projectController.taskPrioritySelectedValue.value = val!;
                    projectController.update();
                  },
                );
              },
            ),
            priorityWidget(
              constraints,
              context,
              projectController.taskPrioritySelectedValue.value,
              'Future Priority',
              3,
              (int? val) {
                setState(
                  () {
                    projectController.taskPrioritySelectedValue.value = val!;
                    projectController.update();
                  },
                );
              },
            )
          ],
        );
      }));
}

StatefulBuilder priorityWidget(
  BoxConstraints constraints,
  BuildContext context,
  int groupValue,
  String? priorityLabel,
  int? value,
  Function(int?)? onChanged,
) {
  return StatefulBuilder(builder: (context, setState) {
    return Row(
      children: [
        SizedBox(
          width:
              constraints.maxWidth < 800 ? null : screenWidth(context) * 0.08,
          child: txt(
            minFontSize: 18,
            maxLines: constraints.maxWidth < 800 ? null : 1,
            txt: priorityLabel!,
            fontSize: 30,
          ),
        ),
        SizedBox(
          height: screenHeight(context) * 0.04,
        ),
        Radio(
          value: value!,
          groupValue: groupValue,
          onChanged: onChanged,
        )
      ],
    );
  });
}

Container copilotWidget(BuildContext context,
    {required TextEditingController taskCoPilotController,
    String? oldPilotorCopilot}) {
  final ProjectController projectController = Get.find<ProjectController>();
  return Container(
    child: screenWidth(context) < 800
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              txt(
                minFontSize: 18,
                txt: 'Co-Pilot:',
                fontSize: 30,
              ),
              SizedBox(
                width: screenWidth(context) * 0.04,
              ),
              selectMember(context,
                  pilotOrCopilotValue: projectController.taskCoPilot.value,
                  controller: taskCoPilotController,
                  oldPilotorCopilot: oldPilotorCopilot,
                  pilotOrCopilot: 'copilot')
            ],
          )
        : Row(
            children: [
              SizedBox(
                width: screenWidth(context) * 0.1,
                child: txt(
                  minFontSize: 18,
                  maxLines: 1,
                  txt: 'Co-Pilot:',
                  fontSize: 30,
                ),
              ),
              SizedBox(
                width: screenWidth(context) * 0.04,
              ),
              selectMember(context,
                  pilotOrCopilotValue: projectController.taskCoPilot.value,
                  controller: taskCoPilotController,
                  oldPilotorCopilot: oldPilotorCopilot,
                  pilotOrCopilot: 'copilot')
            ],
          ),
  );
}

Container pilotWidget(BuildContext context,
    {required TextEditingController taskPilotController,
    String? oldPilotorCopilot}) {
  final ProjectController projectController = Get.find<ProjectController>();
  return Container(
    child: screenWidth(context) < 800
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              txt(
                minFontSize: 18,
                txt: 'Pilot:',
                fontSize: 30,
              ),
              SizedBox(
                width: screenWidth(context) * 0.04,
              ),
              selectMember(
                context,
                pilotOrCopilotValue: projectController.taskPilot.value,
                controller: taskPilotController,
                oldPilotorCopilot: oldPilotorCopilot,
                pilotOrCopilot: 'pilot',
              )
            ],
          )
        : Row(
            children: [
              SizedBox(
                width: screenWidth(context) * 0.1,
                child: txt(
                  minFontSize: 18,
                  maxLines: 1,
                  txt: 'Pilot:',
                  fontSize: 30,
                ),
              ),
              SizedBox(
                width: screenWidth(context) * 0.04,
              ),
              selectMember(context,
                  pilotOrCopilotValue: projectController.taskPilot.value,
                  controller: taskPilotController,
                  oldPilotorCopilot: oldPilotorCopilot,
                  pilotOrCopilot: 'pilot')
            ],
          ),
  );
}

Container descriptionWidget(BuildContext context,
    {required TextEditingController descriptionController,
    String? description}) {
  return Container(
      child: screenWidth(context) < 800
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                txt(
                  minFontSize: 18,
                  txt: 'Task Description:',
                  fontSize: 30,
                ),
                SizedBox(
                  width: screenWidth(context) * 0.04,
                ),
                popUpTextField(
                  context,
                  controller: descriptionController,
                  hint: description ?? '...',
                  maxLines: 1000,
                  height: screenHeight(context) * 0.1,
                ),
              ],
            )
          : Row(
              children: [
                SizedBox(
                  width: screenWidth(context) * 0.1,
                  child: txt(
                    minFontSize: 18,
                    maxLines: 1,
                    txt: 'Task Description:',
                    fontSize: 30,
                  ),
                ),
                SizedBox(
                  width: screenWidth(context) * 0.04,
                ),
                popUpTextField(
                  context,
                  controller: descriptionController,
                  hint: description ?? '...',
                  maxLines: 1000,
                  height: screenHeight(context) * 0.1,
                ),
              ],
            ));
}

Container titleWidget(BoxConstraints constraints, BuildContext context,
    {required TextEditingController titleController, String? taskTitle}) {
  return Container(
      child: screenWidth(context) < 800
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                txt(
                  minFontSize: 18,
                  txt: 'Task Name:',
                  fontSize: 30,
                ),
                SizedBox(
                  width: screenWidth(context) * 0.04,
                ),
                popUpTextField(context,
                    controller: titleController, hint: taskTitle ?? '...'),
              ],
            )
          : Row(
              children: [
                SizedBox(
                  width: screenWidth(context) * 0.1,
                  child: txt(
                    minFontSize: 18,
                    maxLines: 1,
                    txt: 'Task Name:',
                    fontSize: 30,
                  ),
                ),
                SizedBox(
                  width: screenWidth(context) * 0.04,
                ),
                popUpTextField(context,
                    controller: titleController, hint: taskTitle ?? '...'),
              ],
            ));
}

StatefulBuilder phaseWidget(BuildContext context, {String? phase}) {
  return StatefulBuilder(builder: (context, setState) {
    return Container(
        child: screenWidth(context) < 800
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  txt(
                    minFontSize: 18,
                    txt: 'Phase:',
                    fontSize: 30,
                  ),
                  SizedBox(
                    width: screenWidth(context) * 0.04,
                  ),
                  phaseDropDownButton(context, setState, phase: phase),
                ],
              )
            : Row(
                children: [
                  SizedBox(
                    width: screenWidth(context) * 0.1,
                    child: txt(
                      minFontSize: 18,
                      maxLines: 1,
                      txt: 'Phase:',
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(
                    width: screenWidth(context) * 0.04,
                  ),
                  phaseDropDownButton(context, setState, phase: phase),
                ],
              ));
  });
}
