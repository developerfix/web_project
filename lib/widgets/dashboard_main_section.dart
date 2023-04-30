import 'package:ava/widgets/plus_icon_widget.dart';
import 'package:ava/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ava/controllers/profile_controller.dart';
import 'package:ava/controllers/project_controller.dart';

import '../constants/style.dart';
import '../controllers/auth_controller.dart';
import 'list_of_tasks.dart';
import 'loading_indicator.dart';

Expanded dashboardMainSection(BuildContext context, BoxConstraints constraints,
    {ProjectController? projectController,
    ProfileController? profileController}) {
  return Expanded(
    flex: 5,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(10, 30, 50, 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    txt(
                      txt: projectController!.currentProject.value.title != null
                          ? projectController.currentProject.value.title!
                              .toUpperCase()
                          : ''.toUpperCase(),
                      fontSize: 50,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 5,
                    ),
                    txt(
                      txt: projectController.currentProject.value.subtitle !=
                              null
                          ? projectController.currentProject.value.subtitle!
                              .toUpperCase()
                          : ''.toUpperCase(),
                      fontSize: 30,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      letterSpacing: 2,
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  txt(
                    txt: 'PROJECT MEMBERS',
                    fontSize: 20,
                    minFontSize: 8,
                    letterSpacing: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: screenHeight(context) * 0.005,
                  ),
                  Row(
                    children: [
                      profileAvatar(
                        context,
                        // user: nameFirstChar!.capitalize.toString(),
                        // fontSize: 14,
                        // maxRadius: 18
                      ),
                      SizedBox(
                        width: screenWidth(context) * 0.005,
                      ),
                      profileAvatar(context,
                          // user: nameFirstChar!.capitalize.toString(),
                          fontSize: 14,
                          maxRadius: 18),
                    ],
                  )
                ],
              ),

              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     txt(
              //       txt:
              //           projectController.project['lead'] == 'assign lead'
              //               ? projectController.project['lead']
              //               : '@${projectController.project['lead']} ',
              //       fontSize: 20,
              //       minFontSize: 8,
              //       overflow: TextOverflow.ellipsis,
              //     ),
              //     txt(
              //       txt: projectController.project['copilot'] ==
              //               'assign co-pilot'
              //           ? projectController.project['copilot']
              //           : '@${projectController.project['copilot']} ',
              //       fontSize: 20,
              //       minFontSize: 8,
              //       overflow: TextOverflow.ellipsis,
              //     ),
            ],
          ),
          SizedBox(
            height: screenHeight(context) * 0.03,
          ),
          Expanded(
              child: constraints.maxWidth < 1200
                  ? ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        SizedBox(
                          width: 400,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: todoKanbanList(context, projectController),
                          ),
                        ),
                        SizedBox(
                          width: 400,
                          child:
                              inprogressKanbanList(context, projectController),
                        ),
                        SizedBox(
                          width: 400,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child:
                                completedKanbanList(context, projectController),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: todoKanbanList(context, projectController),
                          ),
                        ),
                        Expanded(
                          child:
                              inprogressKanbanList(context, projectController),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child:
                                completedKanbanList(context, projectController),
                          ),
                        ),
                      ],
                    )),
        ],
      ),
    ),
  );
}

