import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projectx/constants/style.dart';
import 'package:projectx/controllers/auth_controller.dart';
import 'package:projectx/widgets/popup_textfield.dart';

import '../../controllers/input_validators.dart';

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

    return Expanded(
        child: Stack(
      children: [
        Positioned.fill(
          child: Center(
            child: SizedBox(
              height: screenHeight(context) * 0.8,
              width: screenWidth(context) < 1200
                  ? screenWidth(context) * 0.5
                  : screenWidth(context) * 0.2,
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
                  popUpTextField(context,
                      controller: nameController, hint: 'Name'),
                  SizedBox(
                    height: screenHeight(context) * 0.01,
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
                  popUpTextField(context,
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
                          width: screenWidth(context) < 1200
                              ? screenWidth(context) * 0.2
                              : screenWidth(context) * 0.07,
                          height: screenHeight(context) * 0.05,
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
                          width: screenWidth(context) < 1200
                              ? screenWidth(context) * 0.2
                              : screenWidth(context) * 0.07,
                          height: screenHeight(context) * 0.05,
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
              width: screenWidth(context) < 1200
                  ? screenWidth(context) * 0.5
                  : screenWidth(context) * 0.2,
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
                  popUpTextField(context),
                  SizedBox(
                    height: screenHeight(context) * 0.05,
                  ),
                  Row(
                    children: [
                      Container(
                        width: screenWidth(context) < 1200
                            ? screenWidth(context) * 0.2
                            : screenWidth(context) * 0.07,
                        height: screenHeight(context) * 0.05,
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
                          width: screenWidth(context) < 1200
                              ? screenWidth(context) * 0.2
                              : screenWidth(context) * 0.07,
                          height: screenHeight(context) * 0.05,
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

  Expanded loginBox(BuildContext context, TextEditingController emailController,
      TextEditingController passwordController) {
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
              width: screenWidth(context) < 1200
                  ? screenWidth(context) * 0.5
                  : screenWidth(context) * 0.2,
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
                          AuthController.instance.login(
                              emailController.text.trim(),
                              passwordController.text.trim());
                        },
                        child: Container(
                          width: screenWidth(context) < 1200
                              ? screenWidth(context) * 0.2
                              : screenWidth(context) * 0.07,
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
                          setState(() {
                            isLogin = false;
                            isSignup = true;
                            isResetScreen = false;
                          });
                        },
                        child: Container(
                          width: screenWidth(context) < 1200
                              ? screenWidth(context) * 0.2
                              : screenWidth(context) * 0.07,
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
                      const Expanded(child: Divider())
                    ],
                  ),
                  SizedBox(
                    height: screenHeight(context) * 0.03,
                  ),
                  InkWell(
                    onTap: () {
                      AuthController.instance.googleLogin(context);
                    },
                    child: Container(
                      width: screenWidth(context) < 1200
                          ? screenWidth(context) * 0.5
                          : screenWidth(context) * 0.25,
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
                            SvgPicture.asset('assets/svgs/google-icon.svg'),
                            const SizedBox(
                              width: 20,
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
      ],
    ));
  }
}
