import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:intl/intl.dart';

import '../constants/style.dart';

Tooltip projectBox(
  BuildContext context, {
  required String text,
  required DateTime dateTime,
}) {
  final dateFormat = DateFormat('MMM d, y');
  final timeFormat = DateFormat('h:mm a');
  String date = dateFormat.format(dateTime);
  String time = timeFormat.format(dateTime);
  return Tooltip(
      message: 'last opened: $date and at $time',
      child: HoverContainer(
        hoverWidth: 250,
        decoration: BoxDecoration(
          color: const Color(secondaryColor).withOpacity(0.5),
          borderRadius: BorderRadius.circular(12.0),
        ),
        hoverDecoration: BoxDecoration(
            color: const Color(secondaryColor),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: null),
        child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                txt(
                    txt: text,
                    textAlign: TextAlign.center,
                    fontSize: 30.0,
                    maxLines: 3,
                    minFontSize: 24,
                    letterSpacing: 2,
                    overflow: TextOverflow.ellipsis,
                    fontColor: Colors.white),
              ],
            )),
      ));
}

MouseRegion departmentBox(
  BuildContext context, {
  String? text,
  int? iconCode,
}) {
  return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Row(
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Colors.white, width: 2)),
              child: Icon(
                  IconData(
                    iconCode!,
                    fontFamily: 'MaterialIcons',
                  ),
                  color: Colors.white),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: txt(
                txt: text!.toUpperCase(),
                fontSize: 30.0,
                maxLines: 1,
                minFontSize: 24,
                letterSpacing: 2,
                overflow: TextOverflow.ellipsis,
                fontColor: Colors.white),
          )
        ],
      ));
}
