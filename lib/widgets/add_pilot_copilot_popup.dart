// import 'package:ava/controllers/profile_controller.dart';
// import 'package:ava/widgets/popup_button.dart';
// import 'package:ava/widgets/users_selection_textfield.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ava/controllers/project_controller.dart';

// import '../constants/style.dart';
// import '../models/project_member.dart';

// String categoryValue = '3D Design';
// Future<dynamic> addPilotCopilotPopUp(
//   BuildContext context,
// ) {
//   final ProfileController profileController = Get.find<ProfileController>();
//   final ProjectController projectController = Get.find<ProjectController>();
//   String taskPilot = 'select team member';
//   String taskCoPilot = 'select team member';
//   List<ProjectMember> initialProjectMembers = [];

//   final formKey = GlobalKey<FormState>();

//   return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return GetBuilder<ProjectController>(
//             init: ProjectController(),
//             builder: (controller) {
//               var uid = profileController.currentUser.value.uid;
//               return Form(
//                   key: formKey,
//                   child: AlertDialog(
//                       content: SingleChildScrollView(
//                     child: StatefulBuilder(
//                       builder: (context, setState) => SizedBox(
//                         height: screenHeight(context) *
//                             (profileController.projectCategory.value ==
//                                     newProjectCategory
//                                 ? 0.6
//                                 : 0.5),
//                         width: 1000,
//                         child: Column(
//                           children: [
//                             popUpCloseButton,
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(20.0),
//                                 child: Column(
//                                   children: <Widget>[
//                                     txt(
//                                       txt: 'Update Pilot/Copilot',
//                                       fontSize: 50,
//                                       fontColor: const Color(0XFFab9eab),
//                                       font: 'Comfortaa',
//                                       letterSpacing: 6,
//                                       fontWeight: FontWeight.w700,
//                                     ),
//                                     const Padding(
//                                       padding: EdgeInsets.only(top: 10),
//                                       child: Divider(
//                                           thickness: 3,
//                                           color: Color(0xffab9eab)),
//                                     ),
//                                     Expanded(
//                                         child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceEvenly,
//                                       children: [
//                                         itemRow(context,
//                                             widget: usersSelectionTextField(
//                                               context,
//                                               isPilot: true,
//                                               taskPilotorCopit: taskPilot,
//                                               title:
//                                                   'Select Pilot for this Project',
//                                             ),
//                                             title: 'Pilot'),
//                                         itemRow(context,
//                                             widget: usersSelectionTextField(
//                                               context,
//                                               isPilot: false,
//                                               taskPilotorCopit: taskCoPilot,
//                                               title:
//                                                   'Select CoPilot for this Project',
//                                             ),
//                                             title: 'Copilot'),
//                                       ],
//                                     )),
//                                     SizedBox(
//                                       height: screenHeight(context) * 0.025,
//                                     ),
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       children: [
//                                         popupButton(context, ontap: () {
//                                           if (formKey.currentState!
//                                               .validate()) {
//                                             if (projectController.projectPilot
//                                                     .value.isNotEmpty &&
//                                                 projectController.projectCoPilot
//                                                     .value.isNotEmpty) {
//                                               for (var user
//                                                   in projectController.users) {
//                                                 if (user['name'] ==
//                                                         projectController
//                                                             .projectPilot
//                                                             .value ||
//                                                     user['name'] ==
//                                                         projectController
//                                                             .projectCoPilot
//                                                             .value ||
//                                                     user['uid'] == uid) {
//                                                   initialProjectMembers.add(
//                                                       ProjectMember(
//                                                           uid: user['uid'],
//                                                           username:
//                                                               user['name']));
//                                                 }
//                                               }
//                                               projectController
//                                                   .updatingPilotCopilot(
//                                                       projectMembers:
//                                                           initialProjectMembers,
//                                                       pilot: projectController
//                                                           .projectPilot.value,
//                                                       copilot: projectController
//                                                           .projectCoPilot
//                                                           .value);
//                                             } else {
//                                               getErrorSnackBar(
//                                                 "Please select pilot and copilot for the project",
//                                               );
//                                             }
//                                           }
//                                         }, text: 'Update'),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   )));
//             });
//       });
// }

// Row itemRow(BuildContext context,
//     {required Widget widget, required String title}) {
//   return Row(
//     children: [
//       txt(
//         txt: '$title:',
//         fontSize: 30,
//       ),
//       const Spacer(),
//       widget,
//       // const Spacer(),
//     ],
//   );
// }
