// import 'dart:html';

// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:projectx/constants/style.dart';
// import 'package:projectx/controllers/auth_controller.dart';
// import 'package:projectx/controllers/profile_controller.dart';
// import 'package:projectx/widgets/customAppBar.dart';

// import '../widgets/loadingIndicator.dart';

// class Profile extends StatefulWidget {
//   const Profile({Key? key}) : super(key: key);

//   @override
//   State<Profile> createState() => _ProfileState();
// }

// class _ProfileState extends State<Profile> {
//   final ProfileController profileController = Get.put(ProfileController());
//   final _uid = AuthController.instance.user!.uid;

//   @override
//   void initState() {
//     super.initState();
//     profileController.updateUserId(_uid);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<ProfileController>(
//         init: ProfileController(),
//         builder: (controller) {
//           if (controller.user.isEmpty) {
//             return LoadingIndicator();
//           } else {
//             return Scaffold(
//               appBar: customAppBar(context),
//               body: Column(
//                 children: [
//                   SizedBox(
//                     height: screenHeight(context) * 0.05,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         width: screenWidth(context) * 0.1,
//                         height: screenHeight(context) * 0.15,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8.0),
//                           color: const Color(secondaryColor),
//                         ),
//                       ),
//                       SizedBox(
//                         width: screenWidth(context) * 0.02,
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           txt(txt: controller.user['name'], fontSize: 22),
//                           txt(txt: controller.user['email'], fontSize: 22),
//                           txt(
//                               txt:
//                                   'Projects: ${controller.user['noOfProjects']}',
//                               fontSize: 22),
//                         ],
//                       )
//                     ],
//                   ),
//                   SizedBox(
//                     height: screenHeight(context) * 0.03,
//                   ),
//                   Container(
//                       width: screenWidth(context) * 0.3,
//                       height: screenHeight(context) * 0.1,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8.0),
//                         color: const Color(secondaryColor),
//                       ),
//                       child: Center(
//                           child: txt(
//                               txt: 'Projects List',
//                               fontSize: 22,
//                               fontColor: Colors.white))),
//                   SizedBox(
//                     height: screenHeight(context) * 0.01,
//                   ),
//                   InkWell(
//                     onTap: () {
//                       AuthController.instance.signOut();
//                     },
//                     child: Container(
//                         width: screenWidth(context) * 0.3,
//                         height: screenHeight(context) * 0.1,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8.0),
//                           color: const Color(secondaryColor),
//                         ),
//                         child: Center(
//                             child: txt(
//                                 txt: 'Logout',
//                                 fontSize: 22,
//                                 fontColor: Colors.white))),
//                   ),
//                 ],
//               ),
//             );
//           }
//         });
//   }
// }
