import 'package:ava/widgets/popup_button.dart';
import 'package:ava/widgets/task_deliverable_widget.dart';
import 'package:get/get.dart';
import '../constants/style.dart';
import 'package:flutter/material.dart';

import '../controllers/project_controller.dart';
import 'add_new_task_popup.dart';

Future<dynamic> addTaskDeliverableDialog(
    BuildContext context,
    ProjectController projectController,
    String taskID,
    String status,
    String copilot,
    String endDate,
    String daysToComplete,
    String phase,
    String pilot,
    int priorityLevel,
    String startDate,
    String taskDescription,
    int deliverablesRequiredOrNot,
    List<dynamic> taskDeliverables,
    String taskTitle) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
              height: screenHeight(context) * 0.4,
              width: 1000,
              child: Column(children: [
                popupHeader('Add Deliverables'),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(children: <Widget>[
                      txt(
                        txt:
                            'This task requires deliverables before marking it as complete',
                        fontSize: 20,
                      ),
                      const Spacer(),
                      taskDeliverablesWidget(context),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          popupButton(context, ontap: () {
                            if (projectController
                                .selectedDeliverables.isNotEmpty) {
                              projectController.addRequiredTaskDeliverables(
                                  taskID: taskID,
                                  requiredDeliverables:
                                      projectController.selectedDeliverables);
                              projectController.addToCompleted(
                                  copilot: copilot,
                                  endDate: endDate,
                                  daysToComplete: daysToComplete,
                                  phase: phase,
                                  pilot: pilot,
                                  taskID: taskID,
                                  priorityLevel: priorityLevel,
                                  startDate: startDate,
                                  status: status,
                                  taskDescription: taskDescription,
                                  deliverablesRequiredOrNot:
                                      deliverablesRequiredOrNot,
                                  taskDeliverables: taskDeliverables,
                                  requiredDeliverables:
                                      projectController.selectedDeliverables,
                                  taskTitle: taskTitle);

                              Get.back();
                            } else {
                              getErrorSnackBar(
                                  'Please upload deliverables first');
                            }
                          }, text: 'Add'),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight(context) * 0.005,
                      )
                    ]),
                  ),
                ),
              ])),
        );
      });
}
