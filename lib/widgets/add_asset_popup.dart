import 'package:ava/widgets/add_link_asset_popup.dart';
import 'package:get/get.dart';
import '../constants/style.dart';
import 'package:flutter/material.dart';

import 'add_file_asset_popup.dart';

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
                popUpCloseButton,
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(children: <Widget>[
                      txt(
                        txt: 'ADD ASSET',
                        font: 'comfortaa',
                        fontSize: 40,
                        letterSpacing: 6,
                        fontWeight: FontWeight.w700,
                      ),
                      const Spacer(),
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
