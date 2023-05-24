import 'dart:io';

import 'package:ava/controllers/profile_controller.dart';
import 'package:ava/widgets/edit_name_popup.dart';
import 'package:ava/widgets/profile_avatar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/style.dart';
import '../controllers/auth_controller.dart';

class EndDrawerWidget extends StatefulWidget {
  const EndDrawerWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<EndDrawerWidget> createState() => _EndDrawerWidgetState();
}

class _EndDrawerWidgetState extends State<EndDrawerWidget> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final AuthController authController = Get.find<AuthController>();

  _saveThemeStatus() async {
    SharedPreferences pref = await _prefs;
    pref.setBool('theme', authController.isDarkTheme.value);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (controller) => Drawer(
              backgroundColor: const Color(secondaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 50,
                  ),
                  DrawerHeader(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        profileAvatar(context,
                            maxRadius: 50, fontSize: 30, isDrawer: true),
                        txt(
                          txt: controller.currentUser.value.name ?? "",
                          fontSize: 20.0,
                          fontColor: Colors.white,
                          letterSpacing: 2,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: ListView(
                    children: [
                      drawerRow(
                          title: "Edit name",
                          onTap: () {
                            editNamePopUp(
                              context,
                            ).then((value) {
                              setState(() {});
                            });
                          },
                          trailing:
                              const Icon(Icons.edit, color: Colors.white)),
                      drawerRow(
                          title: "Change profile picture",
                          onTap: () async {
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(
                                    withData: true, allowMultiple: false);
                            if (result != null) {
                              controller.profilePhotoUpdate(
                                  result: File(result.files.first.path!));
                              setState(() {});
                            }
                          },
                          trailing: const Icon(
                            Icons.person,
                            color: Colors.white,
                          )),
                      drawerRow(
                        title: 'Dark mode',
                        trailing: ObxValue(
                          (data) => MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: FlutterSwitch(
                              width: 80.0,
                              height: 30.0,
                              activeColor: const Color(mainColor),
                              value: authController.isDarkTheme.value,
                              borderRadius: 30.0,
                              padding: 8.0,
                              showOnOff: false,
                              onToggle: (val) {
                                authController.isDarkTheme.value = val;
                                authController.update();

                                Get.changeThemeMode(
                                  authController.isDarkTheme.value
                                      ? ThemeMode.dark
                                      : ThemeMode.light,
                                );
                                _saveThemeStatus();
                              },
                            ),
                          ),
                          false.obs,
                        ),
                      ),
                    ],
                  )),
                  SizedBox(
                    height: screenHeight(context) * 0.1,
                    child: InkWell(
                      onTap: () {
                        AuthController.instance.signOut();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.logout,
                            color: Colors.white,
                            size: 30,
                          ),
                          SizedBox(
                            width: screenWidth(context) * 0.02,
                          ),
                          txt(
                            txt: "LOGOUT",
                            fontSize: 30.0,
                            fontColor: Colors.white,
                            letterSpacing: 5,
                            fontWeight: FontWeight.w700,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }

  InkWell drawerRow({
    required String title,
    required Widget trailing,
    Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: txt(
                txt: title,
                fontSize: 20.0,
                fontColor: Colors.white,
                letterSpacing: 2,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                fontWeight: FontWeight.w700,
              ),
            ),
            // const SizedBox(
            //   width: 10,
            // ),
            trailing
          ],
        ),
      ),
    );
  }
}
