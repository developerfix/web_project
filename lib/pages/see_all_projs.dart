// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:Ava/constants/style.dart';
// import 'package:Ava/pages/project_dashboard.dart';
// import 'package:Ava/widgets/custom_appbar.dart';

// import '../controllers/profile_controller.dart';
// import '../widgets/custom_drawer.dart';
// import '../widgets/project_box.dart';

// class SeeAllProjects extends StatefulWidget {
//   const SeeAllProjects({Key? key}) : super(key: key);

//   @override
//   State<SeeAllProjects> createState() => _SeeAllProjectsState();
// }

// class _SeeAllProjectsState extends State<SeeAllProjects> {
//   final GlobalKey<ScaffoldState> _key = GlobalKey();
//   final ProfileController profileController = Get.find();
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       return Scaffold(
//         key: _key,
//         endDrawer: const EndDrawerWidget(),
//         appBar: customAppBar(
//           context,
//           username: profileController.user['name'],
//           title: txt(
//               txt: 'List of projects', fontSize: 18, fontColor: Colors.white),
//         ),
//         backgroundColor: const Color(mainColor),
//         body: SizedBox(
//           height: screenHeight(context),
//           width: screenWidth(context),
//           child: Expanded(
//             child: GridView.builder(
//                 padding: const EdgeInsets.all(20.0),
//                 gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
//                     maxCrossAxisExtent: 200,
//                     childAspectRatio: 2 / 2,
//                     crossAxisSpacing: 30,
//                     mainAxisSpacing: 30),
//                 itemCount: profileController.projects.length,
//                 itemBuilder: (BuildContext ctx, index) {
//                   String projectTitle =
//                       profileController.projects[index]['title'];
//                   String projectId =
//                       profileController.projects[index]['projectId'];
//                   return InkWell(
//                     onTap: (() {
//                       Get.to(() => ProjectDashboard(
//                             projectId: projectId,
//                           ));
//                     }),
//                     child: projectBox(text: projectTitle),
//                   );
//                 }),
//           ),
//         ),
//       );
//     });
//   }
// }
