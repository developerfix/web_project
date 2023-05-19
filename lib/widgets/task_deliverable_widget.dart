import 'package:ava/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/project_controller.dart';
import 'loading_indicator.dart';

StatefulBuilder taskDeliverablesWidget(
  BuildContext context,
) {
  final ProjectController projectController = Get.find<ProjectController>();
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
                    projectController
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
                        : projectController
                                        .deliverableUplaodingProgress.value !=
                                    100 &&
                                projectController
                                        .deliverableUplaodingProgress.value !=
                                    0.0
                            ? SizedBox(
                                height: 40,
                                width: 350,
                                child: LinearProgressIndicator(
                                  minHeight: 20,
                                  backgroundColor: const Color(secondaryColor),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Color(mainColor)),
                                  value: projectController
                                          .deliverableUplaodingProgress.value /
                                      100,
                                ),
                              )
                            : projectController
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
                                : projectController.selectedDeliverables.isEmpty
                                    ? ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  const Color(secondaryColor)),
                                        ),
                                        onPressed: () {
                                          // addTaskDeliverables()
                                          projectController
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
                                                  itemCount: projectController
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
                                                                  txt: projectController
                                                                              .selectedDeliverables[
                                                                          index]
                                                                      [
                                                                      'filename'],
                                                                  maxLines: 2,
                                                                  fontSize: 16),
                                                            ),
                                                            InkWell(
                                                                onTap: () {
                                                                  projectController
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
                                                projectController
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
