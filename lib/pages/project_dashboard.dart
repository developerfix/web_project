import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectx/constants/style.dart';
import 'package:projectx/pages/recent_project.dart';
import 'package:projectx/pages/timeline.dart';
import 'package:projectx/widgets/asset_popup.dart';

class ProjectDashboard extends StatefulWidget {
  const ProjectDashboard({Key? key}) : super(key: key);

  @override
  State<ProjectDashboard> createState() => _ProjectDashboardState();
}

class _ProjectDashboardState extends State<ProjectDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(0, 3.0),
                  blurRadius: 9.0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
              child: Column(
                children: [
                  const Icon(
                    Icons.cloud_circle,
                    size: 200,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          addAssetPopUp(context);
                        },
                        child: SizedBox(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.add,
                                color: Color(brownishColor),
                                size: 50,
                              ),
                              txt(
                                txt: "ASSETS",
                                fontSize: 50.0,
                                fontColor: const Color(brownishColor),
                                letterSpacing: 5,
                                fontWeight: FontWeight.w700,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight(context) * 0.05,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: screenHeight(context) * 0.7,
                        width: screenWidth(context) * 0.1,
                        child: ListView.builder(
                            itemCount: 6,
                            itemBuilder: (context, i) {
                              return txt(txt: 'LINK 1', fontSize: 30);
                            }),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(const RecentProjects());
                        },
                        child: const Icon(
                          Icons.home,
                          size: 50,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          Get.to(const Timeline());
                        },
                        child: const Icon(
                          Icons.timeline,
                          size: 50,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: SizedBox(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(50, 50, 50, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        txt(
                          txt: 'PROJECT TITLE',
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 7,
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                txt(
                                  txt: 'LEAD :',
                                  fontSize: 20,
                                ),
                                txt(
                                  txt: 'CO-PILOT :',
                                  fontSize: 20,
                                ),
                              ],
                            ),
                            SizedBox(
                              width: screenWidth(context) * 0.005,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                txt(
                                  txt: 'USER 1',
                                  fontSize: 20,
                                ),
                                txt(
                                  txt: 'USER 2',
                                  fontSize: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    txt(
                      txt: 'Subtitle of project',
                      fontSize: 30,
                    ),
                    SizedBox(
                      height: screenHeight(context) * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            txt(txt: 'TO DO', fontSize: 20),
                            SizedBox(
                              height: screenHeight(context) * 0.85,
                              width: screenWidth(context) * 0.15,
                              child: GridView.builder(
                                  padding: const EdgeInsets.all(20.0),
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 200,
                                          childAspectRatio: 2 / 2,
                                          crossAxisSpacing: 30,
                                          mainAxisSpacing: 30),
                                  itemCount: 200,
                                  itemBuilder: (BuildContext ctx, index) {
                                    return // Group: card
                                        taskBox();
                                  }),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            txt(txt: 'IN PROGRESS', fontSize: 20),
                            SizedBox(
                              height: screenHeight(context) * 0.85,
                              width: screenWidth(context) * 0.15,
                              child: GridView.builder(
                                  padding: const EdgeInsets.all(20.0),
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 200,
                                          childAspectRatio: 2 / 2,
                                          crossAxisSpacing: 30,
                                          mainAxisSpacing: 30),
                                  itemCount: 200,
                                  itemBuilder: (BuildContext ctx, index) {
                                    return // Group: card
                                        taskBox();
                                  }),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            txt(txt: 'COMPLETED', fontSize: 20),
                            SizedBox(
                              height: screenHeight(context) * 0.85,
                              width: screenWidth(context) * 0.15,
                              child: GridView.builder(
                                  padding: const EdgeInsets.all(20.0),
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 200,
                                          childAspectRatio: 2 / 2,
                                          crossAxisSpacing: 30,
                                          mainAxisSpacing: 30),
                                  itemCount: 200,
                                  itemBuilder: (BuildContext ctx, index) {
                                    return // Group: card
                                        taskBox();
                                  }),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(0, 3.0),
                  blurRadius: 9.0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(50, 50, 30, 80),
              child: Column(
                children: [
                  txt(
                    txt: 'NOTES',
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 5,
                  ),
                  SizedBox(
                    height: screenHeight(context) * 0.05,
                  ),
                  Column(
                    children: [
                      usersMsg(context),
                      usersMsg(context),
                      usersMsg(context),
                      usersMsg(context),
                      usersMsg(context),
                      usersMsg(context),
                      usersMsg(context),
                      usersMsg(context),
                      usersMsg(context),
                      usersMsg(context),
                      usersMsg(context),
                      usersMsg(context),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: screenWidth(context) * 0.2,
                    height: screenHeight(context) * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.16),
                          offset: const Offset(0, 3.0),
                          blurRadius: 6.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 5),
                      child: TextFormField(
                        maxLines: null,
                        decoration: const InputDecoration(
                            suffixIcon:
                                Icon(Icons.send, color: Color(brownishColor)),
                            border: InputBorder.none,
                            hintText: 'Add Comment...',
                            hintStyle: TextStyle(
                                color: Color(brownishColor),
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }

  Padding usersMsg(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(brownishColor),
            maxRadius: 25,
            child: Center(
              child: txt(txt: 'R', fontSize: 20, fontColor: Colors.white),
            ),
          ),
          SizedBox(
            width: screenWidth(context) * 0.005,
          ),
          txt(txt: 'we can add some detailing', fontSize: 20)
        ],
      ),
    );
  }

  Container taskBox() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.23),
            offset: const Offset(0, 3.0),
            blurRadius: 9.0,
          ),
        ],
      ),
    );
  }
}
