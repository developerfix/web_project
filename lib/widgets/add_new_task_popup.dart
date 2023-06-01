import 'package:ava/controllers/auth_controller.dart';
import 'package:ava/controllers/project_controller.dart';
import 'package:ava/widgets/popup_button.dart';
import 'package:ava/widgets/project_category_widgets.dart';
import 'package:ava/widgets/task_deliverable_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ava/constants/style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_edit_task_widgets.dart';

Future<dynamic> addNewTaskPopUp(BuildContext context,
    {required String status}) {
  ProjectController projectController = Get.find<ProjectController>();
  AuthController authController = Get.find<AuthController>();
  projectController.selectedDeliverables.clear();
  projectController.taskCategory.value = noPhase;

  DateTime startdate = DateTime.now();
  DateTime endDate = DateTime.now();

  final titleController = TextEditingController();
  final dayToCompleteController = TextEditingController();
  final descriptionController = TextEditingController();
  final endDateController = TextEditingController();
  final startDateController = TextEditingController();
  final taskPilotController = TextEditingController();
  final taskPilotIDController = TextEditingController();
  final taskCoPilotController = TextEditingController();
  final taskCoPilotIDController = TextEditingController();
  final taskCategoryTitleController = TextEditingController();
  int daysBetween = endDate.difference(startdate).inDays;
  dayToCompleteController.text = daysBetween.toString();

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return GetBuilder<ProjectController>(
          init: ProjectController(),
          builder: (controller) {
            return AlertDialog(
              content: SizedBox(
                height: projectController.taskCategory.value == newTaskCategory
                    ? screenHeight(context) * 0.75
                    : screenHeight(context) * 0.7,
                width: 1200,
                child: Column(
                  children: [
                    popupHeader('NEW TASK'),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: ListView(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: screenHeight(context) * 0.02,
                                  ),
                                  titleWidget(context,
                                      titleController: titleController),
                                  SizedBox(
                                    height: screenHeight(context) * 0.02,
                                  ),
                                  phaseWidget(
                                    context,
                                  ),
                                  SizedBox(
                                    height: screenHeight(context) * 0.02,
                                  ),
                                  projectController.taskCategory.value ==
                                          newTaskCategory
                                      ? newTaskCategoryTextField(
                                          context, taskCategoryTitleController)
                                      : Container(),
                                  projectController.taskCategory.value ==
                                          newTaskCategory
                                      ? SizedBox(
                                          height: screenHeight(context) * 0.02,
                                        )
                                      : Container(),
                                  descriptionWidget(context,
                                      descriptionController:
                                          descriptionController),
                                  SizedBox(
                                    height: screenHeight(context) * 0.02,
                                  ),
                                  pilotWidget(context,
                                      taskPilotController: taskPilotController,
                                      taskPilotIDController:
                                          taskPilotIDController),
                                  SizedBox(
                                    height: screenHeight(context) * 0.02,
                                  ),
                                  copilotWidget(context,
                                      taskCoPilotIDController:
                                          taskCoPilotIDController,
                                      taskCoPilotController:
                                          taskCoPilotController),
                                  SizedBox(
                                    height: screenHeight(context) * 0.02,
                                  ),
                                  Row(
                                    children: [
                                      textWidgetTaskPopup(
                                          context, 'Start Date:'),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      dateSelectorBox(context,
                                          controller: startDateController,
                                          date: startdate),
                                    ],
                                  ),
                                  SizedBox(
                                    height: screenHeight(context) * 0.02,
                                  ),
                                  daysToCompleteWidget(
                                      context,
                                      authController,
                                      startdate,
                                      endDateController,
                                      dayToCompleteController,
                                      daysBetween),
                                  SizedBox(
                                    height: screenHeight(context) * 0.02,
                                  ),
                                  endDatePicker(
                                      context,
                                      authController,
                                      startdate,
                                      dayToCompleteController,
                                      endDateController,
                                      endDate),
                                ],
                              ),
                            ),
                          ),
                          const RotatedBox(
                            quarterTurns: 1,
                            child: Divider(
                              thickness: 3,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: ListView(
                                children: [
                                  SizedBox(
                                    height: screenHeight(context) * 0.03,
                                  ),
                                  textWidgetTaskPopup(context, 'Priority'),
                                  SizedBox(
                                    height: screenHeight(context) * 0.02,
                                  ),
                                  priorityBox(
                                    context,
                                  ),
                                  SizedBox(
                                    height: screenHeight(context) * 0.02,
                                  ),
                                  SizedBox(
                                    width: 300,
                                    child: txt(
                                      minFontSize: 18,
                                      maxLines: 1,
                                      txt: 'Deliverable Required?',
                                      fontSize: 30,
                                      font: 'comfortaa',
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight(context) * 0.02,
                                  ),
                                  deliverableQuestionBox(
                                    context,
                                  ),
                                  SizedBox(
                                    height: screenHeight(context) * 0.05,
                                  ),
                                  taskDeliverablesWidget(context),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      popupButton(context, ontap: () {
                                        if (titleController.text.isNotEmpty) {
                                          Get.back();
                                          projectController.addNewTask(
                                              taskTitle: titleController.text,
                                              phase: projectController
                                                  .taskCategory.value,
                                              daysToComplete:
                                                  daysBetween.toString(),
                                              taskDescription:
                                                  descriptionController.text,
                                              pilot: taskPilotIDController.text,
                                              copilot:
                                                  taskCoPilotIDController.text,
                                              deliverables: projectController
                                                  .selectedDeliverables,
                                              startDate: startDateController
                                                      .text.isEmpty
                                                  ? '${startdate.year}/${startdate.month}/${startdate.day}'
                                                  : startDateController.text,
                                              endDate: endDateController
                                                      .text.isEmpty
                                                  ? '${endDate.year}/${endDate.month}/${endDate.day}'
                                                  : endDateController.text,
                                              status: status,
                                              isDeliverableNeededForCompletion:
                                                  projectController
                                                      .taskSelectedValue.value,
                                              priorityLevel: projectController
                                                  .taskPrioritySelectedValue
                                                  .value);
                                          titleController.text = '';
                                          descriptionController.text = '';
                                          startDateController.text = '';
                                          endDateController.text = '';
                                          projectController.taskPilot.value =
                                              '';
                                          projectController.taskCoPilot.value =
                                              '';
                                          startdate = DateTime.now();
                                          endDate = DateTime.now();

                                          projectController.selectedDeliverables
                                              .clear();
                                          projectController.update();
                                        } else {
                                          getErrorSnackBar(
                                              "Please fillout the taskname");
                                        }
                                      }, text: 'SAVE'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    },
  );
}

Row daysToCompleteWidget(
    BuildContext context,
    AuthController authController,
    DateTime startdate,
    TextEditingController endDateController,
    TextEditingController dayToCompleteController,
    int daysBetween) {
  return Row(
    children: [
      textWidgetTaskPopup(
        context,
        'Day to Complete',
      ),
      const SizedBox(
        width: 10,
      ),
      Container(
        width: 300,
        height: 60,
        decoration: authController.isDarkTheme.value
            ? darkThemeBoxDecoration
            : lightThemeBoxDecoration,
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
          child: TextFormField(
            onChanged: (value) {
              int days = int.parse(value);
              DateTime newEndDate = startdate.add(Duration(days: days));
              endDateController.text =
                  '${newEndDate.year}/${newEndDate.month}/${newEndDate.day}';
            },
            maxLines: 1,
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                color: Color(secondaryColor),
                fontWeight: FontWeight.w600,
              ),
            ),
            controller: dayToCompleteController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: daysBetween.toString(),
              hintStyle: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  letterSpacing: 2,
                  color: const Color(secondaryColor).withOpacity(0.5),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      )
    ],
  );
}

Row endDatePicker(
    BuildContext context,
    AuthController authController,
    DateTime startdate,
    TextEditingController dayToCompleteController,
    TextEditingController endDateController,
    DateTime endDate) {
  return Row(
    children: [
      textWidgetTaskPopup(context, 'End Date:'),
      const SizedBox(
        width: 10,
      ),
      Container(
        width: 300,
        height: 60,
        decoration: authController.isDarkTheme.value
            ? darkThemeBoxDecoration
            : lightThemeBoxDecoration,
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
          child: InkWell(
            onTap: () async {
              DateTime? newDate = await showDatePicker(
                initialDate: DateTime.now(),
                context: context,
                firstDate: DateTime.now().subtract(const Duration(days: 0)),
                lastDate: DateTime(2100),
              );

              if (newDate == null) {
                return;
              } else {
                DateTime newEndDate = newDate;
                int daysBetween = newEndDate.difference(startdate).inDays;
                dayToCompleteController.text = daysBetween.toString();

                endDateController.text =
                    '${newDate.year}/${newDate.month}/${newDate.day}';
              }
            },
            child: TextFormField(
              enabled: false,
              maxLines: null,
              controller: endDateController,
              decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.date_range),
                  suffixIconColor: const Color(secondaryColor),
                  border: InputBorder.none,
                  hintText: endDate.runtimeType == DateTime
                      ? '${endDate.year}/${endDate.month}/${endDate.day}'
                      : endDate.toString(),
                  hintStyle: const TextStyle(
                      color: brownishColor, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ),
    ],
  );
}

Column popupHeader(String title) {
  return Column(
    children: [
      Row(
        children: [
          Container(
            width: 60,
          ),
          Expanded(
            child: Center(
              child: txt(
                txt: title,
                font: 'comfortaa',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                letterSpacing: 5,
                fontWeight: FontWeight.w700,
                fontSize: 40,
              ),
            ),
          ),
          popUpCloseButton,
        ],
      ),
      const Divider(thickness: 3),
    ],
  );
}

SizedBox textWidgetTaskPopup(BuildContext context, String text) {
  return SizedBox(
    width: 150,
    child: txt(
      minFontSize: 18,
      maxLines: 1,
      txt: text,
      fontSize: 30,
      font: 'comfortaa',
    ),
  );
}
