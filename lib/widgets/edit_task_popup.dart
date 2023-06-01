import 'package:ava/widgets/popup_button.dart';
import 'package:ava/widgets/task_deliverable_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ava/constants/style.dart';
import 'package:intl/intl.dart';
import '../controllers/auth_controller.dart';
import '../controllers/project_controller.dart';
import 'add_edit_task_widgets.dart';
import 'add_new_task_popup.dart';

Future<dynamic> editTaskPopUp(
  BuildContext context, {
  final String? taskTitle,
  final String? phase,
  final String? taskDescription,
  final String? pilot,
  final String? copilot,
  final String? oldStarttDate,
  final String? oldEndDate,
  final String? status,
  final String? taskID,
  final int? priorityLevel,
  final int? deliverablesRequiredOrNot,
}) {
  final titleController = TextEditingController();
  final dayToCompleteController = TextEditingController();
  final descriptionController = TextEditingController();
  final endDateController = TextEditingController();
  final startDateController = TextEditingController();
  final taskPilotController = TextEditingController();
  final taskCoPilotController = TextEditingController();
  final taskPilotIDController = TextEditingController();
  final taskCoPilotIDController = TextEditingController();
  int daysBetween = DateFormat("yyyy/MM/dd")
      .parse(oldEndDate!)
      .difference(DateFormat("yyyy/MM/dd").parse(oldStarttDate!))
      .inDays;
  dayToCompleteController.text = daysBetween.toString();

  final ProjectController projectController = Get.find<ProjectController>();
  final AuthController authController = Get.find<AuthController>();
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            content: SizedBox(
                height: screenHeight(context) * 0.7,
                width: 1200,
                child: Column(children: [
                  popupHeader(
                    'Edit Task Details',
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: ListView(
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: screenHeight(context) * 0.02,
                                      ),
                                      titleWidget(context,
                                          titleController: titleController),
                                      SizedBox(
                                        height: screenHeight(context) * 0.02,
                                      ),
                                      phaseWidget(
                                        context,
                                      ),
                                      SizedBox(
                                        height: screenHeight(context) * 0.02,
                                      ),
                                      descriptionWidget(context,
                                          descriptionController:
                                              descriptionController),
                                      SizedBox(
                                        height: screenHeight(context) * 0.02,
                                      ),
                                      pilotWidget(context,
                                          taskPilotController:
                                              taskPilotController,
                                          taskPilotIDController:
                                              taskPilotIDController),
                                      SizedBox(
                                        height: screenHeight(context) * 0.02,
                                      ),
                                      copilotWidget(context,
                                          taskCoPilotController:
                                              taskCoPilotIDController,
                                          taskCoPilotIDController:
                                              taskCoPilotController),
                                      SizedBox(
                                        height: screenHeight(context) * 0.02,
                                      ),
                                      Row(
                                        children: [
                                          textWidgetTaskPopup(
                                              context, 'Start Date:'),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          dateSelectorBox(context,
                                              controller: startDateController,
                                              date: oldStarttDate),
                                        ],
                                      ),
                                      SizedBox(
                                        height: screenHeight(context) * 0.02,
                                      ),
                                      daysToCompleteWidget(
                                          context,
                                          authController,
                                          DateFormat("yyyy/MM/dd")
                                              .parse(oldStarttDate),
                                          endDateController,
                                          dayToCompleteController,
                                          daysBetween),
                                      SizedBox(
                                        height: screenHeight(context) * 0.02,
                                      ),
                                      endDatePicker(
                                          context,
                                          authController,
                                          DateFormat("yyyy/MM/dd")
                                              .parse(oldStarttDate),
                                          dayToCompleteController,
                                          endDateController,
                                          DateFormat("yyyy/MM/dd")
                                              .parse(oldEndDate)),
                                    ],
                                  ),
                                ),
                              ),
                              const RotatedBox(
                                quarterTurns: 1,
                                child: Divider(
                                  thickness: 3,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: ListView(
                                    children: [
                                      SizedBox(
                                        height: screenHeight(context) * 0.03,
                                      ),
                                      textWidgetTaskPopup(context, 'Priority'),
                                      SizedBox(
                                        height: screenHeight(context) * 0.02,
                                      ),
                                      priorityBox(
                                        context,
                                      ),
                                      SizedBox(
                                        height: screenHeight(context) * 0.02,
                                      ),
                                      SizedBox(
                                        width: 300,
                                        child: txt(
                                          minFontSize: 18,
                                          maxLines: 1,
                                          txt: 'Deliverable Required?',
                                          fontSize: 30,
                                          font: 'comfortaa',
                                        ),
                                      ),
                                      SizedBox(
                                        height: screenHeight(context) * 0.02,
                                      ),
                                      deliverableQuestionBox(
                                        context,
                                      ),
                                      SizedBox(
                                        height: screenHeight(context) * 0.02,
                                      ),
                                      taskDeliverablesWidget(context),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          popupButton(context, ontap: () {
                                            Get.back();
                                            projectController.updateTask(
                                                taskID: taskID!,
                                                daysToComplete:
                                                    daysBetween.toString(),
                                                taskDeliverables: projectController
                                                    .selectedDeliverables,
                                                taskTitle: titleController.text.isEmpty
                                                    ? taskTitle
                                                    : titleController.text,
                                                phase: projectController.taskCategory.isEmpty
                                                    ? phase
                                                    : projectController
                                                        .taskCategory.value,
                                                taskDescription: descriptionController.text.isEmpty
                                                    ? taskDescription
                                                    : descriptionController
                                                        .text,
                                                pilot: taskPilotController.text.isEmpty
                                                    ? pilot
                                                    : taskPilotController.text,
                                                copilot: taskCoPilotController.text.isEmpty
                                                    ? copilot
                                                    : taskCoPilotController
                                                        .text,
                                                startDate: startDateController.text.isEmpty
                                                    ? oldStarttDate
                                                    : startDateController.text,
                                                endDate: endDateController.text.isEmpty
                                                    ? oldEndDate
                                                    : endDateController.text,
                                                status: status,
                                                isDeliverableNeededForCompletion:
                                                    projectController.taskSelectedValue.value,
                                                priorityLevel: projectController.taskPrioritySelectedValue.value);

                                            titleController.text = '';
                                            descriptionController.text = '';
                                            taskPilotController.text = '';
                                            taskCoPilotController.text = '';
                                            endDateController.text = '';
                                            startDateController.text = '';
                                          }, text: 'Edit Task'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ])));
      });
}
