import 'dart:math';
import 'package:ava/constants/style.dart';
import 'package:ava/controllers/project_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import '../models/issue.dart';
import '../pages/GanttChart/github_api.dart';

enum PanType {
  start,
  middle,
  end,
}

class GanttChartController extends ChangeNotifier {
  double _issuesListWidth = 520;
  int? viewRangeOnScale = 0;
  int? viewRangeToFitScreen = 22;
  List<DateTime>? viewRange;
  Color? userColor;
  double initX = 0;
  double initY = 0;
  double dx = 0;
  double dy = 0;
  bool isPanStartActive = false;
  bool isPanMiddleActive = false;
  bool isPanEndActive = false;
  ScrollController gridHorizontalController = ScrollController();
  GitHubAPI? gitHub;
  LinkedScrollControllerGroup controllers = LinkedScrollControllerGroup();
  ScrollController horizontalController = ScrollController();
  List<Issue?> selectedIssues = [];
  double lastScrollPos = 0;
  double chartViewWidth = 1200;
  bool isAltPressed = false;
  bool isShiftPressed = false;
  bool isCtrlPressed = false;
  ScrollController chartController = ScrollController();
  ScrollController listController = ScrollController();
  BuildContext? rootContext;
  late FocusNode focus;
  late FocusAttachment nodeAttachment;
  DateTime? fromDate;
  DateTime? toDate;
  double detailsValue = 0;
  SharedPreferences? prefs;
  Future<List<Issue>>? issueListFuture;
  List<Issue>? issueList;
  double lastVerticalPos = 0;
  double lastHorizontalPos = 0;
  // Ao tocar com botão direito na grid, se for espaço vazio seta -1
  // senão seta o indice da issue abaixo do ponteiro/toque
  int contextIssueIndex = -1;
  DateTime? onPointerDownTime;

  // torna esta classe singleton
  GanttChartController._privateConstructor();
  static final GanttChartController instance =
      GanttChartController._privateConstructor();

  Color randomColorGenerator() {
    Random? r = Random();
    return Color.fromRGBO(r.nextInt(256), r.nextInt(256), r.nextInt(256), 0.75);
  }

  void rememberScrollPositions() {
    try {
      GanttChartController.instance.horizontalController
          .jumpTo(GanttChartController.instance.lastHorizontalPos);
      GanttChartController.instance.chartController
          .jumpTo(GanttChartController.instance.lastVerticalPos);
    } catch (e) {
      Future.delayed(
          const Duration(milliseconds: 100), rememberScrollPositions);
    }
  }

  double get issuesListWidth => _issuesListWidth;
  set issuesListWidth(double value) {
    _issuesListWidth = value;
    update();
  }

  List<DateTime> calculateNumberOfDaysBetween(DateTime from, DateTime to) {
    List<DateTime> period = [];
    DateTime currentDate = from;

    do {
      period.add(currentDate);
      currentDate = currentDate.add(const Duration(days: 1));
    } while (currentDate.compareTo(to) <= 0);

    return period;
  }

  int calculateRemainingWidth(
      DateTime projectStartedAt, DateTime projectEndedAt) {
    int projectLength =
        calculateNumberOfDaysBetween(projectStartedAt, projectEndedAt).length;
    if (projectStartedAt.compareTo(fromDate!) >= 0 &&
        projectStartedAt.compareTo(toDate!) <= 0) {
      if (projectLength <= viewRange!.length) {
        return projectLength;
      } else {
        return viewRange!.length -
            calculateNumberOfDaysBetween(fromDate!, projectStartedAt).length;
      }
    } else if (projectStartedAt.isBefore(fromDate!) &&
        projectEndedAt.isBefore(fromDate!)) {
      return 0;
    } else if (projectStartedAt.isBefore(fromDate!) &&
        projectEndedAt.isBefore(toDate!)) {
      return projectLength -
          calculateNumberOfDaysBetween(projectStartedAt, fromDate!).length;
    } else if (projectStartedAt.isBefore(instance.fromDate!) &&
        projectEndedAt.isAfter(toDate!)) {
      return viewRange!.length;
    }
    return 0;
  }

