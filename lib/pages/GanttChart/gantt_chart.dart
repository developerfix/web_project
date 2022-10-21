//Only on web
//import 'dart:html';
import 'package:ava/constants/style.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../controllers/gantt_chart_controller.dart';
import '../../models/issue.dart';
import 'chart_bars.dart';
import 'chart_grid.dart';
import 'chart_header.dart';

class GanttChart extends StatefulWidget {
  final List<Issue> userData;
  final BuildContext context;

  const GanttChart(this.userData, this.context, {Key? key}) : super(key: key);

  @override
  State<GanttChart> createState() => _GanttChartState();
}

class _GanttChartState extends State<GanttChart> {
  @override
  Widget build(BuildContext context) {
    GanttChartController.instance.nodeAttachment.reparent();
    //Only on web
    //document.onContextMenu.listen((event) => event.preventDefault());

    return ChangeNotifierProvider<GanttChartController>.value(
      value: GanttChartController.instance,
      child: Consumer<GanttChartController>(
          builder: (ganttChartContext, ganttChartValue, child) {
        widget.userData.sort((a, b) {
          int startOrder = a.startTime!.compareTo(b.startTime!);

          if (startOrder == 0) {
            startOrder = a.endTime!.compareTo(b.endTime!);

            if (startOrder == 0) {
              if (startOrder == 0) {
                return a.number!.compareTo(b.number!);
              } else {
                return startOrder;
              }
            } else {
              return startOrder;
            }
          } else {
            return startOrder;
          }
        });

        return SizedBox(
          width: MediaQuery.of(ganttChartContext).size.width,
          child: Row(
            children: [
              SizedBox(
                width: ganttChartValue.issuesListWidth,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                              height: 60.0,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Center(
                                  child: txt(
                                      txt: 'Tasks',
                                      fontSize: 24.0,
                                      fontColor: Colors.white))),
                          Expanded(
                            child: ListView.builder(
                              controller: ganttChartValue.listController,
                              scrollDirection: Axis.vertical,
                              itemCount: widget.userData.length,
                              itemBuilder: (context, index) {
                                return ChangeNotifierProvider<Issue>.value(
                                  value: widget.userData[index],
                                  child: Consumer<Issue>(builder:
                                      (issuesContext, issuesValue, child) {
                                    return GestureDetector(
                                      onTap: () async {
                                        ganttChartValue.horizontalController.animateTo(
                                            GanttChartController.instance
                                                        .calculateDistanceToLeftBorder(
                                                            issuesValue
                                                                .startTime!) *
                                                    GanttChartController
                                                        .instance
                                                        .chartViewWidth /
                                                    GanttChartController
                                                        .instance
                                                        .viewRangeToFitScreen! +
                                                (GanttChartController.instance
                                                            .isPanStartActive ||
                                                        GanttChartController
                                                            .instance
                                                            .isPanMiddleActive
                                                    ? issuesValue.width
                                                    : 0),
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.bounceInOut);

                                        ganttChartValue.issueSelect(
                                            issuesValue, widget.userData);
                                      },
                                      child: Listener(
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: index == 0 ? 4.0 : 2.0,
                                              bottom: index ==
                                                      widget.userData.length - 1
                                                  ? 4.0
                                                  : 2.0),
                                          height: 30,
                                          decoration: BoxDecoration(
                                              color: issuesValue.startTime!.compareTo(DateFormat('yyyy/MM/dd').parse(DateFormat('yyyy/MM/dd').format(DateTime.now()))) < 0 &&
                                                      issuesValue.endTime!.compareTo(
                                                              DateFormat('yyyy/MM/dd').parse(
                                                                  DateFormat('yyyy/MM/dd')
                                                                      .format(DateTime
                                                                          .now()))) <
                                                          0
                                                  ? Colors.purple.withAlpha(100)
                                                  : Colors.red.withAlpha(100),
                                              border: issuesValue.selected
                                                  ? Border.all(
                                                      color: Colors.yellow,
                                                      width: 1,
                                                    )
                                                  : Border.symmetric(
                                                      horizontal: BorderSide(
                                                          color: Colors.grey
                                                              .withAlpha(100),
                                                          width: 1.0))),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Center(
                                              child: txt(
                                                  txt: issuesValue.title!,
                                                  fontSize: 14,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontColor: Colors.white)),
                                        ),
                                      ),
                                    );
                                  }),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onPanUpdate: (details) {
                        ganttChartValue.issuesListWidth +=
                            details.globalPosition.dx -
                                ganttChartValue.issuesListWidth;

                        if (ganttChartValue.issuesListWidth >
                            MediaQuery.of(ganttChartContext).size.width) {
                          ganttChartValue.issuesListWidth =
                              MediaQuery.of(ganttChartContext).size.width;
                        }

                        if (ganttChartValue.issuesListWidth < 20) {
                          ganttChartValue.issuesListWidth = 20;
                        }
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              width: 20,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                color: Colors.grey,
                              )),
                              child: IconButton(
                                onPressed: () {
                                  ganttChartValue.issuesListWidth = 20;
                                },
                                padding: const EdgeInsets.all(0),
                                icon: const Center(
                                  child: Icon(
                                    Icons.keyboard_arrow_left_rounded,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                                iconSize: 15,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: 20,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                color: Colors.grey,
                              )),
                              child: IconButton(
                                onPressed: () {
                                  ganttChartValue.issuesListWidth =
                                      MediaQuery.of(ganttChartContext)
                                          .size
                                          .width;
                                },
                                padding: const EdgeInsets.all(0),
                                icon: const Icon(
                                  Icons.keyboard_arrow_right_rounded,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                iconSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ganttChartValue.removeIssueSelection();
                  },
                  onScaleStart: (details) {
                    GanttChartController.instance.viewRangeOnScale =
                        GanttChartController.instance.viewRangeToFitScreen;
                  },
                  onScaleUpdate: (details) {
                    if (GanttChartController.instance.viewRangeToFitScreen! >
                            1 ||
                        details.scale < 1) {
                      double percent = GanttChartController
                              .instance.horizontalController.position.pixels *
                          100 /
                          (GanttChartController.instance.chartViewWidth /
                              GanttChartController
                                  .instance.viewRangeToFitScreen! *
                              GanttChartController.instance.viewRange!.length);
                      GanttChartController.instance.viewRangeToFitScreen =
                          (GanttChartController.instance.viewRangeOnScale! ~/
                                  details.scale)
                              .toInt();

                      if (details.scale > 1) {
                        GanttChartController.instance.horizontalController
                            .jumpTo(
                                GanttChartController.instance.chartViewWidth /
                                    GanttChartController
                                        .instance.viewRangeToFitScreen! *
                                    GanttChartController
                                        .instance.viewRange!.length *
                                    percent /
                                    100);
                        GanttChartController.instance.chartController.jumpTo(
                            GanttChartController
                                .instance.chartController.position.pixels);
                      } else {
                        GanttChartController.instance.horizontalController
                            .jumpTo(
                                GanttChartController.instance.chartViewWidth /
                                    GanttChartController
                                        .instance.viewRangeToFitScreen! *
                                    GanttChartController
                                        .instance.viewRange!.length *
                                    percent /
                                    100);
                        GanttChartController.instance.chartController.jumpTo(
                            GanttChartController
                                .instance.chartController.position.pixels);
                      }

                      GanttChartController.instance.update();
                    }
                  },
                  child: LayoutBuilder(builder: (chartContext, constraints) {
                    ScrollController newController = ScrollController(
                      initialScrollOffset: GanttChartController.instance
                                  .calculateDistanceToLeftBorder(
                                      GanttChartController.instance.issueList!
                                          .first.startTime!) *
                              GanttChartController.instance.chartViewWidth /
                              GanttChartController
                                  .instance.viewRangeToFitScreen! +
                          (GanttChartController.instance.isPanStartActive ||
                                  GanttChartController
                                      .instance.isPanMiddleActive
                              ? GanttChartController
                                  .instance.issueList!.first.width
                              : 0),
                    );
                    ganttChartValue.horizontalController = newController;
                    return ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                          dragDevices: {
                            PointerDeviceKind.touch,
                            PointerDeviceKind.mouse,
                          },
                        ),
                        child: ListView(
                            controller: ganttChartValue.horizontalController,
                            scrollDirection: Axis.horizontal,
                            physics: ganttChartValue.isPanStartActive ||
                                    ganttChartValue.isPanEndActive ||
                                    ganttChartValue.isPanMiddleActive
                                ? const NeverScrollableScrollPhysics()
                                : const ClampingScrollPhysics(),
                            children: [
                              Column(
                                children: [
                                  const ChartHeader(),
                                  Expanded(
                                    child: SizedBox(
                                      width: ganttChartValue
                                              .calculateNumberOfDaysBetween(
                                                  ganttChartValue.fromDate!,
                                                  ganttChartValue.toDate!)
                                              .length *
                                          ganttChartValue.chartViewWidth /
                                          ganttChartValue.viewRangeToFitScreen!,
                                      child: Listener(
                                        onPointerSignal: (pointerSignal) {
                                          if (pointerSignal
                                                  is PointerScrollEvent &&
                                              ganttChartValue.isAltPressed) {
                                            if (ganttChartValue
                                                        .viewRangeToFitScreen! >
                                                    1 ||
                                                pointerSignal
                                                        .scrollDelta.dy.sign >
                                                    0) {
                                              double percent = ganttChartValue
                                                      .horizontalController
                                                      .position
                                                      .pixels *
                                                  100 /
                                                  (ganttChartValue
                                                          .chartViewWidth /
                                                      ganttChartValue
                                                          .viewRangeToFitScreen! *
                                                      ganttChartValue
                                                          .viewRange!.length);
                                              ganttChartValue
                                                      .viewRangeToFitScreen =
                                                  ganttChartValue
                                                          .viewRangeToFitScreen! +
                                                      pointerSignal
                                                          .scrollDelta.dy.sign
                                                          .toInt();

                                              if (pointerSignal
                                                      .scrollDelta.dy.sign <
                                                  0) {
                                                ganttChartValue
                                                    .horizontalController
                                                    .jumpTo(ganttChartValue.chartViewWidth /
                                                            ganttChartValue
                                                                .viewRangeToFitScreen! *
                                                            ganttChartValue
                                                                .viewRange!
                                                                .length *
                                                            percent /
                                                            100 +
                                                        pointerSignal.position
                                                                .dx.sign *
                                                            ganttChartValue
                                                                .chartViewWidth /
                                                            ganttChartValue
                                                                .viewRangeToFitScreen! /
                                                            2);
                                                ganttChartValue.chartController
                                                    .jumpTo(ganttChartValue
                                                        .chartController
                                                        .position
                                                        .pixels);
                                              } else {
                                                ganttChartValue
                                                    .horizontalController
                                                    .jumpTo(ganttChartValue.chartViewWidth /
                                                            ganttChartValue
                                                                .viewRangeToFitScreen! *
                                                            ganttChartValue
                                                                .viewRange!
                                                                .length *
                                                            percent /
                                                            100 -
                                                        pointerSignal.position
                                                                .dx.sign *
                                                            ganttChartValue
                                                                .chartViewWidth /
                                                            ganttChartValue
                                                                .viewRangeToFitScreen! /
                                                            2);
                                                ganttChartValue.chartController
                                                    .jumpTo(ganttChartValue
                                                        .chartController
                                                        .position
                                                        .pixels);
                                              }

                                              ganttChartValue.update();
                                            }
                                          }
                                        },
                                        onPointerMove: (event) async =>
                                            GanttChartController.instance
                                                .onPointerDownTime = null,
                                        child: Stack(
                                          fit: StackFit.loose,
                                          children: <Widget>[
                                            const ChartGrid(),
                                            ChartBars(
                                              gantChartController:
                                                  ganttChartValue,
                                              constraints: constraints,
                                              data: widget.userData,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ]));
                  }),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
