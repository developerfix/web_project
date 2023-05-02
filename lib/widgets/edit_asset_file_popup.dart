import 'package:ava/controllers/auth_controller.dart';
import 'package:ava/widgets/popup_button.dart';
import 'package:get/get.dart';
import 'package:ava/widgets/popup_textfield.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/style.dart';
import 'package:flutter/material.dart';

import '../controllers/project_controller.dart';
import 'asset_catagory_widgets.dart';

Future<dynamic> editAssetFilePopUp(
  BuildContext context, {
  String? path,
  String? pathName,
  String? assetID,
  String? category,
}) {
  final pathNameController = TextEditingController();
  final categoryTitleController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final ProjectController projectController = Get.find();
  final AuthController authController = Get.find();
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
                  child: Column(
                    children: [
                      popUpCloseButton,
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(children: <Widget>[
                            txt(
                              txt: 'EDIT ASSET',
                              font: 'comfortaa',
                              fontSize: 40,
                              letterSpacing: 6,
                              fontWeight: FontWeight.w700,
                            ),
                            const Spacer(),
                            Column(
                              children: [
                                SizedBox(
                                  height: screenHeight(context) * 0.05,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: screenWidth(context) * 0.15,
                                      child: txt(
                                        txt: 'Filename:',
                                        fontSize: 30,
                                      ),
                                    ),
                                    SizedBox(
                                      width: screenWidth(context) * 0.02,
                                    ),
                                    popUpTextField(context,
                                        controller: pathNameController,
                                        hint: pathName ??
                                            'exp: Youtube news section'),
                                  ],
                                ),
                                SizedBox(
                                  height: screenHeight(context) * 0.04,
                                ),
                                categoryDropDown(context, authController,
                                    setState, projectController),
                                projectController.assetCategory.value ==
                                        newAssetCategory
                                    ? newCategoryTextField(
                                        context, categoryTitleController)
                                    : Container(),
                                SizedBox(
                                  height: screenHeight(context) * 0.04,
                                ),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: screenWidth(context) < 1000
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                              children: [
                                popupButton(
                                  context,
                                  text: 'Edit',
                                  ontap: () {
                                    if (pathNameController.text.isEmpty &&
                                        categoryTitleController.text.isEmpty &&
                                        projectController.assetCategory.value ==
                                            category) {
                                      getErrorSnackBar(
                                          "Please make some changes first");
                                    } else {
                                      Get.back();

                                      projectController.editAsset(
                                          assetID: assetID,
                                          type: fileAssetType,
                                          path: path,
                                          pathName: pathNameController
                                                  .text.isEmpty
                                              ? pathName
                                              : pathNameController.text.trim(),
                                          assetCategoryTitle: projectController
                                                      .assetCategory.value ==
                                                  newAssetCategory
                                              ? (categoryTitleController
                                                      .text.isEmpty
                                                  ? 'Category'
                                                  : categoryTitleController
                                                      .text)
                                              : projectController
                                                  .assetCategory.value);
                                    }
                                  },
                                ),
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
          ),
        );
      });
}