  int calculateDistanceToLeftBorder(DateTime projectStartedAt) {
    if (projectStartedAt.compareTo(fromDate!) <= 0) {
      return 0;
    } else {
      return calculateNumberOfDaysBetween(fromDate!, projectStartedAt).length -
          1;
    }
  }

  int calculateDistanceToRightBorder(DateTime projectEndedAt) {
    if (projectEndedAt.compareTo(toDate!) > 0) {
      return 0;
    } else {
      return calculateNumberOfDaysBetween(projectEndedAt, toDate!).length - 1;
    }
  }

  void onScrollChange() {
    for (int i = 0; i < selectedIssues.length; i++) {
      bool overLimits = false;
      bool underLimits = false;

      if (selectedIssues[i]!.dragPosFactor.abs() >= 0.4 &&
          selectedIssues[i] != null) {
        if (isPanStartActive ||
            (isPanMiddleActive && selectedIssues[i]!.dragPosFactor.sign < 0)) {
          //Verifica se não tem perídodo menor do que 1 dia
          overLimits = selectedIssues[i]!.draggingRemainingWidth! *
                      chartViewWidth /
                      viewRangeToFitScreen! +
                  selectedIssues[i]!.width +
                  (horizontalController.position.pixels - lastScrollPos) >=
              chartViewWidth / viewRangeToFitScreen!;
          underLimits =
              calculateDistanceToLeftBorder(selectedIssues[i]!.startTime!) *
                          chartViewWidth /
                          viewRangeToFitScreen! +
                      selectedIssues[i]!.width +
                      (horizontalController.position.pixels - lastScrollPos) <=
                  horizontalController.position.pixels;
        }

        if (isPanEndActive ||
            (isPanMiddleActive && selectedIssues[i]!.dragPosFactor.sign > 0)) {
          overLimits = overLimits ||
              selectedIssues[i]!.draggingRemainingWidth! *
                          chartViewWidth /
                          viewRangeToFitScreen! +
                      selectedIssues[i]!.width +
                      (horizontalController.position.pixels - lastScrollPos) <=
                  chartViewWidth / viewRangeToFitScreen!;
          overLimits = overLimits ||
              selectedIssues[i]!.draggingRemainingWidth! *
                      chartViewWidth /
                      viewRangeToFitScreen! >=
                  viewRange!.length * chartViewWidth / viewRangeToFitScreen!;
          overLimits = overLimits ||
              calculateDistanceToRightBorder(selectedIssues[i]!.endTime!) *
                          chartViewWidth /
                          viewRangeToFitScreen! -
                      selectedIssues[i]!.width -
                      (horizontalController.position.pixels - lastScrollPos) <=
                  0;
          underLimits = underLimits ||
              calculateDistanceToLeftBorder(selectedIssues[i]!.startTime!) *
                          chartViewWidth /
                          viewRangeToFitScreen! +
                      selectedIssues[i]!.width +
                      (horizontalController.position.pixels - lastScrollPos) +
                      (selectedIssues[i]!.draggingRemainingWidth! *
                          chartViewWidth /
                          viewRangeToFitScreen!) <=
                  horizontalController.position.pixels;
        }

        if (overLimits && !underLimits) {
          selectedIssues[i]!.dragPosFactor = 0;
          selectedIssues[i]!.width =
              (calculateDistanceToRightBorder(selectedIssues[i]!.endTime!)) *
                  chartViewWidth /
                  viewRangeToFitScreen!;
        } else if (underLimits && !overLimits) {
          selectedIssues[i]!.width =
              -(calculateDistanceToLeftBorder(selectedIssues[i]!.startTime!) *
                      chartViewWidth /
                      viewRangeToFitScreen! -
                  horizontalController.position.pixels);
        } else if (!underLimits && !overLimits) {
          selectedIssues[i]!.width +=
              horizontalController.position.pixels - lastScrollPos;
        }
      }
    }

    lastScrollPos = horizontalController.position.pixels;
  }

