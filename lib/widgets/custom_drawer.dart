import 'package:flutter/material.dart';

import '../constants/style.dart';
import '../controllers/auth_controller.dart';

class EndDrawerWidget extends StatelessWidget {
  const EndDrawerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: const Color(secondaryColor),
        child: Column(
          children: <Widget>[
            DrawerHeader(
              margin: EdgeInsets.zero,
              child: Center(
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
            ),
          ],
        ));
  }
}
