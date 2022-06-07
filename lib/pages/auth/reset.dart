import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projectx/constants/style.dart';
import 'package:projectx/pages/auth/login.dart';
import 'package:projectx/widgets/popup_textfield.dart';

class Resetpassword extends StatefulWidget {
  const Resetpassword({Key? key}) : super(key: key);

  @override
  State<Resetpassword> createState() => _ResetpasswordState();
}

class _ResetpasswordState extends State<Resetpassword> {
  @override
  Widget build(BuildContext context) {
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
                              width: screenWidth(context) * 0.07,
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
                            navigator(
                              page: const Login(),
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
