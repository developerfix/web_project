import 'package:ava/controllers/auth_controller.dart';
import 'package:ava/widgets/popup_textfield.dart';
import 'package:ava/widgets/select_members.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/style.dart';
import '../controllers/project_controller.dart';
import 'add_new_task_popup.dart';
import 'phase_drop_down_button.dart';

Container dateSelectorBox(BuildContext context,
    {required TextEditingController controller, required var date}) {
  final AuthController authController = Get.find<AuthController>();
  return Container(
    width: 300,
    height: 60,
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
          ).then((value) => null);

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

StatefulBuilder deliverableQuestionBox(
  BuildContext context,
) {
  final ProjectController projectController = Get.find<ProjectController>();
  return StatefulBuilder(builder: (context, setState) {
    return Column(
      children: [
        deliverablesQsWidget(
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
        const SizedBox(
          height: 10,
        ),
        deliverablesQsWidget(
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
  });
}

StatefulBuilder priorityBox(
  BuildContext context,
) {
  final ProjectController projectController = Get.find<ProjectController>();
  return StatefulBuilder(builder: (context, setState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        priorityWidget(
          context,
          projectController.taskPrioritySelectedValue.value,
          'Future',
          1,
          const Color(0xff3D5375),
          const Color(0xff3482B2),
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
          context,
          projectController.taskPrioritySelectedValue.value,
          'Normal',
          2,
          const Color(0xff3D5B37),
          const Color(0xff7DB254),
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
          context,
          projectController.taskPrioritySelectedValue.value,
          'High',
          3,
          const Color(0xff842C2C),
          const Color(0xffCC2F2F),
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
  });
}

StatefulBuilder priorityWidget(
  BuildContext context,
  int groupValue,
  String? priorityLabel,
  int? value,
  Color bgColor,
  Color borderColor,
  Function(int?)? onChanged,
) {
  return StatefulBuilder(builder: (context, setState) {
    return Column(
      children: [
        Container(
          width: 150,
          height: 60,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
              width: 2,
            ),
          ),
          child: Center(
            child: txt(
              minFontSize: 18,
              font: 'comfortaa',
              maxLines: 1,
              txt: priorityLabel!,
              fontColor: Colors.white,
              fontSize: 30,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Radio(
          value: value!,
          activeColor: const Color(secondaryColor),
          groupValue: groupValue,
          onChanged: onChanged,
        )
      ],
    );
  });
}

StatefulBuilder deliverablesQsWidget(
  BuildContext context,
  int groupValue,
  String? qsLabel,
  int? value,
  Function(int?)? onChanged,
) {
  return StatefulBuilder(builder: (context, setState) {
    return Row(
      children: [
        Radio(
          value: value!,
          activeColor: const Color(secondaryColor),
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        const SizedBox(
          width: 16,
        ),
        txt(
          minFontSize: 18,
          font: 'comfortaa',
          maxLines: 1,
          txt: qsLabel!,
          fontColor: Colors.white,
          fontSize: 30,
        ),
      ],
    );
  });
}

Row copilotWidget(BuildContext context,
    {required TextEditingController taskCoPilotController,
    required TextEditingController taskCoPilotIDController,
    String? oldPilotorCopilot}) {
  final ProjectController projectController = Get.find<ProjectController>();
  return Row(
    children: [
      textWidgetTaskPopup(
        context,
        'Co-Pilot/s',
      ),
      const SizedBox(
        width: 10,
      ),
      selectMember(context,
          pilotOrCopilotValue: projectController.taskCoPilot.value,
          controller: taskCoPilotController,
          idController: taskCoPilotIDController,
          oldPilotorCopilot: oldPilotorCopilot,
          pilotOrCopilot: 'copilot')
    ],
  );
}

Row pilotWidget(BuildContext context,
    {required TextEditingController taskPilotController,
    required TextEditingController taskPilotIDController,
    String? oldPilotorCopilot}) {
  final ProjectController projectController = Get.find<ProjectController>();
  return Row(
    children: [
      textWidgetTaskPopup(
        context,
        'Pilot:',
      ),
      const SizedBox(
        width: 10,
      ),
      selectMember(context,
          pilotOrCopilotValue: projectController.taskPilot.value,
          controller: taskPilotController,
          idController: taskPilotIDController,
          oldPilotorCopilot: oldPilotorCopilot,
          pilotOrCopilot: 'pilot')
    ],
  );
}

Row descriptionWidget(BuildContext context,
    {required TextEditingController descriptionController,
    String? description}) {
  return Row(
    children: [
      textWidgetTaskPopup(
        context,
        'Description',
      ),
      const SizedBox(
        width: 10,
      ),
      popUpTextField(
        context,
        width: 300,
        controller: descriptionController,
        hint: description ?? '...',
        maxLines: 1000,
        height: screenHeight(context) * 0.1,
      ),
    ],
  );
}

Row titleWidget(BuildContext context,
    {required TextEditingController titleController, String? taskTitle}) {
  return Row(
    children: [
      textWidgetTaskPopup(
        context,
        'Task Name',
      ),
      const SizedBox(
        width: 10,
      ),
      popUpTextField(context,
          width: 300, controller: titleController, hint: taskTitle ?? '...'),
    ],
  );
}

StatefulBuilder phaseWidget(BuildContext context, {String? phase}) {
  return StatefulBuilder(builder: (context, setState) {
    return Row(
      children: [
        textWidgetTaskPopup(
          context,
          'Phase',
        ),
        const SizedBox(
          width: 10,
        ),
        phaseDropDownButton(
          context,
          setState,
        ),
      ],
    );
  });
}