Column completedKanbanList(
    BuildContext context, ProjectController projectController) {
  final AuthController authController = Get.find();
  return Column(
    children: [
      statusContainer(context, 'COMPLETED'),
      SizedBox(
        height: screenHeight(context) * 0.02,
      ),
      Container(
        height: screenHeight(context) * 0.73,
        decoration: BoxDecoration(
          color: authController.isDarkTheme.value
              ? Colors.black26
              : const Color(0xfff0f2f5),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: projectController.isTasksUpdating.isTrue
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LoadingIndicator(),
                  txt(txt: 'Please wait\n Task is being updated', fontSize: 14)
                ],
              )
            : projectController.completedTasks.isEmpty
                ? Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: txt(
                              txt: 'No task in completed list', fontSize: 14),
                        ),
                      ),
                      plusIconWidget(context, status: completed),
                    ],
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          // shrinkWrap: true,
                          // reverse: true,
                          itemCount: projectController.completedTasks.length,

                          itemBuilder: (context, i) {
                            final String taskTitle = projectController
                                .completedTasks[i]['taskTitle'];
                            final String phase =
                                projectController.completedTasks[i]['phase'];
                            final String taskDescription = projectController
                                .completedTasks[i]['taskDescription'];
                            final String pilot =
                                projectController.completedTasks[i]['pilot'];
                            final String copilot =
                                projectController.completedTasks[i]['copilot'];
                            final String startDate = projectController
                                .completedTasks[i]['startDate'];
                            final String endDate =
                                projectController.completedTasks[i]['endDate'];

                            final int priorityLevel = projectController
                                .completedTasks[i]['priorityLevel'];
                            final int deliverablesRequiredOrNot =
                                projectController.completedTasks[i]
                                    ['isDeliverableNeededForCompletion'];
                            final String status =
                                projectController.completedTasks[i]['status'];
                            final String taskID =
                                projectController.completedTasks[i]['taskID'];

                            final List taskDeliverables = [];
                            final List requiredDeliverables = [];

                            for (var item in projectController.completedTasks[i]
                                ['deliverables']) {
                              taskDeliverables.add(item);
                            }
                            if (projectController.completedTasks[i]
                                    ['requiredDeliverables'] !=
                                null) {
                              for (var item in projectController
                                  .completedTasks[i]['requiredDeliverables']) {
                                requiredDeliverables.add(item);
                              }
                            }
                            return listOfTasks(
                                context,
                                projectController,
                                completed,
                                taskTitle,
                                phase,
                                taskDescription,
                                pilot,
                                copilot,
                                priorityLevel,
                                taskID,
                                deliverablesRequiredOrNot,
                                status,
                                startDate,
                                endDate,
                                taskDeliverables,
                                requiredDeliverables: requiredDeliverables);
                          },
                        ),
                      ),
                      plusIconWidget(context, status: completed),
                    ],
                  ),
      ),
    ],
  );
}

Column inprogressKanbanList(
    BuildContext context, ProjectController projectController) {
  final AuthController authController = Get.find();
  return Column(
    children: [
      statusContainer(context, 'IN PROGRESS'),
      SizedBox(
        height: screenHeight(context) * 0.02,
      ),
      Container(
        height: screenHeight(context) * 0.73,
        decoration: BoxDecoration(
          color: authController.isDarkTheme.value
              ? Colors.black26
              : const Color(0xfff0f2f5),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: projectController.isTasksUpdating.isTrue
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LoadingIndicator(),
                  txt(txt: 'Please wait\n Task is being updated', fontSize: 14)
                ],
              )
            : projectController.inProgressTasks.isEmpty
                ? Column(
                    children: [
                      Expanded(
                        child: Center(
                          child:
                              txt(txt: 'No task in is progress', fontSize: 14),
                        ),
                      ),
                      plusIconWidget(context, status: inProgress),
                    ],
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          // shrinkWrap: true,
                          // reverse: true,
                          itemCount: projectController.inProgressTasks.length,

                          itemBuilder: (context, i) {
                            final String taskTitle = projectController
                                .inProgressTasks[i]['taskTitle'];
                            final String phase =
                                projectController.inProgressTasks[i]['phase'];
                            final String taskDescription = projectController
                                .inProgressTasks[i]['taskDescription'];
                            final String pilot =
                                projectController.inProgressTasks[i]['pilot'];
                            final String copilot =
                                projectController.inProgressTasks[i]['copilot'];
                            final String startDate = projectController
                                .inProgressTasks[i]['startDate'];
                            final String endDate =
                                projectController.inProgressTasks[i]['endDate'];

                            final int priorityLevel = projectController
                                .inProgressTasks[i]['priorityLevel'];
                            final int deliverablesRequiredOrNot =
                                projectController.inProgressTasks[i]
                                    ['isDeliverableNeededForCompletion'];
                            final String status =
                                projectController.inProgressTasks[i]['status'];
                            final String taskID =
                                projectController.inProgressTasks[i]['taskID'];

                            final List taskDeliverables = [];

                            for (var item in projectController
                                .inProgressTasks[i]['deliverables']) {
                              taskDeliverables.add(item);
                            }

                            return listOfTasks(
                                context,
                                projectController,
                                'inProgress',
                                taskTitle,
                                phase,
                                taskDescription,
                                pilot,
                                copilot,
                                priorityLevel,
                                taskID,
                                deliverablesRequiredOrNot,
                                status,
                                startDate,
                                endDate,
                                taskDeliverables,
                                requiredDeliverables: null);
                          },
                        ),
                      ),
                      plusIconWidget(context, status: inProgress),
                    ],
                  ),
      ),
    ],
  );
}

