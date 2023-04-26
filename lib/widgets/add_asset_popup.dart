import 'package:ava/widgets/add_link_asset_popup.dart';
import 'package:get/get.dart';
import '../constants/style.dart';
import 'package:flutter/material.dart';

import 'add_file_asset_popup.dart';

Future<dynamic> addAssetPopUp(BuildContext context) {
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
                          txt: 'ADD ASSET',
                          font: 'comfortaa',
                          fontSize: screenWidth(context) < 800 ? 20 : 40,
                          letterSpacing: 6,
                          fontWeight: FontWeight.w700,
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Get.back();
                            addLinkAssetPopUp(context);
                          },
                          child: txt(
                            txt: 'Create new Hyperlink',
                            fontSize: 30,
                          ),
                        ),
                        const Spacer(),
                        txt(
                          txt: 'OR',
                          fontSize: 30,
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Get.back();
                            addFileAssetPopUp(context);
                          },
                          child: txt(
                            txt: 'Upload file from Device',
                            fontSize: 30,
                          ),
                        ),
                        const Spacer(),
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
