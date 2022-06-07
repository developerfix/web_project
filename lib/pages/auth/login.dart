import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get.dart' as getx;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:projectx/constants/style.dart';
import 'package:projectx/controllers/auth_controller.dart';
import 'package:projectx/pages/auth/reset.dart';
import 'package:projectx/pages/auth/signup.dart';
import 'package:projectx/widgets/popup_textfield.dart';

import '../recent_project.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Row(
        children: [
          Expanded(
              child: Stack(
            children: [
              Positioned.fill(
                child: Center(
                  child: SizedBox(
                    height: screenHeight(context) * 0.8,
                    width: screenWidth(context) * 0.2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        txt(
                            txt: 'Welcome to Ava',
                            fontSize: 30,
                            fontColor: const Color(secondaryColor)),
                        SizedBox(
                          height: screenHeight(context) * 0.05,
                        ),
                        txt(
                            txt: 'Sign in to continue',
                            fontSize: 14,
                            fontColor: const Color(secondaryColor)),
                        SizedBox(
                          height: screenHeight(context) * 0.02,
                        ),
                        popUpTextField(context,
                            controller: emailController, hint: 'Email'),
                        SizedBox(
                          height: screenHeight(context) * 0.01,
                        ),
                        popUpTextField(context,
                            controller: passwordController, hint: 'Password'),
                        SizedBox(
                          height: screenHeight(context) * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            navigator(
                              page: const Resetpassword(),
                              child: txt(
                                  txt: 'Forgot password?',
                                  fontSize: 14,
                                  fontColor: const Color(secondaryColor)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight(context) * 0.05,
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                AuthController.instance.login(
                                    emailController.text.trim(),
                                    passwordController.text.trim());
                              },
                              child: Container(
                                width: screenWidth(context) * 0.07,
                                height: screenHeight(context) * 0.05,
                                color: const Color(secondaryColor),
                                child: Center(
                                  child: txt(
                                      txt: 'Login Now',
                                      fontSize: 14,
                                      fontColor: Colors.white),
                                ),
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                Get.to(const Signup());
                              },
                              child: Container(
                                width: screenWidth(context) * 0.07,
                                height: screenHeight(context) * 0.05,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1.0,
                                    color: const Color(secondaryColor),
                                  ),
                                ),
                                child: Center(
                                  child: txt(
                                    txt: 'Signup',
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(
                              flex: 2,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight(context) * 0.03,
                        ),
                        Row(
                          children: [
                            txt(txt: 'OR', fontSize: 12),
                            SizedBox(
                              width: screenWidth(context) * 0.005,
                            ),
                            const Expanded(child: const Divider())
                          ],
                        ),
                        SizedBox(
                          height: screenHeight(context) * 0.03,
                        ),
                        InkWell(
                          onTap: () {
                            AuthController.instance.googleLogin();
                          },
                          child: Container(
                            width: screenWidth(context) * 0.13,
                            height: screenHeight(context) * 0.06,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.24),
                                  offset: const Offset(0, 1.0),
                                  blurRadius: 2.0,
                                ),
                              ],
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                      'assets/svgs/google-icon.svg'),
                                  SizedBox(
                                    width: screenWidth(context) * 0.01,
                                  ),
                                  txt(txt: 'Sign in with Google', fontSize: 22)
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Positioned.fill(
              //     child: RotatedBox(
              //   quarterTurns: 2,
              //   child:
              //       Opacity(opacity: 0.1, child: txt(txt: "A", fontSize: 1500)),
              // ))
            ],
          )),
          Expanded(
              child: Container(
            color: const Color(mainColor),
          ))
        ],
      ),
    );
  }
}
