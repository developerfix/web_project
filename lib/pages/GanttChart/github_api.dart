import 'package:intl/intl.dart';
import '../../controllers/gantt_chart_controller.dart';
import '../../models/issue.dart';

class GitHubAPI {
  bool refreshIssuesList = true;
  int pagesLoaded = 0;

  List<Issue> getIssuesList({required List<Issue> issuesList}) {
    DateTime? chartStart;
    DateTime? chartEnd;
    pagesLoaded = 0;

    for (var element in issuesList) {
      DateTime? startTime;
      DateTime? endTime;

      startTime = element.startTime;
      endTime = element.endTime;

      if (chartStart == null) {
        chartStart = startTime;
      } else if (startTime!.isBefore(chartStart)) {
        chartStart = startTime;
      }

      if (chartEnd == null) {
        chartEnd = endTime;
      } else if (endTime!.isAfter(chartEnd)) {
        chartEnd = endTime;
      }
    }
    pagesLoaded++;

    refreshIssuesList = false;

    DateTime fromDate = chartEnd!.subtract(const Duration(days: 30 * 6));

    int fromDateMonth = fromDate.month;
    int fromDateYear = fromDate.year;

    GanttChartController.instance.fromDate =
        DateTime(fromDateYear, fromDateMonth, 1);

    GanttChartController.instance.toDate =
        chartEnd.add(const Duration(days: 30 * 12));
    GanttChartController.instance.viewRange = GanttChartController.instance
        .calculateNumberOfDaysBetween(GanttChartController.instance.fromDate!,
            GanttChartController.instance.toDate!);
    GanttChartController.instance.issueList = issuesList;

    return issuesList;
  }

  Future<Issue> updateIssueTime(Issue currentUssue) async {
    dynamic issue = currentUssue;
    Issue response;
    DateTime? startTime;
    DateTime? endTime;

    try {
      startTime = DateFormat('yyyy/M/d').parse(RegExp(
              r'(?<=start_date: )\d+\/\d+\/\d+ \d+:\d+:\d+|(?<=start_date: )\d+\/\d+\/\d+')
          .stringMatch(currentUssue.startTime.toString())!);
      endTime = DateFormat('yyyy/M/d').parse(RegExp(
              r'(?<=due_date: )\d+\/\d+\/\d+ \d+:\d+:\d+|(?<=due_date: )\d+\/\d+\/\d+')
          .stringMatch(currentUssue.endTime.toString())!);
    } catch (e) {
      try {
        startTime = DateFormat('yyyy/MM/dd').parse(RegExp(
                r'(?<=start_date: )\d+\/\d+\/\d+ \d+:\d+:\d+|(?<=start_date: )\d+\/\d+\/\d+')
            .stringMatch(currentUssue.startTime.toString())!);
        endTime = DateFormat('yyyy/MM/dd').parse(RegExp(
                r'(?<=due_date: )\d+\/\d+\/\d+ \d+:\d+:\d+|(?<=due_date: )\d+\/\d+\/\d+')
            .stringMatch(currentUssue.endTime.toString())!);
      } catch (e) {
        startTime = DateTime.now();
        endTime = DateTime.now();
      }
    }

    response = Issue.fromJson(issue);
    response.startTime = startTime;
    response.endTime = endTime;

    return response;
  }
}
