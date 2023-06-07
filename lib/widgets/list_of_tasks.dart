import 'package:ava/widgets/pilot_copilot_avatar.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:ava/controllers/project_controller.dart';
import 'package:ava/widgets/usersmsg.dart';
import 'package:get/get.dart';

import '../constants/style.dart';
import '../controllers/auth_controller.dart';
import 'add_deliverable.dart';
import 'edit_task_popup.dart';

Widget listOfTasks(
  BuildContext context,
  ProjectController projectController,
  String? board,
  String taskTitle,
  String phase,
  String taskDescription,
  String daysToComplete,
  String pilot,
  String copilot,
  int priorityLevel,
  String taskID,
  int deliverablesRequiredOrNot,
  String status,
  String startDate,
  String endDate,
  List taskDeliverables, {
  List? requiredDeliverables,
}) {
  return Builder(builder: (context) {
    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: ScrollOnExpand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Builder(builder: (context) {
              var controller =
                  ExpandableController.of(context, required: true)!;
              return Expandable(
                collapsed: collapsedWidgetKanbanTask(
                    controller,
                    projectController,
                    context,
                    board,
                    taskTitle,
                    taskDescription,
                    endDate,
                    pilot,
                    phase),
                expanded: expandedWidgetKanbanTask(
                    controller,
                    projectController,
                    context,
                    board,
                    taskTitle,
                    status,
                    copilot,
                    endDate,
                    daysToComplete,
                    phase,
                    pilot,
                    priorityLevel,
                    taskID,
                    deliverablesRequiredOrNot,
                    startDate,
                    taskDescription,
                    taskDeliverables,
                    requiredDeliverables: requiredDeliverables),
              );
            }),
          ],
        ),
      ),
    ));
  });
}

