import 'package:ava/widgets/add_link_asset_popup.dart';
import 'package:get/get.dart';
import '../constants/style.dart';
import 'package:flutter/material.dart';

import 'add_file_asset_popup.dart';
import 'add_new_task_popup.dart';

Future<dynamic> addAssetPopUp(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 600,
            width: 1000,
            child: Column(
              children: [
                popupHeader('ADD ASSET'),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(children: <Widget>[
                      InkWell(
                        onTap: () {
                          Get.back();
                          addLinkAssetPopUp(context);
                        },
                        child: SizedBox(
                          height: 100,
                          width: 500,
                          child: Center(
                            child: txt(
                              txt: 'Create new Hyperlink',
                              fontSize: 30,
                            ),
                          ),
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
                        child: SizedBox(
                          height: 100,
                          width: 500,
                          child: Center(
                            child: txt(
                              txt: 'Upload file from Device',
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
