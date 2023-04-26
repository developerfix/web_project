import 'package:ava/widgets/popup_button.dart';
import 'package:get/get.dart';
import '../constants/style.dart';
import 'package:flutter/material.dart';

import '../controllers/project_controller.dart';
import 'list_of_tasks.dart';

Future<dynamic> addFileAssetPopUp(BuildContext context) {
  final pathController = TextEditingController();
  final pathNameController = TextEditingController();

  final projectController = Get.put(ProjectController());

  final formKey = GlobalKey<FormState>();

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: formKey,
          child: AlertDialog(
            content: SizedBox(
              height: screenHeight(context) * 0.4,
              width: screenWidth(context) * 0.5,
              child: Column(
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
                        Row(
                          children: [
                            SizedBox(
                              width: screenWidth(context) * 0.15,
                              child: txt(
                                txt: 'Selected Files:',
                                fontSize: 30,
                              ),
                            ),
                            Expanded(
                                child: deliverablesGrid(
                                    projectController.assetFiles)),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: screenWidth(context) < 1000
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.end,
                          children: [
                            popupButton(context, ontap: () {
                              if (formKey.currentState!.validate()) {
                                bool validURL =
                                    Uri.parse(pathController.text).isAbsolute;
                                if (pathController.text.contains('https://')) {
                                  if (validURL) {
                                    Get.back();
                                    projectController.addNewAsset(
                                      path: pathController.text.trim(),
                                      type: fileAssetType,
                                      pathName: pathNameController.text.trim(),
                                    );
                                  } else {
                                    getErrorSnackBar(
                                        'Please enter a valid url path');
                                  }
                                } else {
                                  pathController.text =
                                      'https://${pathController.text}';

                                  bool validURL =
                                      Uri.parse(pathController.text).isAbsolute;

                                  if (validURL) {
                                    Get.back();
                                    projectController.addNewAsset(
                                      path: pathController.text.trim(),
                                      type: fileAssetType,
                                      pathName: pathNameController.text.trim(),
                                    );
                                  } else {
                                    getErrorSnackBar(
                                        'Please enter a valid url path');
                                  }
                                }
                              }
                            }, text: 'Upload'),
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
        );
      });
}