GestureDetector collapsedWidgetKanbanTask(
    ExpandableController controller,
    ProjectController projectController,
    BuildContext context,
    String? board,
    String taskTitle,
    String taskDescription,
    String endDate,
    String pilot,
    String phase) {
  final AuthController authController = Get.find<AuthController>();
  return GestureDetector(
    onTap: () {
      controller.toggle();
    },
    child: Container(
      margin: const EdgeInsets.all(16),
      decoration: authController.isDarkTheme.value
          ? BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                  BoxShadow(
                    color: Colors.black26.withOpacity(.2),
                    blurRadius: 10,
                  )
                ])
          : BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.2),
                    blurRadius: 10,
                  )
                ]),
      child: Column(
        children: [
          Container(
              height: screenHeight(context) * 0.008,
              decoration: BoxDecoration(
                color: board == todo
                    ? Colors.grey.shade500
                    : board == inProgress
                        ? Colors.yellow.shade600
                        : Colors.greenAccent,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              )),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                txt(
                    txt: taskTitle,
                    maxLines: 2,
                    font: 'Comfortaa',
                    fontWeight: FontWeight.w500,
                    fontSize: 24),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 2,
                        child: txt(
                            txt: taskDescription,
                            fontWeight: FontWeight.w500,
                            maxLines: 5,
                            fontSize: 18)),
                    Expanded(
                      child: Column(
                        children: [
                          txt(
                              txt: endDate,
                              maxLines: 1,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                          const SizedBox(
                            height: 5,
                          ),
                          taskPilotCopilotAvatar(projectController, context,
                              imageUrl: pilot),
                        ],
                      ),
                    )
                  ],
                ),
                const Divider(
                  color: Color(secondaryColor),
                  thickness: 2,
                ),
                Center(
                  child: txt(
                      txt: phase,
                      maxLines: 2,
                      font: 'Comfortaa',
                      fontWeight: FontWeight.w500,
                      fontSize: 24),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

GestureDetector expandedWidgetKanbanTask(
    ExpandableController controller,
    ProjectController projectController,
    BuildContext context,
    String? board,
    String taskTitle,
    String status,
    String copilot,
    String endDate,
    String daysToComplete,
    String phase,
    String pilot,
    int priorityLevel,
    String taskID,
    int deliverablesRequiredOrNot,
    String startDate,
    String taskDescription,
    List<dynamic> taskDeliverables,
    {List<dynamic>? requiredDeliverables}) {
  final AuthController authController = Get.find<AuthController>();
  return GestureDetector(
    onTap: () {
      controller.toggle();
    },
    child: Container(
      margin: const EdgeInsets.all(16),
      decoration: authController.isDarkTheme.value
          ? BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                  BoxShadow(
                    color: Colors.black26.withOpacity(.2),
                    blurRadius: 10,
                  )
                ])
          : BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.2),
                    blurRadius: 10,
                  )
                ]),
      child: Column(
        children: [
          Container(
              height: screenHeight(context) * 0.008,
              decoration: BoxDecoration(
                color: board == todo
                    ? Colors.grey.shade500
                    : board == 'inProgress'
                        ? Colors.yellow.shade600
                        : Colors.greenAccent,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              )),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      // flex: 3,
                      child: Center(
                        child: txt(
                            txt: taskTitle,
                            maxLines: 5000,
                            font: 'Comfortaa',
                            fontWeight: FontWeight.w500,
                            fontSize: 24),
                      ),
                    ),
                    popupMenuButtonWidget(
                        status,
                        projectController,
                        copilot,
                        endDate,
                        daysToComplete,
                        phase,
                        pilot,
                        priorityLevel,
                        taskID,
                        deliverablesRequiredOrNot,
                        startDate,
                        taskDescription,
                        taskTitle,
                        taskDeliverables,
                        context),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          txt(
                              txt: taskDescription,
                              fontWeight: FontWeight.w500,
                              maxLines: 5000,
                              fontSize: 18),
                          const Divider(
                            color: Color(secondaryColor),
                            thickness: 2,
                          ),
                          txt(
                              txt: '$daysToComplete days to complete',
                              maxLines: 1,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          txt(
                              txt: startDate,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                          const SizedBox(
                            height: 5,
                          ),
                          txt(
                              txt: endDate,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                          const SizedBox(
                            height: 5,
                          ),
                          taskPilotCopilotAvatar(projectController, context,
                              imageUrl: pilot),
                          const SizedBox(
                            height: 5,
                          ),
                          taskPilotCopilotAvatar(projectController, context,
                              imageUrl: copilot),
                          const SizedBox(
                            height: 5,
                          ),
                          txt(
                              txt: priorityLevel == 1
                                  ? 'Future Priority'
                                  : priorityLevel == 2
                                      ? 'Regular Priority'
                                      : 'High Priority',
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              font: 'Comfortaa',
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ],
                      ),
                    )
                  ],
                ),
                taskDeliverables.isEmpty
                    ? Container()
                    : Row(
                        children: [
                          txt(
                              txt: 'Deliverables:',
                              maxLines: 2,
                              font: 'Comfortaa',
                              fontSize: 24),
                        ],
                      ),
                taskDeliverables.isEmpty
                    ? Container()
                    : deliverablesGrid(taskDeliverables),
                const Divider(
                  color: Color(secondaryColor),
                  thickness: 2,
                ),
                Center(
                  child: txt(
                      txt: phase,
                      maxLines: 2,
                      font: 'Comfortaa',
                      fontWeight: FontWeight.w500,
                      fontSize: 24),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

GridView deliverablesGrid(List<dynamic> taskDeliverables) {
  return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 100,
          childAspectRatio: 2 / 2,
          crossAxisSpacing: 30,
          mainAxisSpacing: 30),
      itemCount: taskDeliverables.length,
      itemBuilder: (BuildContext ctx, index) {
        return InkWell(
          onTap: (() {
            downloadFile(taskDeliverables[index]['urlDownload'],
                taskDeliverables[index]['filename']);
          }),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: const Color(secondaryColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.16),
                  offset: const Offset(0, 3.0),
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: Center(
              child: txt(
                  txt: taskDeliverables[index]['filename'],
                  maxLines: 2,
                  fontColor: Colors.white,
                  fontSize: 16),
            ),
          ),
        );
      });
}

