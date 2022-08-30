import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectx/controllers/profile_controller.dart';
import 'package:projectx/controllers/project_controller.dart';

import '../constants/style.dart';
import 'list_of_tasks.dart';
import 'loading_indicator.dart';

Expanded dashboardMainSection(BuildContext context, BoxConstraints constraints,
    {ProjectController? projectController,
    ProfileController? profileController}) {
  return Expanded(
    flex: 5,
    child: SizedBox(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 30, 50, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                txt(
                  txt: projectController!.project['title'],
                  fontSize: 60,
                  maxLines: 1,
                  minFontSize: 14,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 5,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        txt(
                          txt: 'LEAD :',
                          fontSize: 20,
                          minFontSize: 8,
                          overflow: TextOverflow.ellipsis,
                        ),
                        txt(
                          txt: 'CO-PILOT :',
                          fontSize: 20,
                          minFontSize: 8,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: screenWidth(context) * 0.005,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        txt(
                          txt:
                              projectController.project['lead'] == 'assign lead'
                                  ? projectController.project['lead']
                                  : '@${projectController.project['lead']} ',
                          fontSize: 20,
                          minFontSize: 8,
                          overflow: TextOverflow.ellipsis,
                        ),
                        txt(
                          txt: projectController.project['copilot'] ==
                                  'assign co-pilot'
                              ? projectController.project['copilot']
                              : '@${projectController.project['copilot']} ',
                          fontSize: 20,
                          minFontSize: 8,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: screenWidth(context) * 0.47,
              child: txt(
                txt: projectController.project['subtitle'],
                fontSize: 30,
                minFontSize: 14,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              height: screenHeight(context) * 0.05,
            ),
            // BoardSection(),
            Obx(() {
              return Expanded(
                  child: projectController.toDoTasks.isEmpty &&
                          projectController.inProgressTasks.isEmpty &&
                          projectController.completedTasks.isEmpty
                      ? Center(
                          child: txt(
                              txt: 'Added tasks will be listed here',
                              fontSize: 14),
                        )
                      : constraints.maxWidth < 1200
                          ? ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                SizedBox(
                                  width: 400,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: todoKanbanList(
                                        context, projectController),
                                  ),
                                ),
                                SizedBox(
                                  width: 400,
                                  child: inprogressKanbanList(
                                      context, projectController),
                                ),
                                SizedBox(
                                  width: 400,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: completedKanbanList(
                                        context, projectController),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: todoKanbanList(
                                        context, projectController),
                                  ),
                                ),
                                Expanded(
                                  child: inprogressKanbanList(
                                      context, projectController),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: completedKanbanList(
                                        context, projectController),
                                  ),
                                ),
                              ],
                            ));
            }),
          ],
        ),
      ),
    ),
  );
}

