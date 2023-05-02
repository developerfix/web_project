import 'package:ava/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/project_controller.dart';

GetBuilder assetFilesWidget(
  BuildContext context,
) {
  return GetBuilder<ProjectController>(
      init: ProjectController(),
      builder: (controller) => SizedBox(
          child: controller.selectedAssetFiles.isEmpty
              ? uploadButton(controller)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenWidth(context) * 0.1,
                      child: txt(
                        minFontSize: 18,
                        maxLines: 1,
                        txt: 'Selected Files:',
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(
                      width: screenWidth(context) * 0.04,
                    ),
                    SizedBox(
                      height: 300,
                      width: 500,
                      child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: controller.selectedAssetFiles.length,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  childAspectRatio: 2,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20),
                          itemBuilder: ((context, index) {
                            return controller.selectedAssetFilesUploadProgress[
                                            controller.selectedAssetFiles[index]
                                                ['filename']] !=
                                        null &&
                                    controller.selectedAssetFilesUploadProgress[
                                            controller.selectedAssetFiles[index]
                                                ['filename']] >=
                                        0 &&
                                    controller.selectedAssetFilesUploadProgress[
                                            controller.selectedAssetFiles[index]
                                                ['filename']] <
                                        100
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        txt(
                                            txt: controller
                                                    .selectedAssetFiles[index]
                                                ['filename'],
                                            maxLines: 1,
                                            fontSize: 16),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Stack(
                                            children: [
                                              LinearProgressIndicator(
                                                minHeight: 20,
                                                backgroundColor:
                                                    Color(secondaryColor),
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                            Color>(
                                                        Color(mainColor)),
                                                value: double.parse(controller
                                                    .selectedAssetFilesUploadProgress[
                                                        controller
                                                                .selectedAssetFiles[
                                                            index]['filename']]
                                                    .toString()),
                                              ),
                                              Center(
                                                child: Text(
                                                  '${controller.selectedAssetFilesUploadProgress[controller.selectedAssetFiles[index]['filename']]}%',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ])
                                : Container(
                                    margin: const EdgeInsets.all(8.0),
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(border: Border.all(color: const Color(secondaryColor))),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: txt(
                                              txt: controller
                                                      .selectedAssetFiles[index]
                                                  ['filename'],
                                              maxLines: 2,
                                              fontSize: 16),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              controller.selectedAssetFiles
                                                  .removeAt(index);
                                            },
                                            child: const Icon(Icons.close))
                                      ],
                                    ));
                          })),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.addFileInAsset();
                      },
                      child: const Icon(
                        Icons.attach_file,
                        color: Color(secondaryColor),
                      ),
                    ),
                  ],
                )));
}

Row uploadButton(ProjectController controller) {
  return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(const Color(secondaryColor)),
              minimumSize: MaterialStateProperty.all(Size(300, 80)),
            ),
            onPressed: () {
              controller.addFileInAsset();
            },
            child: Center(
              child: txt(txt: 'upload', fontColor: Colors.white, fontSize: 22),
            ))
      ]);
}
