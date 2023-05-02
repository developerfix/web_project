import 'package:ava/widgets/popup_button.dart';
import 'package:ava/widgets/task_deliverable_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ava/constants/style.dart';
import '../controllers/project_controller.dart';
import 'add_edit_task_widgets.dart';

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
  final descriptionController = TextEditingController();
  final endDateController = TextEditingController();
  final startDateController = TextEditingController();
  final taskPilotController = TextEditingController();
  final taskCoPilotController = TextEditingController();

  final GlobalKey<ScaffoldState> key = GlobalKey();

  final formKey = GlobalKey<FormState>();
  final ProjectController projectController = Get.find();
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: formKey,
          child: AlertDialog(
            content: SizedBox(
              height: 400,
              width: 650,
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return Column(
                  children: [
                    popUpCloseButton,
                    Expanded(
                      child: Scaffold(
                        key: key,
                        body: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: screenHeight(context) * 0.02,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 50),
                                  child: txt(
                                      txt: 'Edit Task Details',
                                      font: 'comfortaa',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 30,
                                      fontColor: const Color(secondaryColor)),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 50),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height:
                                                screenHeight(context) * 0.02,
                                          ),
                                          titleWidget(constraints, context,
                                              titleController: titleController,
                                              taskTitle: taskTitle),
                                          SizedBox(
                                            height:
                                                screenHeight(context) * 0.02,
                                          ),
                                          phaseWidget(context, phase: phase),
                                          SizedBox(
                                            height:
                                                screenHeight(context) * 0.02,
                                          ),
                                          descriptionWidget(context,
                                              descriptionController:
                                                  descriptionController,
                                              description: taskDescription),
                                          SizedBox(
                                            height:
                                                screenHeight(context) * 0.02,
                                          ),
                                          pilotWidget(context,
                                              taskPilotController:
                                                  taskPilotController,
                                              oldPilotorCopilot: pilot),
                                          SizedBox(
                                            height:
                                                screenHeight(context) * 0.02,
                                          ),
                                          copilotWidget(context,
                                              taskCoPilotController:
                                                  taskCoPilotController,
                                              oldPilotorCopilot: copilot),
                                          SizedBox(
                                            height:
                                                screenHeight(context) * 0.02,
                                          ),
                                          constraints.maxWidth < 800
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    txt(
                                                      minFontSize: 18,
                                                      txt: 'Start Date:',
                                                      fontSize: 30,
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          screenWidth(context) *
                                                              0.04,
                                                    ),
                                                    dateSelectorBox(context,
                                                        controller:
                                                            startDateController,
                                                        date: oldStarttDate),
                                                  ],
                                                )
                                              : Row(
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          screenWidth(context) *
                                                              0.1,
                                                      child: txt(
                                                        minFontSize: 18,
                                                        maxLines: 1,
                                                        txt: 'Start Date:',
                                                        fontSize: 30,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          screenWidth(context) *
                                                              0.04,
                                                    ),
                                                    dateSelectorBox(context,
                                                        controller:
                                                            startDateController,
                                                        date: oldStarttDate),
                                                  ],
                                                ),
                                          SizedBox(
                                            height:
                                                screenHeight(context) * 0.02,
                                          ),
                                          constraints.maxWidth < 800
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    txt(
                                                      minFontSize: 18,
                                                      txt: 'End Date:',
                                                      fontSize: 30,
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          screenWidth(context) *
                                                              0.04,
                                                    ),
                                                    dateSelectorBox(context,
                                                        controller:
                                                            endDateController,
                                                        date: oldEndDate),
                                                  ],
                                                )
                                              : Row(
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          screenWidth(context) *
                                                              0.1,
                                                      child: txt(
                                                        minFontSize: 18,
                                                        maxLines: 1,
                                                        txt: 'End Date:',
                                                        fontSize: 30,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          screenWidth(context) *
                                                              0.04,
                                                    ),
                                                    dateSelectorBox(context,
                                                        controller:
                                                            endDateController,
                                                        date: oldEndDate),
                                                  ],
                                                ),
                                          SizedBox(
                                            height:
                                                screenHeight(context) * 0.02,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      txt(
                                          txt:
                                              'Please select priority level for this task',
                                          fontSize: 30,
                                          font: 'comfortaa',
                                          fontWeight: FontWeight.w700,
                                          fontColor:
                                              const Color(secondaryColor)),
                                      SizedBox(
                                        height: screenHeight(context) * 0.01,
                                      ),
                                      priorityBox(
                                        context,
                                        constraints,
                                      ),
                                      txt(
                                          txt:
                                              'Deliverable needed before completion of this task?',
                                          fontSize: 30,
                                          font: 'comfortaa',
                                          fontWeight: FontWeight.w700,
                                          fontColor:
                                              const Color(secondaryColor)),
                                      deliverableQuestionBox(
                                        context,
                                        constraints,
                                      ),
                                      taskDeliverablesWidget(context),
                                      const Spacer(
                                        flex: 2,
                                      ),
                                      SizedBox(
                                        width: screenWidth(context) * 0.5,
                                        child: Row(
                                          mainAxisAlignment:
                                              constraints.maxWidth < 800
                                                  ? MainAxisAlignment.start
                                                  : MainAxisAlignment.center,
                                          children: [
                                            popupButton(context, ontap: () {
                                              Get.back();
                                              projectController.updateTask(
                                                  taskID: taskID!,
                                                  taskDeliverables: projectController
                                                      .selectedDeliverables,
                                                  taskTitle: titleController.text.isEmpty
                                                      ? taskTitle
                                                      : titleController.text,
                                                  phase: projectController.phaseValue.isEmpty
                                                      ? phase
                                                      : projectController
                                                          .phaseValue.value,
                                                  taskDescription: descriptionController.text.isEmpty
                                                      ? taskDescription
                                                      : descriptionController
                                                          .text,
                                                  pilot: taskPilotController.text.isEmpty
                                                      ? pilot
                                                      : taskPilotController
                                                          .text,
                                                  copilot: taskCoPilotController.text.isEmpty
                                                      ? copilot
                                                      : taskCoPilotController
                                                          .text,
                                                  startDate: startDateController.text.isEmpty
                                                      ? oldStarttDate
                                                      : startDateController
                                                          .text,
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
                                      ),
                                      const Spacer()
                                    ],
                                  ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        );
      });
}
