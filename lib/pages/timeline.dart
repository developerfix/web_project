import 'package:flutter/material.dart';
import 'package:gantt_chart/gantt_chart.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projectx/constants/style.dart';
import 'package:projectx/controllers/profile_controller.dart';
import 'package:projectx/controllers/project_controller.dart';

import '../widgets/custom_appbar.dart';
import '../widgets/custom_drawer.dart';

class Timeline extends StatefulWidget {
  const Timeline({Key? key}) : super(key: key);

  @override
  State<Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  final ProjectController projectController = Get.find();
  final ProfileController profileController = Get.find();
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  double dayWidth = 30;
  bool showDaysRow = true;
  bool showStickyArea = true;

  @override
  void initState() {
    super.initState();
    tasks();
  }

  List<GanttEventBase> tasksList = [];
  List<DateTime> startDateOfTasks = [];
  List<DateTime> endDateOfTasks = [];
  late Duration differenceInDays;

  tasks() {
    for (int i = 0; i < projectController.toDoTasks.length; i++) {
      //start date
      String startDate = projectController.toDoTasks[i]['startDate'];

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

// adding into the list
      startDateOfTasks.add(parsedStartDate);
      endDateOfTasks.add(parsedEndDate);

      tasksList.add(
        GanttAbsoluteEvent(
          startDate: parsedStartDate,
          endDate: parsedEndDate,
          displayName: projectController.toDoTasks[i]['taskTitle'],
        ),
      );
    }
    for (int i = 0; i < projectController.inProgressTasks.length; i++) {
      //start date
      String startDate = projectController.inProgressTasks[i]['startDate'];

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

// adding into the list
      startDateOfTasks.add(parsedStartDate);
      endDateOfTasks.add(parsedEndDate);

      tasksList.add(
        GanttAbsoluteEvent(
          startDate: parsedStartDate,
          endDate: parsedEndDate,
          displayName: projectController.inProgressTasks[i]['taskTitle'],
        ),
      );
    }
    for (int i = 0; i < projectController.completedTasks.length; i++) {
      //start date
      String startDate = projectController.completedTasks[i]['startDate'];

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

// adding into the list
      startDateOfTasks.add(parsedStartDate);
      endDateOfTasks.add(parsedEndDate);

      tasksList.add(
        GanttAbsoluteEvent(
          startDate: parsedStartDate,
          endDate: parsedEndDate,
          displayName: projectController.completedTasks[i]['taskTitle'],
        ),
      );
    }

    startDateOfTasks.sort((a, b) {
      //sorting in ascending order
      return DateTime.parse(a.toString())
          .compareTo(DateTime.parse(b.toString()));
    });
    endDateOfTasks.sort((a, b) {
      //sorting in ascending order
      return DateTime.parse(a.toString())
          .compareTo(DateTime.parse(b.toString()));
    });

    differenceInDays = DateTime(endDateOfTasks.last.year,
            endDateOfTasks.last.month, endDateOfTasks.last.day)
        .difference(DateTime(startDateOfTasks.first.year,
            startDateOfTasks.first.month, startDateOfTasks.first.day));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        // backgroundColor: Colors.grey.shade300,
        backgroundColor: const Color(darkgreyishColor),
        key: _key,
        appBar: customAppBar(
          context,
          color: const Color(darkgreyishColor),
          username: profileController.user['name'],
          title: txt(
              txt: 'Timeline view',
              fontSize: 18,
              fontWeight: FontWeight.w400,
              letterSpacing: 3,
              fontColor: Colors.white),
        ),
        endDrawer: const EndDrawerWidget(),
        body: tasksList.isEmpty
            ? Center(
                child: txt(
                    txt:
                        'There is currently no timeline view for the tasks,\n Please make new task to see thier chart view',
                    fontSize: 24),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(100, 100, 200, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          txt(
                              txt: 'GANTT',
                              font: 'comfortaa',
                              fontSize: 54,
                              letterSpacing: 5,
                              fontWeight: FontWeight.w100,
                              fontColor: Colors.white),
                          Column(
                            children: [
                              txt(
                                  txt: projectController.project['title'] +
                                      ' ' +
                                      '2022',
                                  font: 'comfortaa',
                                  fontSize: 30,
                                  letterSpacing: 5,
                                  fontWeight: FontWeight.w200,
                                  fontColor: Colors.white),
                              const SizedBox(
                                height: 10,
                              ),
                              txt(
                                  txt: projectController.project['subtitle'],
                                  font: 'comfortaa',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w200,
                                  letterSpacing: 5,
                                  fontColor: Colors.white),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: screenHeight(context) * 0.1,
                      ),
                      GanttChartView(
                        stickyAreaEventBuilder: (context, eventIndex, event) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                event.getDisplayName(context).toUpperCase(),
                                style: GoogleFonts.comfortaa(
                                  textStyle: const TextStyle(
                                    fontSize: 12.0,
                                    overflow: TextOverflow.visible,
                                    letterSpacing: 0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        dayHeaderHeight: screenHeight(context) * 0.05,

                        // maxDuration:
                        //     Duration(days: differenceInDays.inDays + 7),
                        maxDuration: const Duration(days: 365),
                        startDate: DateTime(startDateOfTasks[0].year,
                            startDateOfTasks[0].month, startDateOfTasks[0].day),

                        eventHeight: screenHeight(context) * 0.1,
                        stickyAreaWidth: screenWidth(context) * 0.1,
                        showStickyArea: true,

                        showDays: true,

                        events: tasksList,
                      ),
                    ],
                  ),
                ),
              ),
      );
    });
  }
}
