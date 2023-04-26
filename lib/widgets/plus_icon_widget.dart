import 'package:ava/widgets/add_new_task_popup.dart';
import 'package:flutter/material.dart';

import '../constants/style.dart';

InkWell plusIconWidget(BuildContext context,
    {Function()? ontap, String? status, Color? color}) {
  return InkWell(
    onTap: ontap ??
        () {
          addNewTaskPopUp(context, status: status!);
        },
    child: SizedBox(
      height: screenHeight(context) * 0.07,
      child: Center(
        child: Icon(
          Icons.add,
          size: 50,
          color: color ?? checkThemeColorwhite54,
        ),
      ),
    ),
  );
}
