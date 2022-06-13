import 'dart:html';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:projectx/constants/style.dart';
import 'package:projectx/controllers/auth_controller.dart';
import 'package:projectx/controllers/profile_controller.dart';
import 'package:projectx/controllers/project_controller.dart';
import 'package:projectx/pages/add_new_task.dart';
import 'package:projectx/pages/profile.dart';
import 'package:projectx/pages/recent_project.dart';
import 'package:projectx/pages/timeline.dart';
import 'package:projectx/widgets/asset_popup.dart';

import '../widgets/customAppBar.dart';
import 'board.dart';

class ProjectDashboard extends StatefulWidget {
  final String projectId;
  const ProjectDashboard({Key? key, required this.projectId}) : super(key: key);

  @override
  State<ProjectDashboard> createState() => _ProjectDashboardState();
}

class _ProjectDashboardState extends State<ProjectDashboard> {
  final ProjectController projectController = Get.put(ProjectController());
  final ProfileController profileController = Get.put(ProfileController());
  final _uid = AuthController.instance.user!.uid;
  final commentController = TextEditingController();

  bool isAssetsRefreshing = false;
  bool isCommentsRefreshing = false;

  @override
  void initState() {
    super.initState();
    projectController.updateProjectAndUserId(
        projectId: widget.projectId, uid: _uid);
    profileController.updateUserId(_uid);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectController>(
        init: ProjectController(),
        builder: (controller) {
          if (controller.project.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Scaffold(
                appBar: customAppBar(context),
                body: SizedBox(
                  height: screenHeight(context),
                  width: screenWidth(context),
                  child: Row(
                    children: [
                      Drawer(
                        child: Column(
                          children: <Widget>[
                            DrawerHeader(
                              margin: EdgeInsets.zero,
                              child: Center(
                                child: InkWell(
                                  onTap: () {
                                    addAssetPopUp(context);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.add,
                                        color: Color(brownishColor),
                                        size: 30,
                                      ),
                                      txt(
                                        txt: "ASSETS",
                                        fontSize: 30.0,
                                        fontColor: const Color(brownishColor),
                                        letterSpacing: 5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Obx(() {
                              return SizedBox(
                                height: screenHeight(context) * 0.6,
                                width: screenWidth(context) * 0.12,
                                child: projectController.isAssetUpdating.isTrue
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const CircularProgressIndicator(),
                                          txt(
                                              txt:
                                                  'Please wait\n Asset is being updated',
                                              fontSize: 14)
                                        ],
                                      )
                                    : ListView.builder(
                                        itemCount:
                                            projectController.assets.length,
                                        itemBuilder: (context, i) {
                                          String path = projectController
                                              .assets[i]['path'];
                                          return ListTile(
                                            leading: const Icon(
                                              Icons.link,
                                            ),
                                            title: txt(
                                                txt: path,
                                                fontSize: 14,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            trailing: InkWell(
                                                onTap: () async {
                                                  setState(() {
                                                    isAssetsRefreshing = true;
                                                  });
                                                  await projectController
                                                      .deleteProjectAsset(
                                                          path:
                                                              projectController
                                                                      .assets[i]
                                                                  ['path']);
                                                  setState(() {
                                                    isAssetsRefreshing = false;
                                                  });
                                                },
                                                child: const Icon(
                                                  Icons.delete_sharp,
                                                )),
                                            onTap: () {},
                                          );
                                        }),
                              );
                            }),
                            const Spacer(),
                            ListTile(
                                onTap: () {
                                  Get.to(AddNewTask(
                                    projectId: widget.projectId,
                                  ));
                                },
                                leading: const Icon(
                                  Icons.task,
                                ),
                                title: txt(txt: 'Add new task', fontSize: 14)),
                            ListTile(
                                leading: const Icon(
                                  Icons.person_add,
                                ),
                                title: txt(
                                    txt: 'Manage project members',
                                    fontSize: 14)),
                            const Divider(),
                            ListTile(
                              leading: InkWell(
                                onTap: () {
                                  Get.to(const RecentProjects());
                                },
                                child: const Icon(
                                  Icons.home,
                                  size: 50,
                                ),
                              ),
                              trailing: InkWell(
                                onTap: () {
                                  Get.to(const Timeline());
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
                      ),
                      Expanded(
                        flex: 5,
                        child: SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(50, 30, 50, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    txt(
                                      txt: projectController.project['title'],
                                      fontSize: 60,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 7,
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            txt(
                                              txt: 'LEAD :',
                                              fontSize: 20,
                                            ),
                                            txt(
                                              txt: 'CO-PILOT :',
                                              fontSize: 20,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: screenWidth(context) * 0.005,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            txt(
                                              txt: projectController
                                                  .project['lead'],
                                              fontSize: 20,
                                            ),
                                            txt(
                                              txt: projectController
                                                  .project['copilot'],
                                              fontSize: 20,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                txt(
                                  txt: projectController.project['subtitle'],
                                  fontSize: 30,
                                ),
                                SizedBox(
                                  height: screenHeight(context) * 0.05,
                                ),
                                Flexible(
                                  flex: 3,
                                  child: BoardSection(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GetBuilder<ProfileController>(
                          init: ProfileController(),
                          builder: (controller) {
                            if (controller.user.isEmpty) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return Expanded(
                                flex: 2,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white,
                                        offset: Offset(0, 3.0),
                                        blurRadius: 9.0,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        50, 30, 30, 80),
                                    child: Column(
                                      children: [
                                        txt(
                                          txt: 'NOTES',
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 5,
                                        ),
                                        SizedBox(
                                          height: screenHeight(context) * 0.03,
                                        ),
                                        Obx(() {
                                          return SizedBox(
                                              height:
                                                  screenHeight(context) * 0.55,
                                              width: screenWidth(context) * 0.3,
                                              child: projectController
                                                      .isUploading.isTrue
                                                  ? Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const CircularProgressIndicator(),
                                                        txt(
                                                            txt:
                                                                'Please wait\n Comment is being added',
                                                            fontSize: 14)
                                                      ],
                                                    )
                                                  : ListView.builder(
                                                      shrinkWrap: true,
                                                      reverse: true,
                                                      itemCount:
                                                          projectController
                                                              .comments.length,
                                                      itemBuilder:
                                                          (context, i) {
                                                        String comment =
                                                            projectController
                                                                .comments[i]
                                                                    ['comment']
                                                                .toString();
                                                        String type =
                                                            projectController
                                                                .comments[i]
                                                                    ['type']
                                                                .toString();
                                                        String username =
                                                            controller
                                                                .user['name'];
                                                        String firstChar = '';

                                                        for (int i = 0;
                                                            i < username.length;
                                                            i++) {
                                                          firstChar +=
                                                              username[i];
                                                        }

                                                        return usersMsg(context,
                                                            username:
                                                                firstChar[0],
                                                            type: type,
                                                            comment: comment);
                                                      }));
                                        }),
                                        const Spacer(),
                                        Container(
                                          width: screenWidth(context) * 0.2,
                                          height: screenHeight(context) * 0.2,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.16),
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
                                            child: TextFormField(
                                              maxLines: null,
                                              controller: commentController,
                                              decoration: InputDecoration(
                                                  suffixIcon: SizedBox(
                                                    width:
                                                        screenWidth(context) *
                                                            0.03,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Builder(
                                                            builder: (context) {
                                                          return InkWell(
                                                            onTap: () {
                                                              projectController
                                                                  .addNewCommentFile(
                                                                      projectId:
                                                                          widget
                                                                              .projectId,
                                                                      uid:
                                                                          _uid);
                                                            },
                                                            child: const Icon(
                                                                Icons
                                                                    .attach_file,
                                                                color: Color(
                                                                    brownishColor)),
                                                          );
                                                        }),
                                                        InkWell(
                                                          onTap: () async {
                                                            await projectController
                                                                .addNewComment(
                                                                    comment:
                                                                        commentController
                                                                            .text,
                                                                    projectId:
                                                                        widget
                                                                            .projectId,
                                                                    uid: _uid);
                                                            commentController
                                                                .clear();
                                                          },
                                                          child: const Icon(
                                                              Icons.send,
                                                              color: Color(
                                                                  brownishColor)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  border: InputBorder.none,
                                                  hintText: 'Add Comment...',
                                                  hintStyle: const TextStyle(
                                                      color:
                                                          Color(brownishColor),
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          })
                    ],
                  ),
                ));
          }
        });
  }

  Padding usersMsg(BuildContext context,
      {String? comment, String? type, String? username}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(brownishColor),
            maxRadius: 25,
            child: Center(
              child: txt(
                  txt: username!.capitalize.toString(),
                  fontSize: 20,
                  fontColor: Colors.white),
            ),
          ),
          SizedBox(
            width: screenWidth(context) * 0.005,
          ),
          type == 'text'
              ? Flexible(
                  child: txt(
                  txt: comment!,
                  fontSize: 20,
                  maxLines: 20,
                ))
              : InkWell(
                  onTap: () {
                    downloadFile(comment);
                  },
                  child: Container(
                    width: screenWidth(context) * 0.1,
                    height: screenHeight(context) * 0.05,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: const Color(secondaryColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.16),
                          offset: const Offset(0, 3.0),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.download,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: screenWidth(context) * 0.005,
                          ),
                          txt(
                              txt: 'click to download',
                              fontSize: 14,
                              fontColor: Colors.white),
                        ],
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }

  Container taskBox() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.23),
            offset: const Offset(0, 3.0),
            blurRadius: 9.0,
          ),
        ],
      ),
    );
  }

  downloadFile(url) {
    AnchorElement anchorElement = new AnchorElement(href: url);
    anchorElement.click();
  }
}