Column completedKanbanList(
    BuildContext context, ProjectController projectController) {
  return Column(
    children: [
      statusContainer(context, 'COMPLETED'),
      SizedBox(
        height: screenHeight(context) * 0.02,
      ),
      Container(
        height: screenHeight(context) * 0.73,
        decoration: const BoxDecoration(
          color: Color(0xfff0f2f5),
          borderRadius: BorderRadius.only(
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
                ? Center(
                    child: txt(txt: 'No task in completed list', fontSize: 14),
                  )
                : ListView.builder(
                    // shrinkWrap: true,
                    // reverse: true,
                    itemCount: projectController.completedTasks.length,

                    itemBuilder: (context, i) {
                      final String taskTitle =
                          projectController.completedTasks[i]['taskTitle'];
                      final String phase =
                          projectController.completedTasks[i]['phase'];
                      final String taskDescription = projectController
                          .completedTasks[i]['taskDescription'];
                      final String pilot =
                          projectController.completedTasks[i]['pilot'];
                      final String copilot =
                          projectController.completedTasks[i]['copilot'];
                      final String startDate =
                          projectController.completedTasks[i]['startDate'];
                      final String endDate =
                          projectController.completedTasks[i]['endDate'];

                      final int priorityLevel =
                          projectController.completedTasks[i]['priorityLevel'];
                      final String status =
                          projectController.completedTasks[i]['status'];

                      return listOfTasks(
                          context,
                          projectController,
                          'completed',
                          taskTitle,
                          phase,
                          taskDescription,
                          pilot,
                          copilot,
                          priorityLevel,
                          status,
                          startDate,
                          endDate);
                    },
                  ),
      ),
    ],
  );
}

Column inprogressKanbanList(
    BuildContext context, ProjectController projectController) {
  return Column(
    children: [
      statusContainer(context, 'INPROGRESS'),
      SizedBox(
        height: screenHeight(context) * 0.02,
      ),
      Container(
        height: screenHeight(context) * 0.73,
        decoration: const BoxDecoration(
          color: Color(0xfff0f2f5),
          borderRadius: BorderRadius.only(
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
                ? Center(
                    child: txt(txt: 'No task in progress', fontSize: 14),
                  )
                : ListView.builder(
                    // shrinkWrap: true,
                    // reverse: true,
                    itemCount: projectController.inProgressTasks.length,

                    itemBuilder: (context, i) {
                      final String taskTitle =
                          projectController.inProgressTasks[i]['taskTitle'];
                      final String phase =
                          projectController.inProgressTasks[i]['phase'];
                      final String taskDescription = projectController
                          .inProgressTasks[i]['taskDescription'];
                      final String pilot =
                          projectController.inProgressTasks[i]['pilot'];
                      final String copilot =
                          projectController.inProgressTasks[i]['copilot'];
                      final String startDate =
                          projectController.inProgressTasks[i]['startDate'];
                      final String endDate =
                          projectController.inProgressTasks[i]['endDate'];

                      final int priorityLevel =
                          projectController.inProgressTasks[i]['priorityLevel'];
                      final String status =
                          projectController.inProgressTasks[i]['status'];

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
                          status,
                          startDate,
                          endDate);
                    },
                  ),
      ),
    ],
  );
}

Column todoKanbanList(
    BuildContext context, ProjectController projectController) {
  return Column(
    children: [
      statusContainer(context, 'TODO'),
      SizedBox(
        height: screenHeight(context) * 0.02,
      ),
      Container(
        height: screenHeight(context) * 0.73,
        decoration: const BoxDecoration(
          color: Color(0xfff0f2f5),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: projectController.isTasksUpdating.isTrue ||
                projectController.isNewTasksUpdating.isTrue
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LoadingIndicator(),
                  txt(txt: 'Please wait\n Task is being updated', fontSize: 14)
                ],
              )
            : projectController.toDoTasks.isEmpty
                ? Center(
                    child: txt(txt: 'No task in Todo list', fontSize: 14),
                  )
                : ListView.builder(
                    // shrinkWrap: true,
                    // reverse: true,
                    itemCount: projectController.toDoTasks.length,

                    itemBuilder: (context, i) {
                      final String taskTitle =
                          projectController.toDoTasks[i]['taskTitle'];
                      final String phase =
                          projectController.toDoTasks[i]['phase'];
                      final String taskDescription =
                          projectController.toDoTasks[i]['taskDescription'];
                      final String pilot =
                          projectController.toDoTasks[i]['pilot'];
                      final String copilot =
                          projectController.toDoTasks[i]['copilot'];
                      final String startDate =
                          projectController.toDoTasks[i]['startDate'];
                      final String endDate =
                          projectController.toDoTasks[i]['endDate'];

                      final int priorityLevel =
                          projectController.toDoTasks[i]['priorityLevel'];
                      final String status =
                          projectController.toDoTasks[i]['status'];

                      return listOfTasks(
                          context,
                          projectController,
                          'todo',
                          taskTitle,
                          phase,
                          taskDescription,
                          pilot,
                          copilot,
                          priorityLevel,
                          status,
                          startDate,
                          endDate);
                    },
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
