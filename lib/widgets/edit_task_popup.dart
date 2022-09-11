import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Ava/constants/style.dart';
import 'package:Ava/controllers/profile_controller.dart';
import 'package:Ava/controllers/project_controller.dart';

import 'add_new_task_popup.dart';
import 'select_task_members_popup.dart';

final ProjectController projectController = Get.find();
final ProfileController profileController = Get.find();

final titleController = TextEditingController();
final descriptionController = TextEditingController();
final endDateController = TextEditingController();
final startDateController = TextEditingController();

String phaseValue = '';
String taskPilot = '';
String taskCoPilot = '';

Future<dynamic> editTaskPopUp(
  BuildContext context, {
  final String? taskTitle,
  final String? phase,
  final String? taskDescription,
  final String? pilot,
  final String? copilot,
  final String? startDate,
  final String? endDate,
  final String? status,
  final int? priorityLevel,
}) {
  final ProjectController projectController = Get.find();
  int value = 2;

  final GlobalKey<ScaffoldState> key = GlobalKey();

  final formKey = GlobalKey<FormState>();

  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: formKey,
          child: AlertDialog(
            content: SizedBox(
              height: screenHeight(context) * 0.7,
              width: screenWidth(context) * 0.5,
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return Scaffold(
                  key: key,
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: constraints.maxWidth < 800
                          ? const EdgeInsets.fromLTRB(10, 30, 10, 50)
                          : const EdgeInsets.fromLTRB(100, 30, 100, 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: screenHeight(context) * 0.02,
                          ),
                          txt(
                              txt: 'Edit Task Details',
                              font: 'comfortaa',
                              fontWeight: FontWeight.w700,
                              fontSize: 30,
                              fontColor: const Color(secondaryColor)),
                          SizedBox(
                            height: screenHeight(context) * 0.03,
                          ),
                          titleWidget(constraints, context, taskTitle),
                          SizedBox(
                            height: screenHeight(context) * 0.03,
                          ),
                          phaseWidget(context, phase),
                          SizedBox(
                            height: screenHeight(context) * 0.03,
                          ),
                          descriptionWidget(context, taskDescription),
                          SizedBox(
                            height: screenHeight(context) * 0.03,
                          ),
                          pilotWidget(context, pilot),
                          SizedBox(
                            height: screenHeight(context) * 0.03,
                          ),
                          copilotWidget(context, copilot),
                          SizedBox(
                            height: screenHeight(context) * 0.03,
                          ),
                          constraints.maxWidth < 800
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    txt(
                                      minFontSize: 18,
                                      txt: 'Start Date:',
                                      fontSize: 30,
                                    ),
                                    SizedBox(
                                      width: screenWidth(context) * 0.04,
                                    ),
                                    Container(
                                      width: screenWidth(context) * 0.4,
                                      height: screenHeight(context) * 0.05,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.16),
                                            offset: const Offset(0, 3.0),
                                            blurRadius: 6.0,
                                          ),
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15, top: 5),
                                        child: InkWell(
                                          onTap: () async {
                                            DateTime? newStartDate =
                                                await showDatePicker(
                                              initialDate: DateTime.now(),
                                              context: context,
                                              firstDate: DateTime.now()
                                                  .subtract(
                                                      const Duration(days: 0)),
                                              lastDate: DateTime(2100),
                                            );

                                            if (newStartDate == null) {
                                              return;
                                            } else {
                                              startDateController.text =
                                                  '${newStartDate.year}/${newStartDate.month}/${newStartDate.day}';
                                            }
                                          },
                                          child: TextFormField(
                                            enabled: false,
                                            maxLines: null,
                                            controller: startDateController,
                                            decoration: InputDecoration(
                                                suffixIcon: const Icon(
                                                    Icons.date_range),
                                                suffixIconColor:
                                                    const Color(secondaryColor),
                                                border: InputBorder.none,
                                                hintText: startDate,
                                                hintStyle: const TextStyle(
                                                    color: Color(brownishColor),
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    SizedBox(
                                      width: screenWidth(context) * 0.1,
                                      child: txt(
                                        minFontSize: 18,
                                        maxLines: 1,
                                        txt: 'Start Date:',
                                        fontSize: 30,
                                      ),
                                    ),
                                    SizedBox(
                                      width: screenWidth(context) * 0.04,
                                    ),
                                    Container(
                                      width: screenWidth(context) * 0.2,
                                      height: screenHeight(context) * 0.05,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.16),
                                            offset: const Offset(0, 3.0),
                                            blurRadius: 6.0,
                                          ),
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15, top: 5),
                                        child: InkWell(
                                          onTap: () async {
                                            DateTime? newStartDate =
                                                await showDatePicker(
                                              initialDate: DateTime.now(),
                                              context: context,
                                              firstDate: DateTime.now()
                                                  .subtract(
                                                      const Duration(days: 0)),
                                              lastDate: DateTime(2100),
                                            );

                                            if (newStartDate == null) {
                                              return;
                                            } else {
                                              startDateController.text =
                                                  '${newStartDate.year}/${newStartDate.month}/${newStartDate.day}';
                                            }
                                          },
                                          child: TextFormField(
                                            enabled: false,
                                            maxLines: null,
                                            controller: startDateController,
                                            decoration: InputDecoration(
                                                suffixIcon: const Icon(
                                                    Icons.date_range),
                                                suffixIconColor:
                                                    const Color(secondaryColor),
                                                border: InputBorder.none,
                                                hintText: startDate,
                                                hintStyle: const TextStyle(
                                                    color: Color(brownishColor),
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          SizedBox(
                            height: screenHeight(context) * 0.03,
                          ),
                          constraints.maxWidth < 800
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    txt(
                                      minFontSize: 18,
                                      txt: 'End Date:',
                                      fontSize: 30,
                                    ),
                                    SizedBox(
                                      width: screenWidth(context) * 0.04,
                                    ),
                                    Container(
                                      width: screenWidth(context) * 0.4,
                                      height: screenHeight(context) * 0.05,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.16),
                                            offset: const Offset(0, 3.0),
                                            blurRadius: 6.0,
                                          ),
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15, top: 5),
                                        child: InkWell(
                                          onTap: () async {
                                            DateTime? newEndDate =
                                                await showDatePicker(
                                              initialDate: DateTime.now(),
                                              context: context,
                                              firstDate: DateTime.now()
                                                  .subtract(
                                                      const Duration(days: 0)),
                                              lastDate: DateTime(2100),
                                            );

                                            if (newEndDate == null) {
                                              return;
                                            } else {
                                              endDateController.text =
                                                  '${newEndDate.year}/${newEndDate.month}/${newEndDate.day}';
                                            }
                                          },
                                          child: TextFormField(
                                            enabled: false,
                                            maxLines: null,
                                            controller: endDateController,
                                            decoration: InputDecoration(
                                                suffixIcon: const Icon(
                                                    Icons.date_range),
                                                suffixIconColor:
                                                    const Color(secondaryColor),
                                                border: InputBorder.none,
                                                hintText: endDate,
                                                hintStyle: const TextStyle(
                                                    color: Color(brownishColor),
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    SizedBox(
                                      width: screenWidth(context) * 0.1,
                                      child: txt(
                                        minFontSize: 18,
                                        maxLines: 1,
                                        txt: 'End Date:',
                                        fontSize: 30,
                                      ),
                                    ),
                                    SizedBox(
                                      width: screenWidth(context) * 0.04,
                                    ),
                                    Container(
                                      width: screenWidth(context) * 0.2,
                                      height: screenHeight(context) * 0.05,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.16),
                                            offset: const Offset(0, 3.0),
                                            blurRadius: 6.0,
                                          ),
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15, top: 5),
                                        child: InkWell(
                                          onTap: () async {
                                            DateTime? newEndDate =
                                                await showDatePicker(
                                              initialDate: DateTime.now(),
                                              context: context,
                                              firstDate: DateTime.now()
                                                  .subtract(
                                                      const Duration(days: 0)),
                                              lastDate: DateTime(2100),
                                            );

                                            if (newEndDate == null) {
                                              return;
                                            } else {
                                              endDateController.text =
                                                  '${newEndDate.year}/${newEndDate.month}/${newEndDate.day}';
                                            }
                                          },
                                          child: TextFormField(
                                            enabled: false,
                                            controller: endDateController,
                                            maxLines: null,
                                            decoration: InputDecoration(
                                                suffixIcon: const Icon(
                                                    Icons.date_range),
                                                suffixIconColor:
                                                    const Color(secondaryColor),
                                                border: InputBorder.none,
                                                hintText: endDate,
                                                hintStyle: const TextStyle(
                                                    color: Color(brownishColor),
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          SizedBox(
                            height: screenHeight(context) * 0.03,
                          ),
                          txt(
                              txt: 'Please select priority level for this task',
                              fontSize: 30,
                              font: 'comfortaa',
                              fontWeight: FontWeight.w700,
                              fontColor: const Color(secondaryColor)),
                          SizedBox(
                            height: screenHeight(context) * 0.01,
                          ),
                          SizedBox(
                            height: screenHeight(context) * 0.2,
                            width: constraints.maxWidth < 800
                                ? screenWidth(context) * 0.5
                                : screenWidth(context) * 0.3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: constraints.maxWidth < 800
                                          ? null
                                          : screenWidth(context) * 0.1,
                                      child: txt(
                                        minFontSize: 18,
                                        maxLines: constraints.maxWidth < 800
                                            ? null
                                            : 1,
                                        txt: 'High Priority',
                                        fontSize: 30,
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenHeight(context) * 0.04,
                                    ),
                                    Radio(
                                        value: 1,
                                        groupValue: value,
                                        onChanged: (val) {
                                          value = 1;
                                        }),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: constraints.maxWidth < 800
                                          ? null
                                          : screenWidth(context) * 0.1,
                                      child: txt(
                                        minFontSize: 18,
                                        maxLines: constraints.maxWidth < 800
                                            ? null
                                            : 1,
                                        txt: 'Regular Priority',
                                        fontSize: 30,
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenHeight(context) * 0.04,
                                    ),
                                    Radio(
                                        value: 2,
                                        groupValue: value,
                                        onChanged: (val) {
                                          value = 2;
                                        }),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: constraints.maxWidth < 800
                                          ? null
                                          : screenWidth(context) * 0.1,
                                      child: txt(
                                        minFontSize: 18,
                                        maxLines: constraints.maxWidth < 800
                                            ? null
                                            : 1,
                                        txt: 'Future Priority',
                                        fontSize: 30,
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenHeight(context) * 0.04,
                                    ),
                                    Radio(
                                        value: 3,
                                        groupValue: value,
                                        onChanged: (val) {
                                          value = 3;
                                        }),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          deliverablesWidget(context),
                          SizedBox(
                            height: screenWidth(context) * 0.03,
                          ),
                          SizedBox(
                            width: screenWidth(context) * 0.5,
                            child: Row(
                              mainAxisAlignment: constraints.maxWidth < 800
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                    titleController.text = '';
                                    descriptionController.text = '';
                                    taskPilot = '';
                                    taskCoPilot = '';
                                    endDateController.text = '';
                                    startDateController.text = '';
                                    phaseValue = '3D Design';
                                    value = 2;
                                    // projectController.selectedDeliverables
                                    //     .clear();
                                  },
                                  child: Container(
                                    width: constraints.maxWidth < 800
                                        ? screenWidth(context) * 0.3
                                        : screenWidth(context) * 0.1,
                                    height: screenHeight(context) * 0.05,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      color: const Color(0xFF958890),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.23),
                                          offset: const Offset(0, 3.0),
                                          blurRadius: 9.0,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                        child: txt(
                                            txt: 'Cancel',
                                            fontSize: 15,
                                            fontColor: Colors.white)),
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth(context) * 0.005,
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                    projectController.updateTask(
                                        oldTaskDescription: taskDescription,
                                        oldTaskTitle: taskTitle,
                                        taskDeliverables: projectController
                                            .selectedDeliverables,
                                        taskTitle: titleController.text.isEmpty
                                            ? taskTitle
                                            : titleController.text,
                                        phase: phaseValue == ''
                                            ? phase
                                            : phaseValue,
                                        taskDescription:
                                            descriptionController.text.isEmpty
                                                ? taskDescription
                                                : descriptionController.text,
                                        pilot:
                                            taskPilot == '' ? pilot : taskPilot,
                                        copilot: taskCoPilot == ''
                                            ? copilot
                                            : taskCoPilot,
                                        startDate:
                                            startDateController.text.isEmpty
                                                ? startDate
                                                : startDateController.text,
                                        endDate: endDateController.text.isEmpty
                                            ? endDate
                                            : endDateController.text,
                                        status: status,
                                        priorityLevel: value);

                                    titleController.text = '';
                                    descriptionController.text = '';
                                    taskPilot = '';
                                    taskCoPilot = '';
                                    endDateController.text = '';
                                    startDateController.text = '';
                                    phaseValue = '3D Design';
                                    value = 2;
                                    // projectController.selectedDeliverables
                                    //     .clear();
                                  },
                                  child: Container(
                                    width: constraints.maxWidth < 800
                                        ? screenWidth(context) * 0.3
                                        : screenWidth(context) * 0.1,
                                    height: screenHeight(context) * 0.05,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      color: const Color(0xFF958890),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.23),
                                          offset: const Offset(0, 3.0),
                                          blurRadius: 9.0,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                        child: txt(
                                            txt: 'Edit Task',
                                            fontSize: 15,
                                            fontColor: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      });
}

StatefulBuilder copilotWidget(BuildContext context, String? copilot) {
  return StatefulBuilder(builder: (context, setState) {
    return Container(
        child: screenWidth(context) < 800
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  txt(
                    minFontSize: 18,
                    txt: 'Co-Pilot:',
                    fontSize: 30,
                  ),
                  SizedBox(
                    width: screenWidth(context) * 0.04,
                  ),
                  Container(
                    width: screenWidth(context) * 0.4,
                    height: screenHeight(context) * 0.05,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.16),
                          offset: const Offset(0, 3.0),
                          blurRadius: 6.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 5),
                      child: InkWell(
                        onTap: () {
                          selectTaskMembersPopup(context,
                                  title: 'Select Co-Pilot for this task')
                              .then((value) {
                            if (value != null) {
                              setState(() {
                                taskCoPilot = '@$value';
                              });
                            }
                          });
                        },
                        child: TextFormField(
                          enabled: false,
                          maxLines: null,
                          decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.person_add),
                              suffixIconColor: const Color(secondaryColor),
                              border: InputBorder.none,
                              hintText: copilot,
                              hintStyle: const TextStyle(
                                  color: Color(brownishColor),
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  SizedBox(
                    width: screenWidth(context) * 0.1,
                    child: txt(
                      minFontSize: 18,
                      maxLines: 1,
                      txt: 'Co-Pilot:',
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(
                    width: screenWidth(context) * 0.04,
                  ),
                  Container(
                    width: screenWidth(context) * 0.2,
                    height: screenHeight(context) * 0.05,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.16),
                          offset: const Offset(0, 3.0),
                          blurRadius: 6.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 5),
                      child: InkWell(
                        onTap: () {
                          selectTaskMembersPopup(context,
                                  title: 'Select Co-Pilot for this task')
                              .then((value) {
                            if (value != null) {
                              setState(() {
                                taskCoPilot = '@$value';
                              });
                            }
                          });
                        },
                        child: TextFormField(
                          enabled: false,
                          maxLines: null,
                          decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.person_add),
                              suffixIconColor: const Color(secondaryColor),
                              border: InputBorder.none,
                              hintText: copilot,
                              hintStyle: const TextStyle(
                                  color: Color(brownishColor),
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ),
                ],
              ));
  });
}

StatefulBuilder pilotWidget(BuildContext context, String? pilot) {
  return StatefulBuilder(builder: (context, setState) {
    return Container(
        child: screenWidth(context) < 800
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  txt(
                    minFontSize: 18,
                    txt: 'Pilot:',
                    fontSize: 30,
                  ),
                  SizedBox(
                    width: screenWidth(context) * 0.04,
                  ),
                  Container(
                    width: screenWidth(context) * 0.4,
                    height: screenHeight(context) * 0.05,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.16),
                          offset: const Offset(0, 3.0),
                          blurRadius: 6.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 5),
                      child: InkWell(
                        onTap: () {
                          selectTaskMembersPopup(context,
                                  title: 'Select Pilot for this task')
                              .then((value) {
                            if (value != null) {
                              setState(() {
                                taskPilot = '@$value';
                              });
                            }
                          });
                        },
                        child: TextFormField(
                          enabled: false,

                          maxLines: null,
                          // controller: commentController,
                          decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.person_add),
                              suffixIconColor: const Color(secondaryColor),
                              border: InputBorder.none,
                              hintText: pilot,
                              hintStyle: const TextStyle(
                                  color: Color(brownishColor),
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  SizedBox(
                    width: screenWidth(context) * 0.1,
                    child: txt(
                      minFontSize: 18,
                      maxLines: 1,
                      txt: 'Pilot:',
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(
                    width: screenWidth(context) * 0.04,
                  ),
                  Container(
                    width: screenWidth(context) * 0.2,
                    height: screenHeight(context) * 0.05,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.16),
                          offset: const Offset(0, 3.0),
                          blurRadius: 6.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 5),
                      child: InkWell(
                        onTap: () {
                          selectTaskMembersPopup(context,
                                  title: 'Select Pilot for this task')
                              .then((value) {
                            if (value != null) {
                              setState(() {
                                taskPilot = '@$value';
                              });
                            }
                          });
                        },
                        child: TextFormField(
                          enabled: false,

                          maxLines: null,
                          // controller: commentController,
                          decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.person_add),
                              suffixIconColor: const Color(secondaryColor),
                              border: InputBorder.none,
                              hintText: pilot,
                              hintStyle: const TextStyle(
                                  color: Color(brownishColor),
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ),
                ],
              ));
  });
}

Container descriptionWidget(BuildContext context, String? taskDescription) {
  return Container(
      child: screenWidth(context) < 800
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                txt(
                  minFontSize: 18,
                  txt: 'Task Description:',
                  fontSize: 30,
                ),
                SizedBox(
                  width: screenWidth(context) * 0.04,
                ),
                Container(
                  width: screenWidth(context) * 0.4,
                  height: screenHeight(context) * 0.1,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.16),
                        offset: const Offset(0, 3.0),
                        blurRadius: 6.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                    child: TextFormField(
                      maxLines: null,
                      controller: descriptionController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: taskDescription,
                          hintStyle: const TextStyle(
                              color: Color(brownishColor),
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ],
            )
          : Row(
              children: [
                SizedBox(
                  width: screenWidth(context) * 0.1,
                  child: txt(
                    minFontSize: 18,
                    maxLines: 1,
                    txt: 'Task Description:',
                    fontSize: 30,
                  ),
                ),
                SizedBox(
                  width: screenWidth(context) * 0.04,
                ),
                Container(
                  width: screenWidth(context) * 0.2,
                  height: screenHeight(context) * 0.1,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.16),
                        offset: const Offset(0, 3.0),
                        blurRadius: 6.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                    child: TextFormField(
                      maxLines: null,
                      controller: descriptionController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: taskDescription,
                          hintStyle: const TextStyle(
                              color: Color(brownishColor),
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ],
            ));
}

Container titleWidget(
    BoxConstraints constraints, BuildContext context, String? taskName) {
  return Container(
      child: screenWidth(context) < 800
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                txt(
                  minFontSize: 18,
                  txt: 'Task Name:',
                  fontSize: 30,
                ),
                SizedBox(
                  width: screenWidth(context) * 0.04,
                ),
                Container(
                  width: screenWidth(context) * 0.4,
                  height: screenHeight(context) * 0.05,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.16),
                        offset: const Offset(0, 3.0),
                        blurRadius: 6.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                    child: TextFormField(
                      maxLines: 1,
                      controller: titleController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: taskName,
                          hintStyle: const TextStyle(
                              color: Color(brownishColor),
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ],
            )
          : Row(
              children: [
                SizedBox(
                  width: screenWidth(context) * 0.1,
                  child: txt(
                    minFontSize: 18,
                    maxLines: 1,
                    txt: 'Task Name:',
                    fontSize: 30,
                  ),
                ),
                SizedBox(
                  width: screenWidth(context) * 0.04,
                ),
                Container(
                  width: screenWidth(context) * 0.2,
                  height: screenHeight(context) * 0.05,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.16),
                        offset: const Offset(0, 3.0),
                        blurRadius: 6.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                    child: TextFormField(
                      maxLines: 1,
                      controller: titleController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: taskName,
                          hintStyle: const TextStyle(
                              color: Color(brownishColor),
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ],
            ));
}

StatefulBuilder phaseWidget(BuildContext context, String? phase) {
  return StatefulBuilder(builder: (context, setState) {
    return Container(
        child: screenWidth(context) < 800
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  txt(
                    minFontSize: 18,
                    txt: 'Phase:',
                    fontSize: 30,
                  ),
                  SizedBox(
                    width: screenWidth(context) * 0.04,
                  ),
                  Container(
                    width: screenWidth(context) * 0.4,
                    height: screenHeight(context) * 0.05,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.16),
                          offset: const Offset(0, 3.0),
                          blurRadius: 6.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: DropdownButtonFormField(
                        hint: txt(txt: phase!, fontSize: 14),
                        // itemHeight: 15,
                        // menuMaxHeight: 30,
                        items: <String>['3D Design', 'Optical Design']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),

                        onChanged: (value) {
                          setState(() {
                            phaseValue = value.toString();
                          });
                        },

                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          hintStyle: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              letterSpacing: 0,
                              color: Color(brownishColor),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          hintText: phaseValue,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  SizedBox(
                    width: screenWidth(context) * 0.1,
                    child: txt(
                      minFontSize: 18,
                      maxLines: 1,
                      txt: 'Phase:',
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(
                    width: screenWidth(context) * 0.04,
                  ),
                  Container(
                    width: screenWidth(context) * 0.2,
                    height: screenHeight(context) * 0.05,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.16),
                          offset: const Offset(0, 3.0),
                          blurRadius: 6.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: DropdownButtonFormField(
                        // itemHeight: 15,
                        // menuMaxHeight: 30,
                        items: <String>['3D Design', 'Optical Design']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),

                        onChanged: (value) {
                          setState(() {
                            phaseValue = value.toString();
                          });
                        },

                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          hintStyle: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              letterSpacing: 0,
                              color: Color(brownishColor),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          hintText: phaseValue,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ));
  });
}

Container dropdownContainer(BuildContext context) {
  return Container(
    width: screenWidth(context) * 0.2,
    height: screenHeight(context) * 0.05,
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.16),
          offset: const Offset(0, 3.0),
          blurRadius: 6.0,
        ),
      ],
      borderRadius: BorderRadius.circular(10.0),
    ),
  );
}
