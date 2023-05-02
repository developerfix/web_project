import 'package:ava/widgets/auth_popup_textfield.dart';
import 'package:ava/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ava/constants/style.dart';
import 'package:ava/controllers/auth_controller.dart';
import 'package:get/get.dart';

import '../../controllers/input_validators.dart';
import '../../controllers/project_controller.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool isSignup = false;
  bool isResetScreen = false;
  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: authscreenCustomAppBar(context),
      body: Row(
        children: [
          isLogin
              ? loginBox(context, emailController, passwordController)
              : isSignup
                  ? signupBox(context)
                  : resetBox(context),
          screenWidth(context) < 1500
              ? Container()
              : Expanded(
                  child: Container(
                  color: const Color(mainColor),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: InkWell(
                              onTap: () {},
                              child: SvgPicture.asset(
                                  'assets/svgs/ava_logo.svg'))),
                      SizedBox(height: screenHeight(context) * 0.02),
                      txt(
                          txt: 'We manage your project from start to finish',
                          fontSize: 22,
                          fontColor: Colors.white)
                    ],
                  ),
                ))
        ],
      ),
    );
  }

  Expanded signupBox(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final cnfPassController = TextEditingController();
    final AuthController authController = Get.find();

    return Expanded(
        child: Stack(
      children: [
        Positioned.fill(
          child: Center(
            child: SizedBox(
              height: screenHeight(context) * 0.8,
              width: 450,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  txt(
                      txt: 'Welcome to Ava',
                      fontSize: 30,
                      font: 'comfortaa',
                      fontColor: const Color(secondaryColor)),
                  SizedBox(
                    height: screenHeight(context) * 0.05,
                  ),
                  txt(
                      txt: 'Sign up to continue',
                      fontSize: 14,
                      fontColor: const Color(secondaryColor)),
                  SizedBox(
                    height: screenHeight(context) * 0.02,
                  ),
                  authPopUpTextField(context,
                      controller: nameController, hint: 'Name'),
                  SizedBox(
                    height: screenHeight(context) * 0.01,
                  ),
                  authPopUpTextField(context,
                      controller: emailController, hint: 'Email'),
                  SizedBox(
                    height: screenHeight(context) * 0.01,
                  ),
                  authPopUpTextField(context,
                      controller: passwordController, hint: 'Password'),
                  SizedBox(
                    height: screenHeight(context) * 0.01,
                  ),
                  authPopUpTextField(context,
                      controller: cnfPassController, hint: 'Confirm password'),
                  SizedBox(
                    height: screenHeight(context) * 0.05,
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          if (InputValidator.validateField(
                                  "Name", nameController.text.trim()) &&
                              InputValidator.validateField(
                                  "Email", emailController.text.trim())) {
                            if (InputValidator.validatePassword(
                                passwordController.text,
                                cnfPassController.text)) {
                              AuthController.instance.registerUser(
                                  email: emailController.text.trim(),
                                  name: nameController.text,
                                  password: passwordController.text.trim());
                            }
                          }
                        },
                        child: Container(
                          width: 150,
                          height: 70,
                          color: const Color(secondaryColor),
                          child: Center(
                            child: txt(
                                txt: 'Signup',
                                fontSize: 14,
                                fontColor: Colors.white),
                          ),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isLogin = true;
                            isSignup = false;
                            isResetScreen = false;
                          });
                        },
                        child: Container(
                          width: 150,
                          height: 70,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.0,
                              color: const Color(secondaryColor),
                            ),
                          ),
                          child: Center(
                            child: txt(
                                txt: 'Login',
                                fontSize: 14,
                                fontColor: const Color(secondaryColor)),
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
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }

  Expanded resetBox(BuildContext context) {
    return Expanded(
        child: Stack(
      children: [
        Positioned.fill(
          child: Center(
            child: SizedBox(
              height: screenHeight(context) * 0.8,
              width: 450,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  txt(
                      txt: 'Reset your password',
                      fontSize: 30,
                      fontColor: const Color(secondaryColor)),
                  SizedBox(
                    height: screenHeight(context) * 0.05,
                  ),
                  txt(
                      txt: 'Enter your email',
                      fontSize: 14,
                      fontColor: const Color(secondaryColor)),
                  SizedBox(
                    height: screenHeight(context) * 0.02,
                  ),
                  authPopUpTextField(
                    context,
                    hint: 'Email',
                  ),
                  SizedBox(
                    height: screenHeight(context) * 0.05,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 150,
                        height: 70,
                        color: const Color(secondaryColor),
                        child: Center(
                          child: txt(
                              txt: 'Proceed',
                              fontSize: 14,
                              fontColor: Colors.white),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isLogin = true;
                            isSignup = false;
                            isResetScreen = false;
                          });
                        },
                        child: Container(
                          width: 150,
                          height: 70,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.0,
                              color: const Color(secondaryColor),
                            ),
                          ),
                          child: Center(
                            child: txt(
                              txt: 'Back',
                              fontSize: 14,
                              fontColor: const Color(secondaryColor),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(
                        flex: 2,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }

  GetBuilder loginBox(
      BuildContext context,
      TextEditingController emailController,
      TextEditingController passwordController) {
    return GetBuilder<AuthController>(
        init: AuthController(),
        builder: (controller) {
          return Expanded(
              child: Stack(
            children: [
              Align(
                alignment: const Alignment(0, -0.7),
                child: Opacity(
                  opacity: 0.1,
                  child: SvgPicture.asset(
                    'assets/svgs/A.svg',
                  ),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: SizedBox(
                    height: screenHeight(context) * 0.8,
                    width: 450,
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
                        authPopUpTextField(context,
                            controller: emailController, hint: 'Email'),
                        SizedBox(
                          height: screenHeight(context) * 0.01,
                        ),
                        authPopUpTextField(context,
                            isObscure: controller.isObscure.value,
                            trailing: InkWell(
                              onTap: (() {
                                if (controller.isObscure.value == 1) {
                                  controller.isObscure.value = 2;
                                } else {
                                  controller.isObscure.value = 1;
                                }
                                controller.update();
                              }),
                              child: controller.isObscure.value == 1
                                  ? const Icon(
                                      Icons.visibility_off,
                                    )
                                  : const Icon(Icons.visibility),
                            ),
                            controller: passwordController,
                            hint: 'Password'),
                        SizedBox(
                          height: screenHeight(context) * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isLogin = false;
                                  isSignup = false;
                                  isResetScreen = true;
                                });
                              },
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
                                controller.login(emailController.text.trim(),
                                    passwordController.text.trim());
                              },
                              child: Container(
                                width: 150,
                                height: 70,
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
                                setState(() {
                                  isLogin = false;
                                  isSignup = true;
                                  isResetScreen = false;
                                });
                              },
                              child: Container(
                                width: 150,
                                height: 70,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1.0,
                                    color: const Color(secondaryColor),
                                  ),
                                ),
                                child: Center(
                                  child: txt(
                                    txt: 'Signup',
                                    fontColor: const Color(secondaryColor),
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
                            const SizedBox(
                              width: 16,
                            ),
                            const Expanded(child: Divider())
                          ],
                        ),
                        SizedBox(
                          height: screenHeight(context) * 0.03,
                        ),
                        InkWell(
                          onTap: () {
                            controller.googleLogin(context);
                          },
                          child: Container(
                            width: 450,
                            height: 70,
                            decoration: controller.isDarkTheme.value
                                ? darkThemeBoxDecoration
                                : lightThemeBoxDecoration,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                      'assets/svgs/google-icon.svg'),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  txt(
                                    txt: 'Sign in with Google',
                                    fontSize: 22,
                                    fontColor: const Color(secondaryColor),
                                  )
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ));
        });
  }
}
