import 'package:projectx/widgets/popup_textfield.dart';
import '../constants/style.dart';
import 'package:flutter/material.dart';

int _groupValue = -1;

Future<dynamic> addAssetPopUp(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: screenHeight(context) * 0.35,
            width: screenWidth(context) * 0.3,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(children: <Widget>[
                txt(
                  txt: 'ASSET',
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
                      height: screenHeight(context) * 0.2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          txt(
                            txt: 'Name:',
                            fontSize: 30,
                          ),
                          Container(),
                          txt(
                            txt: 'Location:',
                            fontSize: 30,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: screenWidth(context) * 0.01,
                    ),
                    SizedBox(
                      height: screenHeight(context) * 0.2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          popUpTextField(context),
                          Row(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 15,
                                    width: 30,
                                    child: _myRadioButton(
                                        title: "WEB",
                                        value: 0,
                                        onChanged: (newValue) {}),
                                  ),
                                  txt(txt: 'WEB', fontSize: 20)
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    height: 15,
                                    width: 30,
                                    child: _myRadioButton(
                                      title: "FOLDER",
                                      value: 1,
                                      onChanged: (newValue) {},
                                    ),
                                  ),
                                  txt(txt: 'FOLDER', fontSize: 20)
                                ],
                              ),
                            ],
                          ),
                          popUpTextField(context),
                        ],
                      ),
                    ),
                  ],
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
              ]),
            ),
          ),
        );
      });
}

Widget _myRadioButton(
    {String? title, int? value, required Function onChanged}) {
  return RadioListTile(
    value: value,
    groupValue: _groupValue,
    onChanged: null,
    title: Text(title!),
  );
}
