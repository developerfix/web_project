import 'package:flutter/material.dart';

import 'package:projectx/constants/style.dart';

class Timeline extends StatefulWidget {
  const Timeline({Key? key}) : super(key: key);

  @override
  State<Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: screenHeight(context),
        width: screenWidth(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: screenHeight(context) * 0.03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                txt(
                    txt: 'TIMELINE VIEW',
                    fontSize: 60,
                    letterSpacing: 7,
                    fontWeight: FontWeight.bold),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



// double screenHeight(BuildContext context) {
//   return MediaQuery.of(context).size.height;
// }