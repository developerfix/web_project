import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hovering/hovering.dart';
import 'package:Ava/controllers/project_controller.dart';
import 'package:Ava/widgets/edit_asset_popup.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/style.dart';
import '../pages/project_members.dart';
import '../pages/recent_project.dart';
import '../pages/timeline.dart';
import 'add_new_task_popup.dart';
import 'asset_popup.dart';

StatefulBuilder assetsSection(
  BuildContext context, {
  ProjectController? projectController,
}) {
  return StatefulBuilder(builder: (context, setState) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            margin: EdgeInsets.zero,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  txt(
                    txt: "ASSETS",
                    font: 'comfortaa',
                    fontSize: 30.0,
                    letterSpacing: 5,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ),
          ),
          Obx(() {
            return Column(
              children: [
                SizedBox(
                  height: screenHeight(context) * 0.65,
                  width: screenWidth(context) * 0.12,
                  child: ListView.builder(
                      itemCount: projectController!.assets.length,
                      itemBuilder: (context, i) {
                        String path = projectController.assets[i]['path'];
                        String pathName =
                            projectController.assets[i]['pathName'];
                        return HoverCrossFadeWidget(
                          cursor: SystemMouseCursors.click,
                          duration: const Duration(milliseconds: 100),
                          firstChild: ListTile(
                              onTap: () async {
                                await canLaunchUrl(Uri.parse(path))
                                    ? await launchUrl(Uri.parse(path))
                                    : null;
                              },
                              title: Center(
                                child: txt(
                                    txt: pathName,
                                    fontSize: 14,
                                    // fontColor: const Color(secondaryColor),
                                    overflow: TextOverflow.ellipsis),
                              ),
                              trailing: const Icon(Icons.more_horiz,
                                  color: Colors.white, size: 18)),
                          secondChild: ListTile(
                            onTap: () async {
                              await canLaunchUrl(Uri.parse(path))
                                  ? await launchUrl(Uri.parse(path))
                                  : null;
                            },
                            title: Center(
                              child: txt(
                                  txt: pathName,
                                  fontSize: 14,
                                  fontColor: const Color(secondaryColor),
                                  overflow: TextOverflow.ellipsis),
                            ),
                            trailing: PopupMenuButton(
                                onSelected: (value) async {
                                  if (value == 1) {
                                    editAssetPopUp(context,
                                        path: path, pathName: pathName);
                                  } else {
                                    await projectController.deleteProjectAsset(
                                        path: projectController.assets[i]
                                            ['path']);
                                  }
                                },
                                elevation: 3.2,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                                itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 1,
                                        child: Text(
                                          'Edit',
                                          maxLines: 1,
                                          style: GoogleFonts.montserrat(
                                            textStyle: const TextStyle(
                                              fontSize: 14,
                                              overflow: TextOverflow.visible,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 2,
                                        child: Text(
                                          'Delete',
                                          maxLines: 1,
                                          style: GoogleFonts.montserrat(
                                            textStyle: const TextStyle(
                                              fontSize: 14,
                                              overflow: TextOverflow.visible,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                child: const Icon(Icons.more_horiz,
                                    color: Color(
                                      secondaryColor,
                                    ),
                                    size: 18)),
                          ),

                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Row(
                          //     mainAxisAlignment:
                          //         MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       const Icon(
                          //         Icons.link,
                          //         color: Color(secondaryColor),
                          //       ),
                          //       txt(
                          //           txt: pathName,
                          //           fontSize: 14,
                          //           fontColor: const Color(secondaryColor),
                          //           overflow: TextOverflow.ellipsis),
                          //       PopupMenuButton(
                          //           onSelected: (value) async {
                          //             if (value == 1) {
                          //               Get.to(editAssetPopUp(context,
                          //                   path: path, pathName: pathName));
                          //             } else {
                          //               await projectController
                          //                   .deleteProjectAsset(
                          //                       path: projectController
                          //                           .assets[i]['path']);
                          //             }
                          //           },
                          //           elevation: 3.2,
                          //           shape: const RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.all(
                          //                 Radius.circular(8.0)),
                          //           ),
                          //           itemBuilder: (context) => [
                          //                 PopupMenuItem(
                          //                   value: 1,
                          //                   child: Text(
                          //                     'Edit',
                          //                     maxLines: 1,
                          //                     style: GoogleFonts.montserrat(
                          //                       textStyle: const TextStyle(
                          //                         fontSize: 14,
                          //                         overflow:
                          //                             TextOverflow.visible,
                          //                         fontWeight: FontWeight.w600,
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 ),
                          //                 PopupMenuItem(
                          //                   value: 2,
                          //                   child: Text(
                          //                     'Delete',
                          //                     maxLines: 1,
                          //                     style: GoogleFonts.montserrat(
                          //                       textStyle: const TextStyle(
                          //                         fontSize: 14,
                          //                         overflow:
                          //                             TextOverflow.visible,
                          //                         fontWeight: FontWeight.w600,
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 ),
                          //               ],
                          //           child: const Icon(Icons.more_horiz,
                          //               color: Color(
                          //                 secondaryColor,
                          //               ),
                          //               size: 18))
                          //     ],
                          //   ),
                          // ),
                        );
                      }),
                ),
                InkWell(
                  onTap: () {
                    addAssetPopUp(context);
                  },
                  child: const Center(
                    child: Icon(
                      Icons.add,
                      size: 50,
                    ),
                  ),
                ),
              ],
            );
          }),
          const Spacer(),
          ListTile(
              onTap: () {
                projectController!.selectedDeliverables.clear();
                projectController.phaseValue.value = '3D Design';
                addNewTaskPopUp(context);
              },
              leading: const Icon(
                Icons.task,
              ),
              title: txt(txt: 'Add new task', fontSize: 14)),
          ListTile(
              onTap: () {
                Get.to(() => const ProjectMembersList());
              },
              leading: const Icon(
                Icons.person_add,
              ),
              title: txt(txt: 'Manage project members', fontSize: 14)),
          const Divider(),
          ListTile(
            leading: InkWell(
              onTap: () {
                Get.to(() => const RecentProjects());
              },
              child: const Icon(
                Icons.home,
                size: 50,
              ),
            ),
            trailing: InkWell(
              onTap: () {
                Get.to(() => const Timeline());
              },
              child: const Icon(
                Icons.timeline,
                size: 50,
              ),
            ),
            onTap: null,
          ),
          SizedBox(height: screenHeight(context) * 0.01)
        ],
      ),
    );
  });
}
