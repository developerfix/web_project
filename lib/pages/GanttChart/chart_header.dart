import 'package:ava/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../controllers/gantt_chart_controller.dart';

class ChartHeader extends StatefulWidget {
  const ChartHeader({
    Key? key,
  }) : super(key: key);

  @override
  State<ChartHeader> createState() => _ChartHeaderState();
}

class _ChartHeaderState extends State<ChartHeader> {
  @override
  Widget build(BuildContext context) {
    List<Widget> days = <Widget>[];
    List<Widget> finalMonths = <Widget>[];
    DateTime tempDate = GanttChartController.instance.fromDate!;
    DateTime tempDate2 = GanttChartController.instance.fromDate!;
    String monthName = '';
    int numberOfDaysInMonth = 28;

    for (int i = 0; i < GanttChartController.instance.viewRange!.length; i++) {
      days.add(SizedBox(
          width: GanttChartController.instance.chartViewWidth /
              GanttChartController.instance.viewRangeToFitScreen!,
          child: txt(
              txt: DateFormat('dd').format(tempDate2),
              fontSize: 12,
              textAlign: TextAlign.center,
              fontColor: Colors.white)));
      tempDate2 = tempDate2.add(const Duration(days: 1));
    }

    // for (int i = 0; i < GanttChartController.instance.viewRange!.length; i++) {
    //   print(DateFormat('MM/yy').format(tempDate));
    //   tempDate = tempDate.add(const Duration(days: 1));

    //   i = i + 30;
    // }
    for (int i = 0; i < GanttChartController.instance.viewRange!.length; i++) {
      setState(() {
        if (DateFormat('MM').format(tempDate) == '01') {
          monthName = 'JANUARY';
          numberOfDaysInMonth = 31;
        } else if (DateFormat('MM').format(tempDate) == '02') {
          monthName = 'FEBRUARY';
          numberOfDaysInMonth = 29;
        } else if (DateFormat('MM').format(tempDate) == '03') {
          monthName = 'MARCH';
          numberOfDaysInMonth = 31;
        } else if (DateFormat('MM').format(tempDate) == '04') {
          monthName = 'APRIL';
          numberOfDaysInMonth = 30;
        } else if (DateFormat('MM').format(tempDate) == '05') {
          monthName = 'MAY';
          numberOfDaysInMonth = 31;
        } else if (DateFormat('MM').format(tempDate) == '06') {
          monthName = 'JUNE';
          numberOfDaysInMonth = 30;
        } else if (DateFormat('MM').format(tempDate) == '07') {
          monthName = 'JULY';
          numberOfDaysInMonth = 31;
        } else if (DateFormat('MM').format(tempDate) == '08') {
          monthName = 'AUGUST';
          numberOfDaysInMonth = 31;
        } else if (DateFormat('MM').format(tempDate) == '09') {
          monthName = 'SEPTEMBER';
          numberOfDaysInMonth = 30;
        } else if (DateFormat('MM').format(tempDate) == '10') {
          monthName = 'OCTOBER';
          numberOfDaysInMonth = 31;
        } else if (DateFormat('MM').format(tempDate) == '11') {
          monthName = 'NOVEMBER';
          numberOfDaysInMonth = 30;
        } else if (DateFormat('MM').format(tempDate) == '12') {
          monthName = 'DECEMBER';
          numberOfDaysInMonth = 31;
        }
      });

      finalMonths.add(SizedBox(
          width: (GanttChartController.instance.chartViewWidth /
                  GanttChartController.instance.viewRangeToFitScreen!) *
              numberOfDaysInMonth,
          child: txt(
              txt: '$monthName - ${DateFormat('yy').format(tempDate)}',
              fontSize: 12,
              textAlign: TextAlign.center,
              fontColor: Colors.white)));
      tempDate = tempDate.add(Duration(days: numberOfDaysInMonth));
      i = i + numberOfDaysInMonth;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 30.0,
          color: Colors.blue,
          child: Row(
            children: finalMonths,
          ),
        ),
        Container(
          height: 30.0,
          color: Colors.blue,
          child: Row(
            children: days,
          ),
        ),
      ],
    );
  }
}
