import 'package:ava/widgets/popup_textfield.dart';
import 'package:ava/widgets/select_members.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

import '../constants/style.dart';
import 'drop_down_button.dart';
import 'loading_indicator.dart';

Container dateSelectorBox(BuildContext context,
    {required TextEditingController controller, required var date}) {
  return Container(
    width: screenWidth(context) * 0.2,
    height: screenHeight(context) * 0.05,
    decoration: projecttController.isDarkTheme.value
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
            controller.text = '${newDate.year}/${newDate.month}/${newDate.day}';
          }
        },
        child: TextFormField(
          enabled: false,
          maxLines: null,
          controller: controller,
          decoration: InputDecoration(
              suffixIcon: const Icon(Icons.date_range),
              suffixIconColor: const Color(secondaryColor),
              border: InputBorder.none,
              hintText: date.runtimeType == DateTime
                  ? '${date.year}/${date.month}/${date.day}'
                  : date,
              hintStyle: const TextStyle(
                  color: Color(brownishColor), fontWeight: FontWeight.w600)),
        ),
      ),
    ),
  );
}

SizedBox deliverableQuestionBox(
  BuildContext context,
  BoxConstraints constraints,
) {
  return SizedBox(
      height: screenHeight(context) * 0.1,
      width: constraints.maxWidth < 800
          ? screenWidth(context) * 0.5
          : screenWidth(context) * 0.3,
      child: StatefulBuilder(builder: (context, setState) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            priorityWidget(
              constraints,
              context,
              projecttController.taskSelectedValue.value,
              'Yes',
              1,
              (int? val) {
                setState(
                  () {
                    projecttController.taskSelectedValue.value = val!;
                    projecttController.update();
                  },
                );
              },
            ),
            priorityWidget(
              constraints,
              context,
              projecttController.taskSelectedValue.value,
              'No',
              2,
              (int? val) {
                setState(
                  () {
                    projecttController.taskSelectedValue.value = val!;
                    projecttController.update();
                  },
                );
              },
            ),
          ],
        );
      }));
}

SizedBox priorityBox(
  BuildContext context,
  BoxConstraints constraints,
  // {required int prioritySelectedValue}
) {
  return SizedBox(
      height: screenHeight(context) * 0.2,
      width: constraints.maxWidth < 800
          ? screenWidth(context) * 0.5
          : screenWidth(context) * 0.3,
      child: StatefulBuilder(builder: (context, setState) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            priorityWidget(
              constraints,
              context,
              projecttController.taskPrioritySelectedValue.value,
              'High Priority',
              1,
              (int? val) {
                setState(
                  () {
                    projecttController.taskPrioritySelectedValue.value = val!;
                    projecttController.update();
                  },
                );
              },
            ),
            priorityWidget(
              constraints,
              context,
              projecttController.taskPrioritySelectedValue.value,
              'Medium Priority',
              2,
              (int? val) {
                setState(
                  () {
                    projecttController.taskPrioritySelectedValue.value = val!;
                    projecttController.update();
                  },
                );
              },
            ),
            priorityWidget(
              constraints,
              context,
              projecttController.taskPrioritySelectedValue.value,
              'Future Priority',
              3,
              (int? val) {
                setState(
                  () {
                    projecttController.taskPrioritySelectedValue.value = val!;
                    projecttController.update();
                  },
                );
              },
            )
          ],
        );
      }));
}

StatefulBuilder priorityWidget(
  BoxConstraints constraints,
  BuildContext context,
  int groupValue,
  String? priorityLabel,
  int? value,
  Function(int?)? onChanged,
) {
  return StatefulBuilder(builder: (context, setState) {
    return Row(
      children: [
        SizedBox(
          width:
              constraints.maxWidth < 800 ? null : screenWidth(context) * 0.08,
          child: txt(
            minFontSize: 18,
            maxLines: constraints.maxWidth < 800 ? null : 1,
            txt: priorityLabel!,
            fontSize: 30,
          ),
        ),
        SizedBox(
          height: screenHeight(context) * 0.04,
        ),
        Radio(
          value: value!,
          groupValue: groupValue,
          onChanged: onChanged,
        )
      ],
    );
  });
}

Container copilotWidget(BuildContext context,
    {required TextEditingController taskCoPilotController,
    String? oldPilotorCopilot}) {
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
              selectMember(context,
                  pilotOrCopilotValue: projecttController.taskCoPilot.value,
                  controller: taskCoPilotController,
                  oldPilotorCopilot: oldPilotorCopilot,
                  pilotOrCopilot: 'copilot')
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
              selectMember(context,
                  pilotOrCopilotValue: projecttController.taskCoPilot.value,
                  controller: taskCoPilotController,
                  oldPilotorCopilot: oldPilotorCopilot,
                  pilotOrCopilot: 'copilot')
            ],
          ),
  );
}