  initialize() {
    focus = FocusNode(debugLabel: 'Button');
    focus.requestFocus();
    chartController = controllers.addAndGet();
    listController = controllers.addAndGet();
    userColor = randomColorGenerator();
    GanttChartController.instance.horizontalController
        .removeListener(onScrollChange);
    horizontalController.addListener(onScrollChange);
  }

  setContext(BuildContext context, double issueListFutureWidth) {
    rootContext = context;
    _issuesListWidth = issueListFutureWidth;

    nodeAttachment = focus.attach(context, onKey: (node, event) {
      if (isAltPressed != event.isAltPressed) isAltPressed = event.isAltPressed;

      if (isShiftPressed != event.isShiftPressed) {
        isShiftPressed = event.isShiftPressed;
      }

      if (isCtrlPressed != event.isControlPressed) {
        isCtrlPressed = event.isControlPressed;
      }

      update();
      return KeyEventResult.handled;
    });
  }

  void update() {
    notifyListeners();
  }

  void onIssueStartUpdate(
      BuildContext context, DragUpdateDetails details, double chartAreaWidth) {
    detailsValue = details.globalPosition.dx;

    for (int j = 0; j < selectedIssues.length; j++) {
      if (selectedIssues[j]!.remainingWidth! *
                  chartViewWidth /
                  viewRangeToFitScreen! -
              (details.globalPosition.dx -
                  initX -
                  (selectedIssues[j]!.startPanChartPos -
                      horizontalController.position.pixels)) >=
          chartViewWidth / viewRangeToFitScreen!) {
        if (calculateDistanceToLeftBorder(selectedIssues[j]!.startTime!) *
                    chartViewWidth /
                    viewRangeToFitScreen! +
                (details.globalPosition.dx -
                    initX -
                    (selectedIssues[j]!.startPanChartPos -
                        horizontalController.position.pixels)) >
            0) {
          selectedIssues[j]!.width = details.globalPosition.dx -
              initX -
              (selectedIssues[j]!.startPanChartPos -
                  horizontalController.position.pixels);
          selectedIssues[j]!.dragPosFactor = (details.globalPosition.dx -
                      (MediaQuery.of(context).size.width - chartAreaWidth)) /
                  chartAreaWidth -
              0.5;
        } else {
          return;
        }
      } else {
        selectedIssues[j]!.width = (selectedIssues[j]!.remainingWidth! - 1) *
            chartViewWidth /
            viewRangeToFitScreen!;
      }
    }
  }

  void onIssueEndUpdate(
      BuildContext context, DragUpdateDetails details, double chartAreaWidth) {
    for (int j = 0; j < selectedIssues.length; j++) {
      if (selectedIssues[j]!.remainingWidth! *
                  chartViewWidth /
                  viewRangeToFitScreen! +
              (details.globalPosition.dx -
                  initX -
                  (selectedIssues[j]!.startPanChartPos -
                      horizontalController.position.pixels)) >=
          chartViewWidth / viewRangeToFitScreen!) {
        if (calculateDistanceToLeftBorder(selectedIssues[j]!.startTime!) *
                        chartViewWidth /
                        viewRangeToFitScreen! -
                    (details.globalPosition.dx -
                        initX -
                        (selectedIssues[j]!.startPanChartPos -
                            horizontalController.position.pixels)) <
                chartViewWidth / viewRangeToFitScreen! * viewRange!.length &&
            calculateDistanceToRightBorder(selectedIssues[j]!.endTime!) *
                        chartViewWidth /
                        viewRangeToFitScreen! -
                    (details.globalPosition.dx -
                        initX -
                        (selectedIssues[j]!.startPanChartPos -
                            horizontalController.position.pixels)) >
                0) {
          selectedIssues[j]!.width = details.globalPosition.dx -
              initX -
              (selectedIssues[j]!.startPanChartPos -
                  horizontalController.position.pixels);
          selectedIssues[j]!.dragPosFactor = (details.globalPosition.dx -
                      (MediaQuery.of(context).size.width - chartAreaWidth)) /
                  chartAreaWidth -
              0.5;
        } else {
          return;
        }
      } else {
        selectedIssues[j]!.width = (selectedIssues[j]!.remainingWidth! - 1) *
            chartViewWidth /
            -viewRangeToFitScreen!;
      }
    }
  }

