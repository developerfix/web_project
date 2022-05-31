import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projectx/constants/style.dart';

class SeeAllProjects extends StatefulWidget {
  const SeeAllProjects({Key? key}) : super(key: key);

  @override
  State<SeeAllProjects> createState() => _SeeAllProjectsState();
}

class _SeeAllProjectsState extends State<SeeAllProjects> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(secondaryColor),
      body: SizedBox(
        height: screenHeight(context),
        width: screenWidth(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: screenHeight(context) * 0.08,
                width: screenWidth(context),
                decoration: BoxDecoration(
                  color: const Color(mainColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.23),
                      offset: const Offset(0, 3.0),
                      blurRadius: 9.0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      txt(txt: 'PROJECTS', fontSize: 40, letterSpacing: 3),
                    ],
                  ),
                )),
            Expanded(
              child: GridView.builder(
                  padding: const EdgeInsets.all(20.0),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 2 / 2,
                      crossAxisSpacing: 30,
                      mainAxisSpacing: 30),
                  itemCount: 200,
                  itemBuilder: (BuildContext ctx, index) {
                    return recentProjectBox(text: 'Project x');
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Container recentProjectBox({String? text}) {
    return Container(
      width: screenWidth(context) * 0.1,
      height: screenHeight(context) * 0.18,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: const Color(secondaryColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.23),
            offset: const Offset(0, 3.0),
            blurRadius: 9.0,
          ),
        ],
      ),
      child: Center(child: txt(txt: text!, fontSize: 30.0, letterSpacing: 2)),
    );
  }
}
