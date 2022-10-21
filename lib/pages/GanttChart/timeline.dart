import 'package:ava/models/issue.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ava/constants/style.dart';
import 'package:ava/controllers/profile_controller.dart';
import 'package:ava/controllers/project_controller.dart';

import '../../controllers/gantt_chart_controller.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_drawer.dart';
import 'gantt_chart.dart';
import 'github_api.dart';

class Timeline extends StatefulWidget {
  const Timeline({Key? key}) : super(key: key);

  @override
  State<Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> with TickerProviderStateMixin {
  final ProjectController projectController = Get.find();
  final ProfileController profileController = Get.find();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  List<Issue> tasksList = [];

  @override
  void initState() {
    super.initState();

    GanttChartController.instance.initialize();
    GanttChartController.instance.gitHub = GitHubAPI();
    projectController.toDoTasks.isNotEmpty ? tasks() : Container();
    GanttChartController.instance.horizontalController.addListener(() {
      GanttChartController.instance.lastHorizontalPos =
          GanttChartController.instance.horizontalController.position.pixels;
    });
    GanttChartController.instance.chartController.addListener(() {
      GanttChartController.instance.lastVerticalPos =
          GanttChartController.instance.chartController.position.pixels;
    });
  }

  tasks() {
    for (int i = 0; i < projectController.toDoTasks.length; i++) {
      //start date
      String startDate = projectController.toDoTasks[i]['startDate'];
      String taskID = projectController.toDoTasks[i]['taskID'];

      List<String> startDateSplitted = startDate.split('/');
      String startDateYear = startDateSplitted[0];

      String startDateMonth = startDateSplitted[1].length == 1
          ? '0${startDateSplitted[1]}'
          : startDateSplitted[1];
      String startDateDay = startDateSplitted[2].length == 1
          ? '0${startDateSplitted[2]}'
          : startDateSplitted[2];

      DateTime parsedStartDate =
          DateTime.parse('$startDateYear$startDateMonth$startDateDay');

      //end date
      String endDate = projectController.toDoTasks[i]['endDate'];

      List<String> endDateSplitted = endDate.split('/');
      String endDateYear = startDateSplitted[0];

      String endDateMonth = endDateSplitted[1].length == 1
          ? '0${endDateSplitted[1]}'
          : endDateSplitted[1];
      String endDateDay = endDateSplitted[2].length == 1
          ? '0${endDateSplitted[2]}'
          : endDateSplitted[2];

      DateTime parsedEndDate =
          DateTime.parse('$endDateYear$endDateMonth$endDateDay');

      tasksList.add(
        Issue(
            id: taskID,
            startTime: parsedStartDate,
            endTime: parsedEndDate,
            number: 1,
            title: projectController.toDoTasks[i]['taskTitle']),
      );
    }
    for (int i = 0; i < projectController.inProgressTasks.length; i++) {
      //start date
      String startDate = projectController.inProgressTasks[i]['startDate'];
      String taskID = projectController.inProgressTasks[i]['taskID'];

      List<String> startDateSplitted = startDate.split('/');
      String startDateYear = startDateSplitted[0];

      String startDateMonth = startDateSplitted[1].length == 1
          ? '0${startDateSplitted[1]}'
          : startDateSplitted[1];
      String startDateDay = startDateSplitted[2].length == 1
          ? '0${startDateSplitted[2]}'
          : startDateSplitted[2];

      DateTime parsedStartDate =
          DateTime.parse('$startDateYear$startDateMonth$startDateDay');

      //end date
      String endDate = projectController.inProgressTasks[i]['endDate'];

      List<String> endDateSplitted = endDate.split('/');
      String endDateYear = startDateSplitted[0];

      String endDateMonth = endDateSplitted[1].length == 1
          ? '0${endDateSplitted[1]}'
          : endDateSplitted[1];
      String endDateDay = endDateSplitted[2].length == 1
          ? '0${endDateSplitted[2]}'
          : endDateSplitted[2];

      DateTime parsedEndDate =
          DateTime.parse('$endDateYear$endDateMonth$endDateDay');

      tasksList.add(Issue(
          id: taskID,
          startTime: parsedStartDate,
          endTime: parsedEndDate,
          number: 2,
          title: projectController.toDoTasks[i]['taskTitle']));
    }
    for (int i = 0; i < projectController.completedTasks.length; i++) {
      //start date
      String startDate = projectController.completedTasks[i]['startDate'];
      String taskID = projectController.completedTasks[i]['taskID'];

      List<String> startDateSplitted = startDate.split('/');
      String startDateYear = startDateSplitted[0];

      String startDateMonth = startDateSplitted[1].length == 1
          ? '0${startDateSplitted[1]}'
          : startDateSplitted[1];
      String startDateDay = startDateSplitted[2].length == 1
          ? '0${startDateSplitted[2]}'
          : startDateSplitted[2];

      DateTime parsedStartDate =
          DateTime.parse('$startDateYear$startDateMonth$startDateDay');

      //end date
      String endDate = projectController.completedTasks[i]['endDate'];

      List<String> endDateSplitted = endDate.split('/');
      String endDateYear = startDateSplitted[0];

      String endDateMonth = endDateSplitted[1].length == 1
          ? '0${endDateSplitted[1]}'
          : endDateSplitted[1];
      String endDateDay = endDateSplitted[2].length == 1
          ? '0${endDateSplitted[2]}'
          : endDateSplitted[2];

      DateTime parsedEndDate =
          DateTime.parse('$endDateYear$endDateMonth$endDateDay');

      tasksList.add(Issue(
          id: taskID,
          startTime: parsedStartDate,
          endTime: parsedEndDate,
          number: 3,
          title: projectController.toDoTasks[i]['taskTitle']));
    }

    GanttChartController.instance.gitHub!.getIssuesList(issuesList: tasksList);
  }

  @override
  void dispose() {
    GanttChartController.instance.focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (GanttChartController.instance.rootContext == null) {
      GanttChartController.instance.setContext(context, 520);
    }

    if (MediaQuery.of(context).size.width <
        GanttChartController.instance.issuesListWidth) {
      GanttChartController.instance
          .setContext(context, MediaQuery.of(context).size.width);
    }

    return WillPopScope(onWillPop: () async {
      projectController.getProjectTasks();

      return Future(() => true);
    }, child: Obx(() {
      return Scaffold(
        key: _key,
        backgroundColor: Colors.black87.withOpacity(0.8),
        appBar: customAppBar(
          context,
          username: profileController.user['name'],
          shouldRefreshTasks: true,
          title: txt(
              txt: 'Timeline view',
              fontSize: 18,
              fontWeight: FontWeight.w400,
              letterSpacing: 3,
              fontColor: Colors.white),
        ),
        endDrawer: const EndDrawerWidget(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 16, 30, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  txt(
                      txt: 'GANTT',
                      font: 'comfortaa',
                      fontSize: 30,
                      letterSpacing: 5,
                      fontWeight: FontWeight.w100,
                      fontColor: Colors.white),
                  Row(
                    children: [
                      txt(
                          txt:
                              projectController.project['title'] + ' ' + '2022',
                          font: 'comfortaa',
                          fontSize: 25,
                          letterSpacing: 5,
                          fontWeight: FontWeight.w200,
                          fontColor: Colors.white),
                      const SizedBox(
                        height: 10,
                      ),
                      txt(
                          txt: '-  ${projectController.project['subtitle']} ',
                          font: 'comfortaa',
                          fontSize: 20,
                          fontWeight: FontWeight.w200,
                          letterSpacing: 5,
                          fontColor: Colors.white),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: tasksList.isEmpty
                  ? Center(
                      child: txt(
                          fontColor: Colors.white,
                          txt:
                              'There is currently no timeline view for the tasks,\n Please make new tasks to see thier chart view',
                          fontSize: 24),
                    )
                  : GanttChart(
                      GanttChartController.instance.issueList!,
                      context,
                    ),
            ),
          ],
        ),
      );
    }));
  }
}