  void onIssueDateUpdate(
      BuildContext context, DragUpdateDetails details, double chartAreaWidth) {
    for (int j = 0; j < selectedIssues.length; j++) {
      if (calculateDistanceToLeftBorder(selectedIssues[j]!.startTime!) *
                      chartViewWidth /
                      viewRangeToFitScreen! +
                  (details.globalPosition.dx -
                      initX -
                      (selectedIssues[j]!.startPanChartPos -
                          horizontalController.position.pixels)) >
              0 &&
          calculateDistanceToLeftBorder(selectedIssues[j]!.startTime!) *
                      chartViewWidth /
                      viewRangeToFitScreen! +
                  (details.globalPosition.dx -
                      initX -
                      (selectedIssues[j]!.startPanChartPos -
                          horizontalController.position.pixels)) <
              chartViewWidth / viewRangeToFitScreen! * viewRange!.length &&
          calculateDistanceToRightBorder(selectedIssues[j]!.endTime!) *
                      chartViewWidth /
                      viewRangeToFitScreen! -
                  (details.globalPosition.dx -
                      initX -
                      (selectedIssues[j]!.startPanChartPos -
                          horizontalController.position.pixels)) >
              0) {
        selectedIssues[j]!.width = details.globalPosition.dx -
            initX -
            (selectedIssues[j]!.startPanChartPos -
                horizontalController.position.pixels);
        selectedIssues[j]!.dragPosFactor = (details.globalPosition.dx -
                    (MediaQuery.of(context).size.width - chartAreaWidth)) /
                chartAreaWidth -
            0.5;
      } else {
        return;
      }
    }
  }

  void onIssueStartPan(PanType type, double startMousePos) {
    for (int j = 0; j < selectedIssues.length; j++) {
      selectedIssues[j]!.draggingRemainingWidth =
          selectedIssues[j]!.remainingWidth!;
      selectedIssues[j]!.startPanChartPos =
          horizontalController.position.pixels;
    }

    if (selectedIssues.isNotEmpty) {
      switch (type) {
        case PanType.start:
          isPanStartActive = true;
          break;
        case PanType.end:
          isPanEndActive = true;
          break;
        default:
          isPanMiddleActive = true;
      }

      update();
    }
  }

  void onIssuePanCancel(PanType type) {
    for (int j = 0; j < selectedIssues.length; j++) {
      selectedIssues[j]!.dragPosFactor = 0;
      selectedIssues[j]!.width = 0;
      selectedIssues[j]!.remainingWidth =
          selectedIssues[j]!.remainingWidth! + dx.toInt();
    }

    isPanStartActive = false;
    isPanEndActive = false;
    isPanMiddleActive = false;
    update();
  }

