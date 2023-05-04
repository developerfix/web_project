import 'package:ava/controllers/auth_controller.dart';
import 'package:ava/controllers/project_controller.dart';
import 'package:ava/widgets/popup_button.dart';
import 'package:get/get.dart';
import '../constants/style.dart';
import 'package:flutter/material.dart';

import 'asset_catagory_widgets.dart';
import 'asset_files_widget.dart';

Future<dynamic> addFileAssetPopUp(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  final ProjectController projectController = Get.find();
  final categoryTitleController = TextEditingController();
  final AuthController authController = Get.find();
  projectController.selectedAssetFiles.clear();

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Form(
            key: formKey,
            child: AlertDialog(
                content: SingleChildScrollView(
              child: StatefulBuilder(
                builder: (context, setState) => SizedBox(
                  height: screenHeight(context) *
                      (projectController.assetCategory.value == newAssetCategory
                          ? 0.6
                          : 0.5),
                  width: 1000,
                  child: Obx(
                    () => Column(
                      children: [
                        popUpCloseButton,
                        Expanded(
                          child: Padding(
                            padding: screenWidth(context) < 800
                                ? const EdgeInsets.all(8.0)
                                : const EdgeInsets.all(20.0),
                            child: Column(children: <Widget>[
                              txt(
                                txt: 'UPLOAD FILES',
                                font: 'comfortaa',
                                fontSize: screenWidth(context) < 800 ? 20 : 40,
                                letterSpacing: 6,
                                fontWeight: FontWeight.w700,
                              ),
                              const Spacer(),
                              assetFilesWidget(context),
                              SizedBox(
                                height: screenHeight(context) * 0.04,
                              ),
                              projectController.selectedAssetFiles.isEmpty
                                  ? Container()
                                  : categoryDropDown(context, authController,
                                      setState, projectController),
                              projectController.assetCategory.value ==
                                      newAssetCategory
                                  ? newCategoryTextField(
                                      context, categoryTitleController)
                                  : Container(),
                              SizedBox(
                                height: screenHeight(context) * 0.04,
                              ),
                              const Spacer(),
                              projectController.selectedAssetFiles.isEmpty
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment:
                                          screenWidth(context) < 1000
                                              ? MainAxisAlignment.start
                                              : MainAxisAlignment.end,
                                      children: [
                                        popupButton(context, ontap: () {
                                          bool isUploading = false;
                                          projectController
                                              .selectedAssetFilesUploadProgress
                                              .forEach((key, value) {
                                            if (value != null &&
                                                value >= 0 &&
                                                value < 100) {
                                              isUploading = true;
                                            }
                                          });
                                          if (!isUploading) {
                                            Get.back();
                                            for (var file in projectController
                                                .selectedAssetFiles) {
                                              projectController.addNewAsset(
                                                  path: file['urlDownload'],
                                                  type: fileAssetType,
                                                  pathName: file['filename'],
                                                  assetCategoryTitle: projectController
                                                              .assetCategory
                                                              .value ==
                                                          newAssetCategory
                                                      ? (categoryTitleController
                                                              .text.isEmpty
                                                          ? 'Category'
                                                          : categoryTitleController
                                                              .text)
                                                      : projectController
                                                          .assetCategory.value);
                                            }
                                          } else {
                                            getErrorSnackBar(
                                                'Please wait, The file is being uploaded');
                                          }
                                        }, text: 'Add'),
                                      ],
                                    ),
                              SizedBox(
                                height: screenHeight(context) * 0.005,
                              )
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )));
      });
}
