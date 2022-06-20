import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gantt_chart/gantt_chart.dart';
import 'package:get/get.dart';

import 'package:projectx/constants/style.dart';
import 'package:projectx/controllers/project_controller.dart';

import '../widgets/customAppBar.dart';
import '../widgets/custom_drawer.dart';

class Timeline extends StatefulWidget {
  const Timeline({Key? key}) : super(key: key);

  @override
  State<Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  final ProjectController projectController = Get.find();
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
  List<String> startDateOfTasks = [];

  tasks() {
    for (int i = 0; i < projectController.toDoTasks.length; i++) {
      startDateOfTasks.add(projectController.toDoTasks[i]['startDate']);
      tasksList.add(GanttRelativeEvent(
        relativeToStart: const Duration(days: 02),
        duration: const Duration(days: 15),
        suggestedColor: Color(secondaryColor),
        displayName: projectController.toDoTasks[i]['taskTitle'],
      ));
    }
    for (int i = 0; i < projectController.inProgressTasks.length; i++) {
      startDateOfTasks.add(projectController.toDoTasks[i]['startDate']);
      tasksList.add(GanttRelativeEvent(
        relativeToStart: const Duration(days: 03),
        duration: const Duration(days: 30),
        suggestedColor: Colors.yellowAccent,
        displayName: projectController.inProgressTasks[i]['taskTitle'],
      ));
    }
    for (int i = 0; i < projectController.completedTasks.length; i++) {
      startDateOfTasks.add(projectController.toDoTasks[i]['startDate']);
      tasksList.add(GanttRelativeEvent(
        relativeToStart: const Duration(days: 0),
        duration: const Duration(days: 5),
        suggestedColor: Colors.greenAccent,
        displayName: projectController.completedTasks[i]['taskTitle'],
      ));
    }
    print(startDateOfTasks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: customAppBar(
        context,
        title: txt(txt: 'Timeline view', fontSize: 18, fontColor: Colors.white),
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
                padding: const EdgeInsets.all(200.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: screenHeight(context) * 0.2,
                    ),
                    GanttChartView(
                      // eventRowPerWeekBuilder: (context,
                      //     eventStart,
                      //     eventEnd,
                      //     dayWidth,
                      //     weekWidth,
                      //     weekStartDate,
                      //     isHoliday,
                      //     event,
                      //     eventColor) {
                      //   return Container(
                      //     color: eventColor,
                      //     child: Center(
                      //         child: txt(
                      //             txt: '${eventStart.day}',
                      //             fontSize: 18,
                      //             fontColor: Colors.white)),
                      //   );
                      // },
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
                          color: Color(secondaryColor),
                          child: Center(
                              child: txt(
                                  txt:
                                      '${weekDate.day}/${weekDate.month}/${weekDate.year}',
                                  fontSize: 18,
                                  fontColor: Colors.white)),
                        );
                      },
                      stickyAreaWeekBuilder: (context) {
                        return Container(
                          color: Color(secondaryColor),
                          child: Center(
                              child: txt(
                                  txt: 'Project Title',
                                  fontSize: 18,
                                  fontColor: Colors.white)),
                        );
                      },
                      dayHeaderBuilder: ((context, date) {
                        return Container(
                          color: Color(secondaryColor),
                          child: Center(
                              child: txt(
                                  txt: date.weekday == 7
                                      ? 'Sun'
                                      : date.weekday == 6
                                          ? 'Sat'
                                          : date.weekday == 5
                                              ? 'Fri'
                                              : date.weekday == 4
                                                  ? 'Thur'
                                                  : date.weekday == 3
                                                      ? 'Wed'
                                                      : date.weekday == 2
                                                          ? 'Tue'
                                                          : 'Mon',
                                  fontSize: 18,
                                  fontColor: Colors.white)),
                        );
                      }),
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
                      holidayColor: Color(secondaryColor),
                      dayHeaderHeight: 80,

                      maxDuration: const Duration(days: 30 * 20),
                      startDate: DateTime.now(),
                      dayWidth: screenWidth(context) * 0.03,
                      eventHeight: 80,
                      stickyAreaWidth: screenWidth(context) * 0.1,
                      showStickyArea: true,
                      showDays: showDaysRow,
                      weekEnds: const {WeekDay.friday, WeekDay.saturday},
                      startOfTheWeek: WeekDay.sunday,
                      events: tasksList,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
