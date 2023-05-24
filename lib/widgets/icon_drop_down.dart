import 'package:ava/controllers/department_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/style.dart';
import '../controllers/project_controller.dart';

SizedBox iconDropdown(BuildContext context, StateSetter setState,
    {String? phase}) {
  final DepartmentController departmentController =
      Get.find<DepartmentController>();
  return SizedBox(
    width: screenWidth(context) * 0.1,
    height: screenHeight(context) * 0.05,
    child: DropdownButton(
      iconSize: 40,
      underline: Container(),
      isExpanded: true,
      itemHeight: screenHeight(context) * 0.05,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      menuMaxHeight: screenHeight(context) * 0.4,
      hint: Align(
        alignment: Alignment.center,
        child: Icon(IconData(departmentController.iconCodeValue.value,
            fontFamily: 'MaterialIcons')),
      ),
      items: <IconData>[
        Icons.settings,
        Icons.engineering,
        Icons.warehouse,
        Icons.local_shipping,
        Icons.draw,
        Icons.inventory,
      ].map((icon) {
        return DropdownMenuItem<IconData>(
          value: icon,
          child: Align(
            alignment: Alignment.center,
            child: Icon(icon),
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          IconData homeIcon = value as IconData;
          int homeCode = homeIcon.codePoint;
          departmentController.iconCodeValue.value = homeCode;
          departmentController.update();
        });
      },
    ),
  );
}
