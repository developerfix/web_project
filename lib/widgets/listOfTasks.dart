import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectx/controllers/project_controller.dart';

import '../constants/style.dart';
import 'edit_task_popup.dart';
import 'dart:math' as math;

Widget listOfTasks(
    BuildContext context,
    ProjectController projectController,
    String? board,
    String taskTitle,
    String phase,
    String taskDescription,
    String pilot,
    String copilot,
    int priorityLevel,
    String status,
    String startDate,
    String endDate) {
  return Builder(builder: (context) {
    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: ScrollOnExpand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: <Widget>[
            //     Builder(
            //       builder: (context) {
            //         var controller =
            //             ExpandableController.of(context, required: true)!;
            //         return TextButton(
            //           child: Text(
            //             controller.expanded ? "COLLAPSE" : "EXPAND",
            //             style: Theme.of(context)
            //                 .textTheme
            //                 .button!
            //                 .copyWith(color: Colors.deepPurple),
            //           ),
            //           onPressed: () {
            //             controller.toggle();
            //           },
            //         );
            //       },
            //     ),
            //   ],
            // ),
            Builder(builder: (context) {
              var controller =
                  ExpandableController.of(context, required: true)!;
              return Expandable(
                collapsed: GestureDetector(
                  onTap: () {
                    controller.toggle();
                  },
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
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
                              color: board == 'todo'
                                  ? Colors.grey.shade500
                                  : board == 'inProgress'
                                      ? Colors.yellow.shade600
                                      : Colors.greenAccent,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8)),
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
                                        txt(
                                            txt: pilot.substring(1),
                                            maxLines: 2,
                                            font: 'Comfortaa',
                                            fontSize: 20),
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
                ),
                expanded: GestureDetector(
                  onTap: () {
                    controller.toggle();
                  },
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
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
                              color: board == 'todo'
                                  ? Colors.grey.shade500
                                  : board == 'inProgress'
                                      ? Colors.yellow.shade600
                                      : Colors.greenAccent,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8)),
                            )),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: txt(
                                        txt: 'Title:',
                                        maxLines: 1,
                                        fontColor: Colors.black,
                                        fontSize: 16),
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: txt(
                                          txt: taskTitle,
                                          maxLines: 1000,
                                          fontSize: 16)),
                                  // const Spacer(),
                                  PopupMenuButton(
                                      onSelected: (value) async {
                                        if (value == 1) {
                                          status == 'todo'
                                              ? projectController
                                                  .addToInProgress(
                                                      copilot: copilot,
                                                      endDate: endDate,
                                                      phase: phase,
                                                      pilot: pilot,
                                                      priorityLevel:
                                                          priorityLevel,
                                                      startDate: startDate,
                                                      status: status,
                                                      taskDescription:
                                                          taskDescription,
                                                      taskTitle: taskTitle)
                                              : status == 'inProgress'
                                                  ? projectController.addToTodo(
                                                      copilot: copilot,
                                                      endDate: endDate,
                                                      phase: phase,
                                                      pilot: pilot,
                                                      priorityLevel:
                                                          priorityLevel,
                                                      startDate: startDate,
                                                      status: status,
                                                      taskDescription:
                                                          taskDescription,
                                                      taskTitle: taskTitle)
                                                  : projectController.addToTodo(
                                                      copilot: copilot,
                                                      endDate: endDate,
                                                      phase: phase,
                                                      pilot: pilot,
                                                      priorityLevel:
                                                          priorityLevel,
                                                      startDate: startDate,
                                                      status: status,
                                                      taskDescription:
                                                          taskDescription,
                                                      taskTitle: taskTitle);
                                        } else if (value == 2) {
                                          status == 'todo'
                                              ? projectController
                                                  .addToCompleted(
                                                      copilot: copilot,
                                                      endDate: endDate,
                                                      phase: phase,
                                                      pilot: pilot,
                                                      priorityLevel:
                                                          priorityLevel,
                                                      startDate: startDate,
                                                      status: status,
                                                      taskDescription:
                                                          taskDescription,
                                                      taskTitle: taskTitle)
                                              : status == 'inProgress'
                                                  ? projectController
                                                      .addToCompleted(
                                                          copilot: copilot,
                                                          endDate: endDate,
                                                          phase: phase,
                                                          pilot: pilot,
                                                          priorityLevel:
                                                              priorityLevel,
                                                          startDate: startDate,
                                                          status: status,
                                                          taskDescription:
                                                              taskDescription,
                                                          taskTitle: taskTitle)
                                                  : projectController
                                                      .addToInProgress(
                                                          copilot: copilot,
                                                          endDate: endDate,
                                                          phase: phase,
                                                          pilot: pilot,
                                                          priorityLevel:
                                                              priorityLevel,
                                                          startDate: startDate,
                                                          status: status,
                                                          taskDescription:
                                                              taskDescription,
                                                          taskTitle: taskTitle);
                                        } else if (value == 3) {
                                          Get.to(editTaskPopUp(
                                            context,
                                            copilot: copilot,
                                            endDate: endDate,
                                            phase: phase,
                                            pilot: pilot,
                                            priorityLevel: priorityLevel,
                                            startDate: startDate,
                                            status: status,
                                            taskDescription: taskDescription,
                                            taskTitle: taskTitle,
                                          ));
                                        } else {
                                          projectController.deleteProjectTask(
                                              status: status,
                                              taskDescription: taskDescription,
                                              taskTitle: taskTitle);
                                        }
                                      },
                                      elevation: 3.2,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 1,
                                              child: Text(
                                                status == 'todo'
                                                    ? 'Add to Inprogress'
                                                    : status == 'inProgress'
                                                        ? 'Add to Todo'
                                                        : 'Add to Todo',
                                                maxLines: 1,
                                                style: GoogleFonts.montserrat(
                                                  textStyle: const TextStyle(
                                                    fontSize: 14,
                                                    overflow:
                                                        TextOverflow.visible,
                                                    color: Color(brownishColor),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 2,
                                              child: Text(
                                                status == 'todo'
                                                    ? 'Add to Completed'
                                                    : status == 'inProgress'
                                                        ? 'Add to Completed'
                                                        : 'Add to Inprogress',
                                                maxLines: 1,
                                                style: GoogleFonts.montserrat(
                                                  textStyle: const TextStyle(
                                                    fontSize: 14,
                                                    overflow:
                                                        TextOverflow.visible,
                                                    color: Color(brownishColor),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 3,
                                              child: Text(
                                                'Edit',
                                                maxLines: 1,
                                                style: GoogleFonts.montserrat(
                                                  textStyle: const TextStyle(
                                                    fontSize: 14,
                                                    overflow:
                                                        TextOverflow.visible,
                                                    color: Color(brownishColor),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 4,
                                              child: Text(
                                                'Delete',
                                                maxLines: 1,
                                                style: GoogleFonts.montserrat(
                                                  textStyle: const TextStyle(
                                                    fontSize: 14,
                                                    overflow:
                                                        TextOverflow.visible,
                                                    color: Color(brownishColor),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                      child: const Icon(Icons.edit,
                                          color: Color(
                                            secondaryColor,
                                          ),
                                          size: 18))
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: txt(
                                        txt: 'Phase:',
                                        maxLines: 1,
                                        fontColor: Colors.black,
                                        fontSize: 16),
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: txt(
                                          txt: phase,
                                          maxLines: 1000,
                                          fontSize: 16)),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: txt(
                                        txt: 'Description:',
                                        maxLines: 1,
                                        fontColor: Colors.black,
                                        fontSize: 16),
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: txt(
                                          txt: taskDescription,
                                          maxLines: 1000,
                                          fontSize: 16)),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: txt(
                                        txt: 'Pilot:',
                                        maxLines: 1,
                                        fontColor: Colors.black,
                                        fontSize: 16),
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: txt(
                                          txt: pilot,
                                          maxLines: 1000,
                                          fontSize: 16)),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: txt(
                                        txt: 'Co-pilot:',
                                        maxLines: 1,
                                        fontColor: Colors.black,
                                        fontSize: 16),
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: txt(
                                          txt: copilot,
                                          maxLines: 1000,
                                          fontSize: 16)),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: txt(
                                        txt: 'Start Date:',
                                        maxLines: 1,
                                        fontColor: Colors.black,
                                        fontSize: 16),
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: txt(
                                          txt: startDate,
                                          maxLines: 1000,
                                          fontSize: 16)),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: txt(
                                        txt: 'End Date:',
                                        maxLines: 1,
                                        fontColor: Colors.black,
                                        fontSize: 16),
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: txt(
                                          txt: endDate,
                                          maxLines: 1000,
                                          fontSize: 16)),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: txt(
                                        maxLines: 1,
                                        txt: 'Priority Level:',
                                        fontColor: Colors.black,
                                        fontSize: 16),
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: txt(
                                          txt: 'High',
                                          maxLines: 1000,
                                          fontSize: 16)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
        // ],
        // ),
      ),
    ));
  });
}
// buildCollapsed1() {
//   return
// }

// buildExpanded1() {
//   return 
// }