StatefulBuilder deliverablesWidget(
  BuildContext context,
) {
  return StatefulBuilder(builder: (context, setState) {
    return Obx(() {
      return Container(
          child: screenWidth(context) < 800
              ? Container()
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: screenWidth(context) * 0.1,
                      child: txt(
                        minFontSize: 18,
                        maxLines: 1,
                        txt: 'Deliverables:',
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(
                      width: screenWidth(context) * 0.04,
                    ),
                    projecttController
                            .isSelectedDeliverablesUpdatingBefore.isTrue
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const LoadingIndicator(),
                              txt(
                                  txt: 'Please wait\n File is being uploaded',
                                  fontSize: 14)
                            ],
                          )
                        : projecttController
                                        .deliverableUplaodingProgress.value !=
                                    100 &&
                                projecttController
                                        .deliverableUplaodingProgress.value !=
                                    0.0
                            ? SizedBox(
                                height: 40,
                                width: 350,
                                child: LiquidLinearProgressIndicator(
                                    value: projecttController
                                            .deliverableUplaodingProgress
                                            .value /
                                        100,
                                    valueColor: const AlwaysStoppedAnimation(Color(
                                        secondaryColor)), // Defaults to the current Theme's accentColor.
                                    backgroundColor: Colors.white,
                                    borderColor: const Color(mainColor),
                                    borderWidth: 5.0,
                                    borderRadius: 12.0,
                                    direction: Axis.horizontal,
                                    center: txt(
                                        txt:
                                            "${projecttController.deliverableUplaodingProgress.value.ceil()}%",
                                        fontSize: 18)))
                            : projecttController
                                    .isSelectedDeliverablesUpdatingAfter.isTrue
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const LoadingIndicator(),
                                      txt(
                                          txt: 'Uploading, Almost finished',
                                          fontSize: 14)
                                    ],
                                  )
                                : projecttController
                                        .selectedDeliverables.isEmpty
                                    ? ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  const Color(secondaryColor)),
                                        ),
                                        onPressed: () {
                                          // addTaskDeliverables()
                                          projecttController
                                              .addTaskDeliverables();
                                        },
                                        child: Center(
                                          child: txt(
                                              txt: 'upload',
                                              fontColor: Colors.white,
                                              fontSize: 14),
                                        ))
                                    : SizedBox(
                                        width: screenWidth(context) * 0.2,
                                        height: screenHeight(context) * 0.2,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: GridView.builder(
                                                  itemCount: projecttController
                                                      .selectedDeliverables
                                                      .length,
                                                  gridDelegate:
                                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                                          maxCrossAxisExtent:
                                                              200,
                                                          childAspectRatio: 2,
                                                          crossAxisSpacing: 20,
                                                          mainAxisSpacing: 20),
                                                  itemBuilder:
                                                      ((context, index) {
                                                    return Container(
                                                        margin: const EdgeInsets
                                                            .all(8.0),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: const Color(
                                                                    secondaryColor))),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: txt(
                                                                  txt: projecttController
                                                                              .selectedDeliverables[
                                                                          index]
                                                                      [
                                                                      'filename'],
                                                                  maxLines: 2,
                                                                  fontSize: 16),
                                                            ),
                                                            InkWell(
                                                                onTap: () {
                                                                  projecttController
                                                                      .selectedDeliverables
                                                                      .removeAt(
                                                                          index);
                                                                },
                                                                child: const Icon(
                                                                    Icons
                                                                        .close))
                                                          ],
                                                        ));
                                                  })),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                projecttController
                                                    .addTaskDeliverables();
                                              },
                                              child: const Icon(
                                                Icons.attach_file,
                                                color: Color(secondaryColor),
                                              ),
                                            ),
                                          ],
                                        )),
                  ],
                ));
    });
  });
}

Container pilotWidget(BuildContext context,
    {required TextEditingController taskPilotController,
    String? oldPilotorCopilot}) {
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
              selectMember(
                context,
                pilotOrCopilotValue: projecttController.taskPilot.value,
                controller: taskPilotController,
                oldPilotorCopilot: oldPilotorCopilot,
                pilotOrCopilot: 'pilot',
              )
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
              selectMember(context,
                  pilotOrCopilotValue: projecttController.taskPilot.value,
                  controller: taskPilotController,
                  oldPilotorCopilot: oldPilotorCopilot,
                  pilotOrCopilot: 'pilot')
            ],
          ),
  );
}

Container descriptionWidget(BuildContext context,
    {required TextEditingController descriptionController,
    String? description}) {
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
                popUpTextField(
                  context,
                  controller: descriptionController,
                  hint: description ?? '...',
                  maxLines: 1000,
                  height: screenHeight(context) * 0.1,
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
                popUpTextField(
                  context,
                  controller: descriptionController,
                  hint: description ?? '...',
                  maxLines: 1000,
                  height: screenHeight(context) * 0.1,
                ),
              ],
            ));
}

Container titleWidget(BoxConstraints constraints, BuildContext context,
    {required TextEditingController titleController, String? taskTitle}) {
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
                popUpTextField(context,
                    controller: titleController, hint: taskTitle ?? '...'),
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
                popUpTextField(context,
                    controller: titleController, hint: taskTitle ?? '...'),
              ],
            ));
}

StatefulBuilder phaseWidget(BuildContext context, {String? phase}) {
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
                  dropDownButton(context, setState, phase: phase),
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
                  dropDownButton(context, setState, phase: phase),
                ],
              ));
  });
}
