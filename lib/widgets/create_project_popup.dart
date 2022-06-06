import 'package:flutter/material.dart';
import 'package:projectx/widgets/popup_textfield.dart';

import '../constants/style.dart';

Future<dynamic> createProjectPopUp(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: screenHeight(context) * 0.55,
            width: screenWidth(context) * 0.3,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  txt(
                    txt: 'Project Details',
                    fontSize: 50,
                    letterSpacing: 6,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(
                    height: screenHeight(context) * 0.025,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: screenWidth(context) * 0.07,
                        height: screenHeight(context) * 0.35,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            txt(
                              txt: 'Title:',
                              fontSize: 30,
                            ),
                            txt(
                              txt: 'Subtitle:',
                              fontSize: 30,
                            ),
                            txt(
                              txt: 'LEAD:',
                              fontSize: 30,
                            ),
                            txt(
                              txt: 'CO-PILOT:',
                              fontSize: 30,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: screenWidth(context) * 0.2,
                        height: screenHeight(context) * 0.35,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            popUpTextField(context),
                            popUpTextField(context),
                            popUpTextField(context),
                            popUpTextField(context),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: screenHeight(context) * 0.025,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: screenWidth(context) * 0.04,
                        height: screenHeight(context) * 0.05,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: const Color(0xFF958890),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.23),
                              offset: const Offset(0, 3.0),
                              blurRadius: 9.0,
                            ),
                          ],
                        ),
                        child: Center(
                            child: txt(
                                txt: 'Cancel',
                                fontSize: 15,
                                fontColor: Colors.white)),
                      ),
                      SizedBox(
                        width: screenWidth(context) * 0.01,
                      ),
                      Container(
                        width: screenWidth(context) * 0.04,
                        height: screenHeight(context) * 0.05,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: const Color(0xFF958890),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.23),
                              offset: const Offset(0, 3.0),
                              blurRadius: 9.0,
                            ),
                          ],
                        ),
                        child: Center(
                            child: txt(
                                txt: 'Done',
                                fontSize: 15,
                                fontColor: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
