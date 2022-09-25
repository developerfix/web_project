import 'package:ava/widgets/popup_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ava/constants/style.dart';
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

  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: formKey,
          child: AlertDialog(
            content: SizedBox(
              height: screenHeight(context) * 0.7,
              width: screenWidth(context) * 0.5,
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return Scaffold(
                  key: key,
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: constraints.maxWidth < 800
                          ? const EdgeInsets.fromLTRB(10, 30, 10, 50)
                          : const EdgeInsets.fromLTRB(100, 30, 100, 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: screenHeight(context) * 0.02,
                          ),
                          txt(
                              txt: 'Edit Task Details',
                              font: 'comfortaa',
                              fontWeight: FontWeight.w700,
                              fontSize: 30,
                              fontColor: const Color(secondaryColor)),
                          SizedBox(
                            height: screenHeight(context) * 0.03,
                          ),
                          titleWidget(constraints, context,
                              titleController: titleController,
                              taskTitle: taskTitle),
                          SizedBox(
                            height: screenHeight(context) * 0.03,
                          ),
                          phaseWidget(context, phase: phase),
                          SizedBox(
                            height: screenHeight(context) * 0.03,
                          ),
                          descriptionWidget(context,
                              descriptionController: descriptionController,
                              description: taskDescription),
                          SizedBox(
                            height: screenHeight(context) * 0.03,
                          ),
                          pilotWidget(context,
                              taskPilotController: taskPilotController,
                              oldPilotorCopilot: pilot),
                          SizedBox(
                            height: screenHeight(context) * 0.03,
                          ),
                          copilotWidget(context,
                              taskCoPilotController: taskCoPilotController,
                              oldPilotorCopilot: copilot),
                          SizedBox(
                            height: screenHeight(context) * 0.03,
                          ),
                          constraints.maxWidth < 800
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    txt(
                                      minFontSize: 18,
                                      txt: 'Start Date:',
                                      fontSize: 30,
                                    ),
                                    SizedBox(
                                      width: screenWidth(context) * 0.04,
                                    ),
                                    dateSelectorBox(context,
                                        controller: startDateController,
                                        date: oldStarttDate),
                                  ],
                                )
                              : Row(
                                  children: [
                                    SizedBox(
                                      width: screenWidth(context) * 0.1,
                                      child: txt(
                                        minFontSize: 18,
                                        maxLines: 1,
                                        txt: 'Start Date:',
                                        fontSize: 30,
                                      ),
                                    ),
                                    SizedBox(
                                      width: screenWidth(context) * 0.04,
                                    ),
                                    dateSelectorBox(context,
                                        controller: startDateController,
                                        date: oldStarttDate),
                                  ],
                                ),
                          SizedBox(
                            height: screenHeight(context) * 0.03,
                          ),
                          constraints.maxWidth < 800
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    txt(
                                      minFontSize: 18,
                                      txt: 'End Date:',
                                      fontSize: 30,
                                    ),
                                    SizedBox(
                                      width: screenWidth(context) * 0.04,
                                    ),
                                    dateSelectorBox(context,
                                        controller: endDateController,
                                        date: oldEndDate),
                                  ],
                                )
                              : Row(
                                  children: [
                                    SizedBox(
                                      width: screenWidth(context) * 0.1,
                                      child: txt(
                                        minFontSize: 18,
                                        maxLines: 1,
                                        txt: 'End Date:',
                                        fontSize: 30,
                                      ),
                                    ),
                                    SizedBox(
                                      width: screenWidth(context) * 0.04,
                                    ),
                                    dateSelectorBox(context,
                                        controller: endDateController,
                                        date: oldEndDate),
                                  ],
                                ),
                          SizedBox(
                            height: screenHeight(context) * 0.03,
                          ),
                          txt(
                              txt: 'Please select priority level for this task',
                              fontSize: 30,
                              font: 'comfortaa',
                              fontWeight: FontWeight.w700,
                              fontColor: const Color(secondaryColor)),
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
                              fontColor: const Color(secondaryColor)),
                          deliverableQuestionBox(
                            context,
                            constraints,
                          ),
                          deliverablesWidget(context),
                          SizedBox(
                            height: screenWidth(context) * 0.03,
                          ),
                          SizedBox(
                            width: screenWidth(context) * 0.5,
                            child: Row(
                              mainAxisAlignment: constraints.maxWidth < 800
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.center,
                              children: [
                                popupButton(context, ontap: () {
                                  Get.back();
                                  titleController.text = '';
                                  descriptionController.text = '';
                                  taskPilotController.text = '';
                                  taskCoPilotController.text = '';
                                  endDateController.text = '';
                                  startDateController.text = '';
                                }, text: 'Cancel'),
                                SizedBox(
                                  width: screenWidth(context) * 0.005,
                                ),
                                popupButton(context, ontap: () {
                                  Get.back();
                                  projecttController.updateTask(
                                      oldTaskDescription: taskDescription,
                                      oldTaskTitle: taskTitle,
                                      taskDeliverables: projecttController
                                          .selectedDeliverables,
                                      taskTitle: titleController.text.isEmpty
                                          ? taskTitle
                                          : titleController.text,
                                      phase: projecttController
                                              .phaseValue.isEmpty
                                          ? phase
                                          : projecttController.phaseValue.value,
                                      taskDescription:
                                          descriptionController.text.isEmpty
                                              ? taskDescription
                                              : descriptionController.text,
                                      pilot: taskPilotController.text.isEmpty
                                          ? pilot
                                          : taskPilotController.text,
                                      copilot:
                                          taskCoPilotController.text.isEmpty
                                              ? copilot
                                              : taskCoPilotController.text,
                                      startDate:
                                          startDateController.text.isEmpty
                                              ? oldStarttDate
                                              : startDateController.text,
                                      endDate: endDateController.text.isEmpty
                                          ? oldEndDate
                                          : endDateController.text,
                                      status: status,
                                      isDeliverableNeededForCompletion:
                                          projecttController
                                              .taskSelectedValue.value,
                                      priorityLevel: projecttController
                                          .taskPrioritySelectedValue.value);

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
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      });
}
