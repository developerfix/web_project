import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectx/constants/style.dart';
import 'package:projectx/controllers/auth_controller.dart';
import 'package:projectx/controllers/profile_controller.dart';
import 'package:projectx/controllers/project_controller.dart';
import 'package:projectx/widgets/custom_appbar.dart';
import 'package:projectx/widgets/popup_textfield.dart';

import '../widgets/custom_drawer.dart';
import '../widgets/select_task_members_popup.dart';

class UpdateTask extends StatefulWidget {
  final String? projectId;
  final String? taskTitle;
  final String? phase;
  final String? taskDescription;
  final String? pilot;
  final String? copilot;
  final String? startDate;
  final String? endDate;
  final String? status;
  final int? priorityLevel;

  const UpdateTask(
      {Key? key,
      this.projectId,
      this.taskTitle,
      this.phase,
      this.taskDescription,
      this.pilot,
      this.copilot,
      this.startDate,
      this.endDate,
      this.status,
      this.priorityLevel})
      : super(key: key);

  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  final ProjectController projectController = Get.find();
  final ProfileController profileController = Get.find();
  final _uid = AuthController.instance.user!.uid;
  int _value = 1;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  String phaseValue = '';
  DateTime startdate = DateTime.now();
  DateTime endDate = DateTime.now();
  String taskPilot = '';
  String taskCoPilot = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: customAppBar(context, username: profileController.user['name']),
      endDrawer: const EndDrawerWidget(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(100, 30, 100, 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenHeight(context) * 0.05,
              ),
              txt(
                  txt: 'Edit task details here',
                  fontSize: 30,
                  fontColor: const Color(secondaryColor)),
              SizedBox(
                height: screenHeight(context) * 0.05,
              ),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth(context) * 0.07,
                    child: txt(
                      minFontSize: 18,
                      maxLines: 1,
                      txt: 'Task Title:',
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(
                    width: screenWidth(context) * 0.04,
                  ),
                  popUpTextField(context,
                      hint: widget.taskTitle, controller: titleController),
                ],
              ),
              SizedBox(
                height: screenHeight(context) * 0.03,
              ),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth(context) * 0.07,
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
                        hint: txt(txt: widget.phase!, fontSize: 14),
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
              ),
              SizedBox(
                height: screenHeight(context) * 0.03,
              ),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth(context) * 0.07,
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
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 5),
                      child: TextFormField(
                        maxLines: null,
                        controller: descriptionController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: widget.taskDescription,
                            hintStyle: const TextStyle(
                                color: Color(brownishColor),
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight(context) * 0.03,
              ),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth(context) * 0.07,
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
                              hintText:
                                  taskPilot == '' ? widget.pilot : taskPilot,
                              hintStyle: const TextStyle(
                                  color: Color(brownishColor),
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight(context) * 0.03,
              ),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth(context) * 0.07,
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
                              hintText: taskCoPilot == ''
                                  ? widget.copilot
                                  : taskCoPilot,
                              hintStyle: const TextStyle(
                                  color: Color(brownishColor),
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight(context) * 0.03,
              ),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth(context) * 0.07,
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
                        onTap: () async {
                          DateTime? newStartDate = await showDatePicker(
                            initialDate: DateTime.now(),
                            context: context,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                          );

                          if (newStartDate == null) {
                            return;
                          } else {
                            setState(() {
                              startdate = newStartDate;
                            });
                          }
                        },
                        child: TextFormField(
                          enabled: false,

                          maxLines: null,
                          // controller: commentController,
                          decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.date_range),
                              suffixIconColor: const Color(secondaryColor),
                              border: InputBorder.none,
                              hintText: startdate == DateTime.now()
                                  ? widget.startDate
                                  : '${startdate.year}/${startdate.month}/${startdate.day}',
                              hintStyle: const TextStyle(
                                  color: Color(brownishColor),
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight(context) * 0.03,
              ),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth(context) * 0.07,
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
                        onTap: () async {
                          DateTime? newEndDate = await showDatePicker(
                            initialDate: DateTime.now(),
                            context: context,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                          );

                          if (newEndDate == null) {
                            return;
                          } else {
                            setState(() {
                              endDate = newEndDate;
                            });
                          }
                        },
                        child: TextFormField(
                          enabled: false,

                          maxLines: null,
                          // controller: commentController,
                          decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.date_range),
                              suffixIconColor: const Color(secondaryColor),
                              border: InputBorder.none,
                              hintText: endDate == DateTime.now()
                                  ? widget.endDate
                                  : '${endDate.year}/${endDate.month}/${endDate.day}',
                              hintStyle: const TextStyle(
                                  color: Color(brownishColor),
                                  fontWeight: FontWeight.w600)),
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
                  fontColor: const Color(secondaryColor)),
              SizedBox(
                height: screenHeight(context) * 0.01,
              ),
              SizedBox(
                height: screenHeight(context) * 0.2,
                width: screenWidth(context) * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: screenWidth(context) * 0.07,
                          child: txt(
                            minFontSize: 18,
                            maxLines: 1,
                            txt: 'High priority',
                            fontSize: 30,
                          ),
                        ),
                        SizedBox(
                          height: screenHeight(context) * 0.04,
                        ),
                        Radio(
                            value: 1,
                            groupValue: _value,
                            onChanged: (val) {
                              setState(() {
                                _value = 1;
                              });
                            }),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: screenWidth(context) * 0.07,
                          child: txt(
                            minFontSize: 18,
                            maxLines: 1,
                            txt: 'Regular priority',
                            fontSize: 30,
                          ),
                        ),
                        SizedBox(
                          height: screenHeight(context) * 0.04,
                        ),
                        Radio(
                            value: 2,
                            groupValue: _value,
                            onChanged: (val) {
                              setState(() {
                                _value = 2;
                              });
                            }),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: screenWidth(context) * 0.07,
                          child: txt(
                            minFontSize: 18,
                            maxLines: 1,
                            txt: 'Future priority',
                            fontSize: 30,
                          ),
                        ),
                        SizedBox(
                          height: screenHeight(context) * 0.04,
                        ),
                        Radio(
                            value: 3,
                            groupValue: _value,
                            onChanged: (val) {
                              setState(() {
                                _value = 3;
                              });
                            }),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: screenWidth(context) * 0.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        print(titleController.text);
                        // if (titleController.text.isNotEmpty &&
                        //     descriptionController.text.isNotEmpty &&
                        //     taskCoPilot != widget.copilot &&
                        //     taskPilot != widget.pilot &&
                        //     '${startdate!.year}/${startdate!.month}/${startdate!.day}' !=
                        //         widget.startDate &&
                        //     '${endDate!.year}/${endDate!.month}/${endDate!.day}' !=
                        //         widget.endDate &&
                        //     phaseValue != widget.phase &&
                        //     _value != widget.priorityLevel) {
                        projectController.updateTask(
                            oldTaskDescription: widget.taskDescription,
                            oldTaskTitle: widget.taskTitle,
                            taskTitle: titleController.text.isEmpty
                                ? widget.taskTitle
                                : titleController.text,
                            phase: phaseValue == '' ? widget.phase : phaseValue,
                            taskDescription: descriptionController.text.isEmpty
                                ? widget.taskDescription
                                : descriptionController.text,
                            pilot: taskPilot == '' ? widget.pilot : taskPilot,
                            copilot: taskCoPilot == ''
                                ? widget.copilot
                                : taskCoPilot,
                            startDate:
                                '${startdate.year}/${startdate.month}/${startdate.day}',
                            endDate:
                                '${endDate.year}/${endDate.month}/${endDate.day}',
                            status: widget.status,
                            priorityLevel: _value);
                        Get.back();
                        // } else {
                        //   print('Please make some changes first');
                        //   // getErrorSnackBar(
                        //   //     "Please fillout all the details", '');
                        // }
                      },
                      child: Container(
                        width: screenWidth(context) * 0.1,
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
}
