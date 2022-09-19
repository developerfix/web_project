import 'package:Ava/widgets/popup_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Ava/constants/style.dart';
import 'add_edit_task_widgets.dart';

Future<dynamic> addNewTaskPopUp(BuildContext context) {
  final GlobalKey<ScaffoldState> key = GlobalKey();

  DateTime startdate = DateTime.now();
  DateTime endDate = DateTime.now();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final endDateController = TextEditingController();
  final startDateController = TextEditingController();
  final taskPilotController = TextEditingController();
  final taskCoPilotController = TextEditingController();

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
                              txt: 'Task Details',
                              font: 'comfortaa',
                              fontWeight: FontWeight.w700,
                              fontSize: 30,
                              fontColor: const Color(secondaryColor)),
                          SizedBox(
                            height: screenHeight(context) * 0.03,
                          ),
                          titleWidget(constraints, context,
                              titleController: titleController),
                          SizedBox(
                            height: screenHeight(context) * 0.03,
                          ),
                          phaseWidget(
                            context,
                          ),
                          SizedBox(
                            height: screenHeight(context) * 0.03,
                          ),
                          descriptionWidget(context,
                              descriptionController: descriptionController),
                          SizedBox(
                            height: screenHeight(context) * 0.03,
                          ),
                          pilotWidget(context,
                              taskPilotController: taskPilotController),
                          SizedBox(
                            height: screenHeight(context) * 0.03,
                          ),
                          copilotWidget(context,
                              taskCoPilotController: taskCoPilotController),
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
                                    dateSelectorBox(
                                      context,
                                      controller: startDateController,
                                      date: startdate,
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
                                        txt: 'Start Date:',
                                        fontSize: 30,
                                      ),
                                    ),
                                    SizedBox(
                                      width: screenWidth(context) * 0.04,
                                    ),
                                    dateSelectorBox(context,
                                        controller: startDateController,
                                        date: startdate),
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
                                        date: endDate),
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
                                        date: endDate),
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
                                  startDateController.text = '';
                                  endDateController.text = '';
                                  projecttController.taskPilot.value = '';
                                  projecttController.taskCoPilot.value = '';

                                  startdate = DateTime.now();
                                  endDate = DateTime.now();

                                  projecttController.selectedDeliverables
                                      .clear();
                                  projecttController.update();
                                }, text: 'Cancel'),
                                SizedBox(
                                  width: screenWidth(context) * 0.005,
                                ),
                                popupButton(context, ontap: () {
                                  if (titleController.text.isNotEmpty) {
                                    Get.back();
                                    projecttController.addNewTask(
                                        taskTitle: titleController.text,
                                        phase:
                                            projecttController.phaseValue.value,
                                        taskDescription:
                                            descriptionController.text,
                                        pilot: taskPilotController.text,
                                        copilot: taskCoPilotController.text,
                                        deliverables: projecttController
                                            .selectedDeliverables,
                                        startDate: startDateController
                                                .text.isEmpty
                                            ? '${startdate.year}/${startdate.month}/${startdate.day}'
                                            : startDateController.text,
                                        endDate: endDateController.text.isEmpty
                                            ? '${endDate.year}/${endDate.month}/${endDate.day}'
                                            : endDateController.text,
                                        status: 'todo',
                                        isDeliverableNeededForCompletion:
                                            projecttController
                                                .taskSelectedValue.value,
                                        priorityLevel: projecttController
                                            .taskPrioritySelectedValue.value);
                                    titleController.text = '';
                                    descriptionController.text = '';
                                    startDateController.text = '';
                                    endDateController.text = '';
                                    projecttController.taskPilot.value = '';
                                    projecttController.taskCoPilot.value = '';
                                    startdate = DateTime.now();
                                    endDate = DateTime.now();

                                    projecttController.selectedDeliverables
                                        .clear();
                                    projecttController.update();
                                  } else {
                                    getErrorSnackBar(
                                        "Please fillout the taskname");
                                  }
                                }, text: 'Add Task'),
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
