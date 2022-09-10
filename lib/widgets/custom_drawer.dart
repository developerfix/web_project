import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:projectx/main.dart';
import 'package:projectx/widgets/edit_task_popup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/style.dart';
import '../controllers/auth_controller.dart';
import '../controllers/project_controller.dart';

class EndDrawerWidget extends StatefulWidget {
  const EndDrawerWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<EndDrawerWidget> createState() => _EndDrawerWidgetState();
}

class _EndDrawerWidgetState extends State<EndDrawerWidget> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final ProjectController projectController = Get.find();

  _saveThemeStatus() async {
    SharedPreferences pref = await _prefs;
    pref.setBool('theme', projectController.isDarkTheme.value);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: const Color(secondaryColor),
        child: Column(
          children: <Widget>[
            DrawerHeader(
              margin: EdgeInsets.zero,
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
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                txt(
                  txt: "Dark mode",
                  fontSize: 20.0,
                  fontColor: Colors.white,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w700,
                ),
                const SizedBox(
                  width: 10,
                ),
                ObxValue(
                  (data) => FlutterSwitch(
                    width: 80.0,
                    height: 30.0,
                    activeColor: const Color(mainColor),
                    value: projectController.isDarkTheme.value,
                    borderRadius: 30.0,
                    padding: 8.0,
                    showOnOff: false,
                    onToggle: (val) {
                      projectController.isDarkTheme.value = val;

                      Get.changeThemeMode(
                        projectController.isDarkTheme.value
                            ? ThemeMode.dark
                            : ThemeMode.light,
                      );
                      projectController.update();
                      _saveThemeStatus();
                    },
                  ),
                  false.obs,
                ),
              ],
            ),
          ],
        ));
  }
}