  void onIssueEndPan(PanType type) {
    final ProjectController projectController = Get.find();
    for (int j = 0; j < selectedIssues.length; j++) {
      int daysInterval =
          (selectedIssues[j]!.width / (chartViewWidth / viewRangeToFitScreen!))
              .abs()
              .round();

      if (daysInterval > 0) {
        if (type == PanType.start || type == PanType.middle) {
          if (selectedIssues[j]!.width >
              (chartViewWidth / viewRangeToFitScreen! * 0.5)) {
            selectedIssues[j]!.startTime =
                selectedIssues[j]!.startTime!.add(Duration(days: daysInterval));
          } else if (selectedIssues[j]!.width <
              -(chartViewWidth / viewRangeToFitScreen! * 0.5)) {
            selectedIssues[j]!.startTime = selectedIssues[j]!
                .startTime!
                .subtract(Duration(days: daysInterval));
          }
        }

        if (type == PanType.end || type == PanType.middle) {
          if (selectedIssues[j]!.width >
              (chartViewWidth / viewRangeToFitScreen! * 0.5)) {
            selectedIssues[j]!.endTime =
                selectedIssues[j]!.endTime!.add(Duration(days: daysInterval));
          } else if (selectedIssues[j]!.width <
              -(chartViewWidth / viewRangeToFitScreen! * 0.5)) {
            selectedIssues[j]!.endTime = selectedIssues[j]!
                .endTime!
                .subtract(Duration(days: daysInterval));
          }
        }
        selectedIssues[j]!.toggleProcessing(notify: true);
        projectController.updateTaskDateFromGanttChart(
          taskID: selectedIssues[j]!.id!,
          startDate: selectedIssues[j]!.startTime!,
          endDate: selectedIssues[j]!.endTime!,
        );
        selectedIssues[j]!.toggleProcessing(notify: true);
        // print(
        //     'selectedIssue ID :  ${selectedIssues[j]!.id} selected Issue Title: ${selectedIssues[j]!.title} selected Issue endTime: ${selectedIssues[j]!.endTime}');

        selectedIssues[j]!.width = 0;

        // selectedIssues[j]!.toggleProcessing();

        // gitHub!.updateIssueTime(selectedIssues[j]!).then((value) async {
        //   Issue? temp = selectedIssues
        //       .singleWhere((element) => element!.number == value.number);

        //   if (temp != null) {
        //     temp.startTime = value.startTime;
        //     temp.endTime = value.endTime;
        //     temp.title = value.title;
        //     temp.dragPosFactor = 0;
        //     temp.remainingWidth = temp.remainingWidth! + dx.toInt();
        //     // temp.toggleProcessing();

        //     if (j == selectedIssues.length - 1) {
        //       isPanStartActive = false;
        //       isPanEndActive = false;
        //       isPanMiddleActive = false;
        //       update();
        //     }
        //   } else {}
        // });
      } else {
        // isPanStartActive = false;
        // isPanEndActive = false;
        // isPanMiddleActive = false;
        // selectedIssues[j]!.width = 0;
        // selectedIssues[j]!.dragPosFactor = 0;
        // selectedIssues[j]!.update();
        // update();
      }
    }
  }

  Future<void> removeIssueSelection() async {
    for (int i = 0; i < selectedIssues.length; i++) {
      if (selectedIssues[i]!.selected) selectedIssues[i]!.toggleSelect();

      if (selectedIssues[i]!.processing) {
        return await Future.delayed(
            const Duration(milliseconds: 100), () => removeIssueSelection());
      }

      selectedIssues.remove(selectedIssues[i]!);
      i--;
    }
  }

  void issueSelect(Issue issue, List<Issue> pIssueList) {
    if (!isShiftPressed && !issue.selected) removeIssueSelection();

    if (isShiftPressed && isCtrlPressed) {
      int start = 0;

      if (selectedIssues.isNotEmpty) {
        start = pIssueList.indexOf(selectedIssues[selectedIssues.length - 1]!);
      }

      int end = pIssueList.indexOf(issue);

      for (int j = start;
          start < end ? j <= end : j >= end;
          start < end ? j++ : j--) {
        if (!pIssueList[j].selected) {
          selectedIssues.add(pIssueList[j]);
          pIssueList[j].toggleSelect();
        }
      }
    } else {
      issue.toggleSelect();

      if (issue.selected) {
        selectedIssues.add(issue);
      } else {
        removeIssueSelection();
      }
    }
  }
}
