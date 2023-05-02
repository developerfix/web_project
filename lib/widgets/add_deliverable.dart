import 'package:ava/widgets/popup_button.dart';
import 'package:ava/widgets/task_deliverable_widget.dart';
import 'package:get/get.dart';
import '../constants/style.dart';
import 'package:flutter/material.dart';

import '../controllers/project_controller.dart';
import 'add_edit_task_widgets.dart';

Future<dynamic> addTaskDeliverableDialog(
    BuildContext context,
    ProjectController projectController,
    String taskID,
    String status,
    String copilot,
    String endDate,
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
        final formKey = GlobalKey<FormState>();
        return Form(
          key: formKey,
          child: AlertDialog(
            content: SizedBox(
              height: screenHeight(context) * 0.4,
              width: screenWidth(context) * 0.5,
              child: Padding(
                padding: screenWidth(context) < 800
                    ? const EdgeInsets.all(8.0)
                    : const EdgeInsets.all(20.0),
                child: Column(children: <Widget>[
                  txt(
                    txt: 'Add Deliverables\n',
                    textAlign: TextAlign.center,
                    font: 'comfortaa',
                    fontSize: screenWidth(context) < 800 ? 20 : 40,
                    letterSpacing: 6,
                    fontWeight: FontWeight.w700,
                  ),
                  txt(
                    txt:
                        'This task requires deliverables before marking it as complete',
                    fontSize: screenWidth(context) < 800 ? 15 : 20,
                  ),
                  const Spacer(),
                  taskDeliverablesWidget(context),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: screenWidth(context) < 1000
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    children: [
                      popupButton(context, ontap: () {
                        Get.back();
                      }, text: 'Back'),
                      SizedBox(
                        width: screenWidth(context) * 0.01,
                      ),
                      popupButton(context, ontap: () {
                        if (projectController.selectedDeliverables.isNotEmpty) {
                          projectController.addRequiredTaskDeliverables(
                              taskID: taskID,
                              requiredDeliverables:
                                  projectController.selectedDeliverables);
                          projectController.addToCompleted(
                              copilot: copilot,
                              endDate: endDate,
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
                          getErrorSnackBar('Please upload deliverables first');
                        }
                      }, text: 'Add to completed'),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight(context) * 0.005,
                  )
                ]),
              ),
            ),
          ),
        );
      });
}