PopupMenuButton<int> popupMenuButtonWidget(
    String status,
    ProjectController projectController,
    String copilot,
    String endDate,
    String daysToComplete,
    String phase,
    String pilot,
    int priorityLevel,
    String taskID,
    int deliverablesRequiredOrNot,
    String startDate,
    String taskDescription,
    String taskTitle,
    List taskDeliverables,
    BuildContext context) {
  return PopupMenuButton(
    onSelected: (value) async {
      if (value == 1) {
        status == todo
            ? projectController.addToInProgress(
                copilot: copilot,
                endDate: endDate,
                daysToComplete: daysToComplete,
                taskID: taskID,
                phase: phase,
                pilot: pilot,
                priorityLevel: priorityLevel,
                deliverablesRequiredOrNot: deliverablesRequiredOrNot,
                startDate: startDate,
                status: status,
                taskDescription: taskDescription,
                taskDeliverables: taskDeliverables,
                taskTitle: taskTitle)
            : status == 'inProgress'
                ? projectController.addToTodo(
                    copilot: copilot,
                    taskID: taskID,
                    endDate: endDate,
                    daysToComplete: daysToComplete,
                    phase: phase,
                    pilot: pilot,
                    priorityLevel: priorityLevel,
                    startDate: startDate,
                    status: status,
                    deliverablesRequiredOrNot: deliverablesRequiredOrNot,
                    taskDescription: taskDescription,
                    taskDeliverables: taskDeliverables,
                    taskTitle: taskTitle)
                : projectController.addToTodo(
                    taskID: taskID,
                    copilot: copilot,
                    endDate: endDate,
                    daysToComplete: daysToComplete,
                    phase: phase,
                    pilot: pilot,
                    priorityLevel: priorityLevel,
                    startDate: startDate,
                    status: status,
                    taskDescription: taskDescription,
                    taskDeliverables: taskDeliverables,
                    deliverablesRequiredOrNot: deliverablesRequiredOrNot,
                    taskTitle: taskTitle);
      } else if (value == 2) {
        if (deliverablesRequiredOrNot != 1) {
          status == todo
              ? projectController.addToCompleted(
                  copilot: copilot,
                  endDate: endDate,
                  daysToComplete: daysToComplete,
                  phase: phase,
                  pilot: pilot,
                  taskID: taskID,
                  priorityLevel: priorityLevel,
                  startDate: startDate,
                  status: status,
                  requiredDeliverables: null,
                  taskDescription: taskDescription,
                  deliverablesRequiredOrNot: deliverablesRequiredOrNot,
                  taskDeliverables: taskDeliverables,
                  taskTitle: taskTitle)
              : status == 'inProgress'
                  ? projectController.addToCompleted(
                      copilot: copilot,
                      endDate: endDate,
                      daysToComplete: daysToComplete,
                      phase: phase,
                      taskID: taskID,
                      pilot: pilot,
                      requiredDeliverables: null,
                      priorityLevel: priorityLevel,
                      startDate: startDate,
                      status: status,
                      taskDescription: taskDescription,
                      taskDeliverables: taskDeliverables,
                      deliverablesRequiredOrNot: deliverablesRequiredOrNot,
                      taskTitle: taskTitle)
                  : projectController.addToInProgress(
                      copilot: copilot,
                      endDate: endDate,
                      daysToComplete: daysToComplete,
                      taskID: taskID,
                      phase: phase,
                      pilot: pilot,
                      priorityLevel: priorityLevel,
                      startDate: startDate,
                      status: status,
                      taskDescription: taskDescription,
                      deliverablesRequiredOrNot: deliverablesRequiredOrNot,
                      taskDeliverables: taskDeliverables,
                      taskTitle: taskTitle);
        } else {
          projectController.selectedDeliverables.clear();
          addTaskDeliverableDialog(
              context,
              projectController,
              taskID,
              status,
              copilot,
              endDate,
              daysToComplete,
              phase,
              pilot,
              priorityLevel,
              startDate,
              taskDescription,
              deliverablesRequiredOrNot,
              taskDeliverables,
              taskTitle);
        }
      } else if (value == 3) {
        projectController.selectedDeliverables.value = taskDeliverables;
        projectController.taskCategory.value = phase;

        editTaskPopUp(
          context,
          copilot: copilot,
          taskID: taskID,
          oldEndDate: endDate,
          phase: phase,
          pilot: pilot,
          priorityLevel: priorityLevel,
          oldStarttDate: startDate,
          status: status,
          taskDescription: taskDescription,
          deliverablesRequiredOrNot: deliverablesRequiredOrNot,
          taskTitle: taskTitle,
        );
      } else {
        projectController.deleteProjectTask(
          taskID: taskID,
          status: status,
        );
      }
    },
    elevation: 3.2,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    itemBuilder: (context) => [
      PopupMenuItem(
        value: 1,
        child: popText(
          status == todo
              ? 'Add to Inprogress'
              : status == 'inProgress'
                  ? 'Add to Todo'
                  : 'Add to Todo',
        ),
      ),
      PopupMenuItem(
        value: 2,
        child: popText(
          status == todo
              ? 'Add to Completed'
              : status == 'inProgress'
                  ? 'Add to Completed'
                  : 'Add to Inprogress',
        ),
      ),
      PopupMenuItem(value: 3, child: popText('Edit')),
      PopupMenuItem(value: 4, child: popText('Delete')),
    ],
    child: const Icon(Icons.edit,
        color: Color(
          secondaryColor,
        ),
        size: 18),
  );
}
