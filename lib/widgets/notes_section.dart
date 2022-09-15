import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:Ava/controllers/project_controller.dart';
import 'package:Ava/widgets/usersmsg.dart';

import '../constants/style.dart';
import '../controllers/profile_controller.dart';
import 'loading_indicator.dart';

Expanded notesSection(BoxConstraints constraints, BuildContext context,
    {ScrollController? scrollController,
    ProjectController? projectController,
    ProfileController? profileController,
    TextEditingController? commentController}) {
  final notesSearchController = TextEditingController();

  return Expanded(
    flex: 2,
    child: GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (controller) {
          if (controller.user.isEmpty) {
            return const LoadingIndicator();
          } else {
            return Padding(
              padding: constraints.maxWidth < 800
                  ? const EdgeInsets.all(16.0)
                  : const EdgeInsets.fromLTRB(50, 30, 30, 80),
              child: Column(
                children: [
                  projectController!.isSearching.isTrue
                      ? Column(
                          children: [
                            SizedBox(
                              width: screenWidth(context) * 0.4,
                              height: screenHeight(context) * 0.05,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 15, top: 5),
                                child: TextFormField(
                                  autofocus: true,
                                  onChanged: ((value) {
                                    projectController.searchedNote.value =
                                        value;
                                  }),
                                  maxLines: 1,
                                  controller: notesSearchController,
                                  decoration: InputDecoration(
                                    suffixIconColor:
                                        projectController.isDarkTheme.value
                                            ? Colors.white54
                                            : const Color(brownishColor),
                                    suffixIcon: InkWell(
                                        onTap: (() {
                                          projectController.isSearching.value =
                                              false;
                                          projectController.searchedNote.value =
                                              '';
                                          notesSearchController.text = '';
                                          projectController.update();
                                        }),
                                        child: const Icon(Icons.close)),
                                    border: InputBorder.none,
                                    hintText: 'Search notes...',
                                    hintStyle: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                        overflow: TextOverflow.visible,
                                        letterSpacing: 0,
                                        color:
                                            projectController.isDarkTheme.value
                                                ? Colors.white54
                                                : const Color(brownishColor),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Obx(() {
                              return SizedBox(
                                  height: screenHeight(context) * 0.55,
                                  width: screenWidth(context) * 0.3,
                                  child: projectController
                                          .isCommentFileUpdatingBefore.isTrue
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const LoadingIndicator(),
                                            txt(
                                                txt:
                                                    'Please wait\n File is being uploaded',
                                                fontSize: 14)
                                          ],
                                        )
                                      : projectController.progress.value !=
                                                  100 &&
                                              projectController
                                                      .progress.value !=
                                                  0.0
                                          ? Stack(
                                              children: [
                                                Positioned.fill(
                                                    child: Opacity(
                                                  opacity: 0.5,
                                                  child: Container(
                                                      color: Colors.white),
                                                )),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                          height: 30,
                                                          width: 350,
                                                          child:
                                                              LiquidLinearProgressIndicator(
                                                                  value: projectController
                                                                          .progress
                                                                          .value /
                                                                      100,
                                                                  valueColor:
                                                                      const AlwaysStoppedAnimation(
                                                                          Color(
                                                                              secondaryColor)), // Defaults to the current Theme's accentColor.
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  borderColor:
                                                                      const Color(
                                                                          mainColor),
                                                                  borderWidth:
                                                                      5.0,
                                                                  borderRadius:
                                                                      12.0,
                                                                  direction: Axis
                                                                      .horizontal,
                                                                  center: txt(
                                                                      txt:
                                                                          "${projectController.progress.value.ceil()}%",
                                                                      fontSize:
                                                                          18))),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
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
                                                  .isCommentFileUpdatingAfter
                                                  .isTrue
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
                                              : projectController
                                                      .comments.isEmpty
                                                  ? Center(
                                                      child: txt(
                                                          txt:
                                                              'Add comments here',
                                                          fontSize: 14),
                                                    )
                                                  : projectController
                                                          .searchedNote.isEmpty
                                                      ? Center(
                                                          child: txt(
                                                              txt:
                                                                  'Please enter the desired note',
                                                              fontSize: 14),
                                                        )
                                                      : searchedNotesListViewBuilder(
                                                          scrollController,
                                                          projectController,
                                                        ));
                            }),
                          ],
                        )
                      : isNotSearchingColumn(constraints, projectController,
                          scrollController, context),
                  const Spacer(),
                  Container(
                    width: screenWidth(context) * 0.2,
                    height: screenHeight(context) * 0.2,
                    decoration: boxDecoration,
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
                                      await projectController.addNewCommentFile(
                                          username:
                                              profileController!.user['name'],
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
                                    child: Icon(
                                      Icons.attach_file,
                                      color: projectController.isDarkTheme.value
                                          ? Colors.white54
                                          : const Color(brownishColor),
                                    ),
                                  );
                                }),
                                InkWell(
                                  onTap: () async {
                                    if (commentController!.text.isNotEmpty) {
                                      await projectController.addNewComment(
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
                                  child: Icon(
                                    Icons.send,
                                    color: projectController.isDarkTheme.value
                                        ? Colors.white54
                                        : const Color(brownishColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          border: InputBorder.none,
                          hintText: 'Add Comment...',
                          hintStyle: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              overflow: TextOverflow.visible,
                              letterSpacing: 0,
                              color: projectController.isDarkTheme.value
                                  ? Colors.white54
                                  : const Color(brownishColor),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }),
  );
}

Column isNotSearchingColumn(
    BoxConstraints constraints,
    ProjectController? projectController,
    ScrollController? scrollController,
    BuildContext context) {
  return Column(
    children: [
      Row(
        children: [
          const Spacer(),
          txt(
            txt: 'NOTES',
            fontSize: 50,
            font: 'comfortaa',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            minFontSize: constraints.maxWidth < 800 ? 24 : 40,
            fontWeight: FontWeight.bold,
            letterSpacing: 5,
          ),

          const Spacer(),
          InkWell(
            onTap: (() {
              projectController!.isSearching.value = true;
              projectController.update();
            }),
            child: Icon(
              Icons.search,
              color: projectController!.isDarkTheme.value
                  ? Colors.white54
                  : const Color(brownishColor),
            ),
          ),

          PopupMenuButton(
            tooltip: 'Filter notes',
            onSelected: (value) async {
              if (value == 1) {
                projectController.commentsFilter.value = 1;
                projectController.update();
                scrollController?.animateTo(
                    scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut);
              } else if (value == 2) {
                projectController.commentsFilter.value = 2;
                projectController.update();
              } else {
                projectController.commentsFilter.value = 3;
                projectController.update();
                scrollController?.animateTo(
                    scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut);
              }
            },
            elevation: 3.2,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(value: 1, child: popText('All notes')),
              PopupMenuItem(value: 2, child: popText('Text only')),
              PopupMenuItem(value: 3, child: popText('Media only')),
            ],
            child: Icon(
              Icons.filter_alt_outlined,
              color: projectController.isDarkTheme.value
                  ? Colors.white54
                  : const Color(brownishColor),
            ),
          ),
          // Spacer(),
        ],
      ),
      SizedBox(
        height: screenHeight(context) * 0.03,
      ),
      Obx(() {
        return SizedBox(
            height: screenHeight(context) * 0.55,
            width: screenWidth(context) * 0.3,
            child: projectController.isCommentFileUpdatingBefore.isTrue
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const LoadingIndicator(),
                      txt(
                          txt: 'Please wait\n File is being uploaded',
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: 30,
                                    width: 350,
                                    child: LiquidLinearProgressIndicator(
                                        value:
                                            projectController.progress.value /
                                                100,
                                        valueColor:
                                            const AlwaysStoppedAnimation(Color(
                                                secondaryColor)), // Defaults to the current Theme's accentColor.
                                        backgroundColor: Colors.white,
                                        borderColor: const Color(mainColor),
                                        borderWidth: 5.0,
                                        borderRadius: 12.0,
                                        direction: Axis.horizontal,
                                        center: txt(
                                            txt:
                                                "${projectController.progress.value.ceil()}%",
                                            fontSize: 18))),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
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
                    : projectController.isCommentFileUpdatingAfter.isTrue
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const LoadingIndicator(),
                              txt(
                                  txt: 'Uploading, Almost finished',
                                  fontSize: 14)
                            ],
                          )
                        : projectController.comments.isEmpty
                            ? Center(
                                child:
                                    txt(txt: 'Add comments here', fontSize: 14),
                              )
                            : notesListViewBuilder(
                                scrollController, projectController));
      }),
    ],
  );
}

ListView notesListViewBuilder(
    ScrollController? scrollController, ProjectController projectController) {
  return ListView.builder(
      controller: scrollController,
      itemCount: projectController.comments.length,
      itemBuilder: (context, i) {
        String comment = projectController.comments[i]['comment'].toString();
        String type = projectController.comments[i]['type'].toString();
        String username = projectController.comments[i]['username'].toString();
        String filename = projectController.comments[i]['filename'].toString();
        var created = !kIsWeb
            ? projectController.comments[i]['created']
            : (projectController.comments[i]['created'] as Timestamp).toDate();

        String firstChar = '';

        for (int i = 0; i < username.length; i++) {
          firstChar += username[i];
        }

        if (projectController.commentsFilter.value == 1) {
          return usersMsg(context,
              created: created,
              username: username,
              filename: filename,
              nameFirstChar: firstChar[0],
              type: type,
              comment: comment);
        } else if (projectController.commentsFilter.value == 2) {
          return projectController.comments[i]['type'].toString() == 'text'
              ? usersMsg(context,
                  created: created,
                  username: username,
                  filename: filename,
                  nameFirstChar: firstChar[0],
                  type: type,
                  comment: comment)
              : Container();
        } else {
          return projectController.comments[i]['type'].toString() != 'text'
              ? usersMsg(context,
                  created: created,
                  username: username,
                  filename: filename,
                  nameFirstChar: firstChar[0],
                  type: type,
                  comment: comment)
              : Container();
        }
      });
}

ListView searchedNotesListViewBuilder(
  ScrollController? scrollController,
  ProjectController projectController,
) {
  return ListView.builder(
      controller: scrollController,
      itemCount: projectController.comments.length,
      itemBuilder: (context, i) {
        String comment = projectController.comments[i]['comment'].toString();
        String type = projectController.comments[i]['type'].toString();
        String username = projectController.comments[i]['username'].toString();
        String filename = projectController.comments[i]['filename'].toString();
        var created = !kIsWeb
            ? projectController.comments[i]['created']
            : (projectController.comments[i]['created'] as Timestamp).toDate();

        String firstChar = '';

        for (int i = 0; i < username.length; i++) {
          firstChar += username[i];
        }
        if (comment.contains(projectController.searchedNote.value)) {
          return usersMsg(context,
              created: created,
              username: username,
              filename: filename,
              nameFirstChar: firstChar[0],
              type: type,
              comment: comment);
        } else {
          return Container();
        }
      });
}
