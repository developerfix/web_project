import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:projectx/controllers/project_controller.dart';
import 'package:projectx/widgets/usersmsg.dart';

import '../constants/style.dart';
import '../controllers/profile_controller.dart';
import 'loading_indicator.dart';

Expanded notesSection(BoxConstraints constraints, BuildContext context,
    {ScrollController? scrollController,
    ProjectController? projectController,
    ProfileController? profileController,
    TextEditingController? commentController}) {
  return Expanded(
    flex: 2,
    child: GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (controller) {
          if (controller.user.isEmpty) {
            return const LoadingIndicator();
          } else {
            return Container(
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
                padding: constraints.maxWidth < 800
                    ? const EdgeInsets.all(16.0)
                    : const EdgeInsets.fromLTRB(50, 30, 30, 80),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        scrollController!.animateTo(
                            scrollController.position.maxScrollExtent,
                            duration: const Duration(seconds: 2),
                            curve: Curves.easeOut);
                      },
                      child: txt(
                        txt: 'NOTES',
                        fontSize: 50,
                        font: 'comfortaa',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        minFontSize: constraints.maxWidth < 800 ? 24 : 40,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 5,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight(context) * 0.03,
                    ),
                    Obx(() {
                      return SizedBox(
                          height: screenHeight(context) * 0.55,
                          width: screenWidth(context) * 0.3,
                          child: projectController!
                                  .isCommentFileUpdatingBefore.isTrue
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const LoadingIndicator(),
                                    txt(
                                        txt:
                                            'Please wait\n File is being uploaded',
                                        fontSize: 14)
                                  ],
                                )
                              : projectController.progress.value != 100 &&
                                      projectController.progress.value != 0.0
                                  ? Stack(
                                      children: [
                                        Positioned.fill(
                                            child: Opacity(
                                          opacity: 0.5,
                                          child: Container(color: Colors.white),
                                        )),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                  height: 30,
                                                  width: 350,
                                                  child:
                                                      LiquidLinearProgressIndicator(
                                                          value:
                                                              projectController
                                                                      .progress
                                                                      .value /
                                                                  100,
                                                          valueColor:
                                                              const AlwaysStoppedAnimation(
                                                                  Color(
                                                                      secondaryColor)), // Defaults to the current Theme's accentColor.
                                                          backgroundColor:
                                                              Colors.white,
                                                          borderColor:
                                                              const Color(
                                                                  mainColor),
                                                          borderWidth: 5.0,
                                                          borderRadius: 12.0,
                                                          direction:
                                                              Axis.horizontal,
                                                          center: txt(
                                                              txt:
                                                                  "${projectController.progress.value.ceil()}%",
                                                              fontSize: 18))),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: txt(
                                                    txt:
                                                        'Please wait\n File is being uploaded',
                                                    fontSize: 14),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : projectController
                                          .isCommentFileUpdatingAfter.isTrue
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const LoadingIndicator(),
                                            txt(
                                                txt:
                                                    'Uploading, Almost finished',
                                                fontSize: 14)
                                          ],
                                        )
                                      : projectController.comments.isEmpty
                                          ? Center(
                                              child: txt(
                                                  txt: 'Add comments here',
                                                  fontSize: 14),
                                            )
                                          : ListView.builder(
                                              controller: scrollController,
                                              itemCount: projectController
                                                  .comments.length,
                                              itemBuilder: (context, i) {
                                                String comment =
                                                    projectController
                                                        .comments[i]['comment']
                                                        .toString();
                                                String type = projectController
                                                    .comments[i]['type']
                                                    .toString();
                                                String username =
                                                    projectController
                                                        .comments[i]['username']
                                                        .toString();
                                                String filename =
                                                    projectController
                                                        .comments[i]['filename']
                                                        .toString();
                                                var created = !kIsWeb
                                                    ? projectController
                                                        .comments[i]['created']
                                                    : (projectController
                                                                    .comments[i]
                                                                ['created']
                                                            as Timestamp)
                                                        .toDate();

                                                String firstChar = '';

                                                for (int i = 0;
                                                    i < username.length;
                                                    i++) {
                                                  firstChar += username[i];
                                                }

                                                return usersMsg(context,
                                                    created: created,
                                                    username: username,
                                                    filename: filename,
                                                    nameFirstChar: firstChar[0],
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
                          controller: commentController,
                          decoration: InputDecoration(
                            suffixIcon: SizedBox(
                              width: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Builder(builder: (context) {
                                    return InkWell(
                                      onTap: () async {
                                        await projectController!
                                            .addNewCommentFile(
                                                username: profileController!
                                                    .user['name'],
                                                created: !kIsWeb
                                                    ? DateTime.now()
                                                    : Timestamp.now());

                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          if (scrollController!.hasClients) {
                                            scrollController.animateTo(
                                                scrollController
                                                    .position.maxScrollExtent,
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                curve: Curves.easeOut);
                                          }
                                        });
                                      },
                                      child: const Icon(Icons.attach_file,
                                          color: Color(brownishColor)),
                                    );
                                  }),
                                  InkWell(
                                    onTap: () async {
                                      if (commentController!.text.isNotEmpty) {
                                        await projectController!.addNewComment(
                                            comment: commentController.text,
                                            username:
                                                profileController!.user['name'],
                                            created: !kIsWeb
                                                ? DateTime.now()
                                                : Timestamp.now());
                                        commentController.clear();

                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          if (scrollController!.hasClients) {
                                            scrollController.animateTo(
                                                scrollController
                                                    .position.maxScrollExtent,
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                curve: Curves.easeOut);
                                          }
                                        });
                                      }
                                    },
                                    child: const Icon(Icons.send,
                                        color: Color(brownishColor)),
                                  ),
                                ],
                              ),
                            ),
                            border: InputBorder.none,
                            hintText: 'Add Comment...',
                            hintStyle: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                overflow: TextOverflow.visible,
                                letterSpacing: 0,
                                color: Color(brownishColor),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }),
  );
}
