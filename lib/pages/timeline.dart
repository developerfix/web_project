import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gantt_chart/gantt_chart.dart';
import 'package:get/get.dart';

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
          suggestedColor: const Color(secondaryColor),
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
          suggestedColor: Colors.yellowAccent,
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
          suggestedColor: Colors.greenAccent,
          displayName: projectController.completedTasks[i]['taskTitle'],
        ),
      );
    }
    print(startDateOfTasks);
    print(endDateOfTasks);
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

    print(startDateOfTasks);
    print(endDateOfTasks);

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
        backgroundColor: Color(darkgreyishColor),
        key: _key,
        appBar: customAppBar(
          context,
          color: Color(darkgreyishColor),
          username: profileController.user['name'],
          title:
              txt(txt: 'Timeline view', fontSize: 18, fontColor: Colors.white),
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          txt(
                              txt: 'GANTT',
                              fontSize: 40,
                              letterSpacing: 5,
                              fontColor: Colors.white)
                        ],
                      ),
                      SizedBox(
                        height: screenHeight(context) * 0.1,
                      ),
                      GanttChartView(
                        stickyAreaEventBuilder:
                            (context, eventIndex, event, eventColor) {
                          return Container(
                            color: Color(secondaryColor),
                            child: Center(
                                child: txt(
                                    txt: event.displayName!,
                                    fontSize: 18,
                                    fontColor: Colors.white)),
                          );
                        },

                        weekHeaderBuilder: (context, weekDate) {
                          return Container(
                            color: Color(darkgreyishColor),
                            child: Center(
                                child: txt(
                                    txt:
                                        '${weekDate.day}/${weekDate.month}/${weekDate.year}',
                                    fontSize: 18,
                                    fontColor: Colors.white)),
                          );
                        },
                        // stickyAreaWeekBuilder: (context) {
                        //   return Container(
                        //     color: Color(secondaryColor),
                        //     child: Center(
                        //         child: txt(
                        //             txt: projectController.project['title'],
                        //             fontSize: 18,
                        //             fontColor: Colors.white)),
                        //   );
                        // },
                        // dayHeaderBuilder: ((context, date) {
                        //   return Container(
                        //     color: Color(secondaryColor),
                        //     child: Center(
                        //         child: txt(
                        //             txt: date.weekday == 7
                        //                 ? 'Sun'
                        //                 : date.weekday == 6
                        //                     ? 'Sat'
                        //                     : date.weekday == 5
                        //                         ? 'Fri'
                        //                         : date.weekday == 4
                        //                             ? 'Thur'
                        //                             : date.weekday == 3
                        //                                 ? 'Wed'
                        //                                 : date.weekday == 2
                        //                                     ? 'Tue'
                        //                                     : 'Mon',
                        //             fontSize: 18,
                        //             fontColor: Colors.white)),
                        //   );
                        // }),
                        stickyAreaDayBuilder: (context) {
                          return Container(
                            color: Color(secondaryColor),
                            child: Center(
                                child: txt(
                                    txt: 'Tasks',
                                    fontSize: 18,
                                    fontColor: Colors.white)),
                          );
                        },
                        holidayColor: Colors.grey.shade500,

                        dayHeaderHeight: screenHeight(context) * 0.05,
                        // maxDuration:
                        //     Duration(days: differenceInDays.inDays + 7),
                        maxDuration: Duration(days: 365),
                        startDate: DateTime(startDateOfTasks[0].year,
                            startDateOfTasks[0].month, startDateOfTasks[0].day),
                        dayWidth: screenWidth(context) * 0.03,
                        eventHeight: screenHeight(context) * 0.1,
                        stickyAreaWidth: screenWidth(context) * 0.1,
                        showStickyArea: true,
                        showDays: false,
                        weekEnds: const {WeekDay.friday, WeekDay.saturday},
                        startOfTheWeek: WeekDay.sunday,
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