Column todoKanbanList(
    BuildContext context, ProjectController projectController) {
  final AuthController authController = Get.find();
  return Column(
    children: [
      statusContainer(context, 'TO DO'),
      SizedBox(
        height: screenHeight(context) * 0.02,
      ),
      Container(
        height: screenHeight(context) * 0.73,
        decoration: BoxDecoration(
          color: authController.isDarkTheme.value
              ? Colors.black26
              : const Color(0xfff0f2f5),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: projectController.isTasksUpdating.isTrue
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LoadingIndicator(),
                  txt(txt: 'Please wait\n Task is being updated', fontSize: 14),
                ],
              )
            : projectController.toDoTasks.isEmpty
                ? Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: txt(txt: 'No task in Todo list', fontSize: 14),
                        ),
                      ),
                      plusIconWidget(context, status: todo),
                    ],
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: projectController.toDoTasks.length,
                          itemBuilder: (context, i) {
                            final String taskTitle =
                                projectController.toDoTasks[i]['taskTitle'];
                            final String phase =
                                projectController.toDoTasks[i]['phase'];
                            final String taskDescription = projectController
                                .toDoTasks[i]['taskDescription'];
                            final String pilot =
                                projectController.toDoTasks[i]['pilot'];
                            final String copilot =
                                projectController.toDoTasks[i]['copilot'];
                            final String startDate =
                                projectController.toDoTasks[i]['startDate'];
                            final String endDate =
                                projectController.toDoTasks[i]['endDate'];
                            final String taskID =
                                projectController.toDoTasks[i]['taskID'];

                            final int priorityLevel =
                                projectController.toDoTasks[i]['priorityLevel'];
                            final int deliverablesRequiredOrNot =
                                projectController.toDoTasks[i]
                                    ['isDeliverableNeededForCompletion'];
                            final String status =
                                projectController.toDoTasks[i]['status'];
                            final List taskDeliverables = [];

                            for (var item in projectController.toDoTasks[i]
                                ['deliverables']) {
                              taskDeliverables.add(item);
                            }

                            return listOfTasks(
                                context,
                                projectController,
                                todo,
                                taskTitle,
                                phase,
                                taskDescription,
                                pilot,
                                copilot,
                                priorityLevel,
                                taskID,
                                deliverablesRequiredOrNot,
                                status,
                                startDate,
                                endDate,
                                taskDeliverables,
                                requiredDeliverables: null);
                          },
                        ),
                      ),
                      plusIconWidget(context, status: todo)
                    ],
                  ),
      ),
    ],
  );
}

Container statusContainer(BuildContext context, String title) {
  return Container(
    // width: screenWidth(context) * 0.15,
    height: screenHeight(context) * 0.03,
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
          txt: title,
          font: 'comfortaa',
          fontWeight: FontWeight.bold,
          fontColor: Colors.white,
          fontSize: 18),
    ),
  );
}
