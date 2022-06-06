import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projectx/constants/style.dart';
import 'package:projectx/pages/project_dashboard.dart';
import 'package:projectx/pages/see_all_projs.dart';

import '../widgets/create_project_popup.dart';

class RecentProjects extends StatefulWidget {
  const RecentProjects({Key? key}) : super(key: key);

  @override
  State<RecentProjects> createState() => _RecentProjectsState();
}

class _RecentProjectsState extends State<RecentProjects> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(mainColor),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          txt(
              txt: 'PROJECTS',
              fontSize: 100,
              letterSpacing: 8.0,
              fontColor: Colors.white),
          SizedBox(
            height: screenHeight(context) * 0.03,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              recentProjectBox(text: 'Project 1'),
              SizedBox(
                width: screenWidth(context) * 0.01,
              ),
              recentProjectBox(text: 'Project 2'),
              SizedBox(
                width: screenWidth(context) * 0.01,
              ),
              recentProjectBox(text: 'Project 3'),
              SizedBox(
                width: screenWidth(context) * 0.01,
              ),
              recentProjectBox(text: 'Project 4'),
              SizedBox(
                width: screenWidth(context) * 0.01,
              ),
              recentProjectBox(text: 'Project 5'),
              SizedBox(
                width: screenWidth(context) * 0.01,
              ),
              navigator(
                page: const SeeAllProjects(),
                child: Container(
                  width: screenWidth(context) * 0.1,
                  height: screenHeight(context) * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: const Color(secondaryColor).withOpacity(0.5),
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
                          txt: 'See all',
                          fontSize: 30.0,
                          letterSpacing: 2,
                          fontColor: Colors.white)),
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  createProjectPopUp(context);
                },
                child: Row(
                  children: [
                    txt(
                        txt: 'Create New Project',
                        fontSize: 30.0,
                        fontColor: Colors.white,
                        letterSpacing: 2),
                    SizedBox(
                      width: screenWidth(context) * 0.003,
                    ),
                    SvgPicture.asset(
                      'assets/svgs/plus.svg',
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: screenHeight(context) * 0.05,
          ),
        ],
      ),
    );
  }

  SizedBox recentProjectBox({String? text}) {
    return SizedBox(
      child: navigator(
        page: const ProjectDashboard(),
        child: Container(
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
          child: Center(
              child: txt(
                  txt: text!,
                  fontSize: 30.0,
                  letterSpacing: 2,
                  fontColor: Colors.white)),
        ),
      ),
    );
  }
}
