import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:projectx/constants/style.dart';
import 'package:projectx/controllers/auth_controller.dart';
import 'package:projectx/controllers/project_controller.dart';
import 'package:projectx/pages/profile.dart';
import 'package:projectx/pages/recent_project.dart';
import 'package:projectx/pages/timeline.dart';
import 'package:projectx/widgets/asset_popup.dart';

class ProjectDashboard extends StatefulWidget {
  final String projectId;
  const ProjectDashboard({Key? key, required this.projectId}) : super(key: key);

  @override
  State<ProjectDashboard> createState() => _ProjectDashboardState();
}

class _ProjectDashboardState extends State<ProjectDashboard> {
  final ProjectController projectController = Get.put(ProjectController());
  final _uid = AuthController.instance.user!.uid;

  @override
  void initState() {
    super.initState();
    projectController.updateProjectAndUserId(
        projectId: widget.projectId, uid: _uid);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectController>(
        init: ProjectController(),
        builder: (controller) {
          if (controller.project.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Scaffold(

                // drawer: Drawer(

                //   child: ListView(
                //     padding: EdgeInsets.zero,
                //     children: <Widget>[
                //       DrawerHeader(
                //         margin: EdgeInsets.zero,
                //         child: Center(
                //           child: Row(
                //             children: [
                //               const Icon(
                //                 Icons.add,
                //                 color: Color(brownishColor),
                //                 size: 30,
                //               ),
                //               txt(
                //                 txt: "ASSETS",
                //                 fontSize: 30.0,
                //                 fontColor: const Color(brownishColor),
                //                 letterSpacing: 5,
                //                 fontWeight: FontWeight.w700,
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //       ListTile(
                //         leading: Icon(Icons.location_city),
                //         title: Text('Partner'),
                //         onTap: () {},
                //       ),
                //       ListTile(
                //         leading: Icon(Icons.multiline_chart),
                //         title: Text('Proyek'),
                //         onTap: () {},
                //       ),
                //     ],
                //   ),
                // ),
                appBar: AppBar(
                  backgroundColor: Color(mainColor),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: SvgPicture.asset(
                      'assets/svgs/ava_logo.svg',
                      height: 50,
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: 30,
                          ),
                          SizedBox(
                            width: screenWidth(context) * 0.01,
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(const Profile());
                            },
                            child: const CircleAvatar(
                              backgroundColor: Colors.lightGreen,
                              maxRadius: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                body: Row(
                  children: [
                    Drawer(
                      child: Column(
                        children: <Widget>[
                          DrawerHeader(
                            margin: EdgeInsets.zero,
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  addAssetPopUp(context);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.add,
                                      color: Color(brownishColor),
                                      size: 30,
                                    ),
                                    txt(
                                      txt: "ASSETS",
                                      fontSize: 30.0,
                                      fontColor: const Color(brownishColor),
                                      letterSpacing: 5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.folder),
                            title: Text(
                              'https://www.google.com/search?q=+flutter+webapp+drawer&tbm=isch&ved=2ahUKEwj87cv5maH4AhUJdBoKHZYWDEsQ2-cCegQIABAA&oq=+flutter+webapp+drawer&gs_lcp=CgNpbWcQAzoECAAQGFDs9QZYt4YHYMOHB2gBcAB4AIABjgOIAbQOkgEFMi03LjGYAQCgAQGqAQtnd3Mtd2l6LWltZ8ABAQ&sclient=img&ei=NVeiYrz_GYnoaZatsNgE&bih=660&biw=1280',
                              style: TextStyle(overflow: TextOverflow.ellipsis),
                            ),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: Icon(Icons.link),
                            title: Text(
                              'https://www.google.com/search?q=+flutter+webapp+drawer&tbm=isch&ved=2ahUKEwj87cv5maH4AhUJdBoKHZYWDEsQ2-cCegQIABAA&oq=+flutter+webapp+drawer&gs_lcp=CgNpbWcQAzoECAAQGFDs9QZYt4YHYMOHB2gBcAB4AIABjgOIAbQOkgEFMi03LjGYAQCgAQGqAQtnd3Mtd2l6LWltZ8ABAQ&sclient=img&ei=NVeiYrz_GYnoaZatsNgE&bih=660&biw=1280',
                              style: TextStyle(overflow: TextOverflow.ellipsis),
                            ),
                            onTap: () {},
                          ),
                          Spacer(),
                          ListTile(
                            leading: InkWell(
                              onTap: () {
                                Get.to(const RecentProjects());
                              },
                              child: const Icon(
                                Icons.home,
                                size: 50,
                              ),
                            ),
                            trailing: InkWell(
                              onTap: () {
                                Get.to(const Timeline());
                              },
                              child: const Icon(
                                Icons.timeline,
                                size: 50,
                              ),
                            ),
                            onTap: null,
                          ),
                          SizedBox(height: screenHeight(context) * 0.03)
                        ],
                      ),
                    ),
                    // Expanded(
                    //   child: Container(
                    //     decoration: const BoxDecoration(
                    //       color: Colors.white,
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: Colors.white,
                    //           offset: Offset(0, 3.0),
                    //           blurRadius: 9.0,
                    //         ),
                    //       ],
                    //     ),
                    //     child: Padding(
                    //       padding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
                    //       child: Column(
                    //         children: [
                    //           Row(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               InkWell(
                    //                 onTap: () {
                    //                   addAssetPopUp(context);
                    //                 },
                    //                 child: SizedBox(
                    //                   child: Row(
                    //                     children: [
                    //                       const Icon(
                    //                         Icons.add,
                    //                         color: Color(brownishColor),
                    //                         size: 30,
                    //                       ),
                    //                       txt(
                    //                         txt: "ASSETS",
                    //                         fontSize: 30.0,
                    //                         fontColor:
                    //                             const Color(brownishColor),
                    //                         letterSpacing: 5,
                    //                         fontWeight: FontWeight.w700,
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //           SizedBox(
                    //             height: screenHeight(context) * 0.03,
                    //           ),
                    //           Row(
                    //             children: [
                    //               SizedBox(
                    //                 height: screenHeight(context) * 0.7,
                    //                 width: screenWidth(context) * 0.082,
                    //                 child: ListView.builder(
                    //                     itemCount: 6,
                    //                     itemBuilder: (context, i) {
                    //                       return txt(
                    //                           txt: 'LINK 1', fontSize: 30);
                    //                     }),
                    //               )
                    //             ],
                    //           ),
                    //           Spacer(),
                    //           Row(
                    //             children: [
                    //               InkWell(
                    //                 onTap: () {
                    //                   Get.to(const RecentProjects());
                    //                 },
                    //                 child: const Icon(
                    //                   Icons.home,
                    //                   size: 50,
                    //                 ),
                    //               ),
                    //               const Spacer(),
                    //               InkWell(
                    //                 onTap: () {
                    //                   Get.to(const Timeline());
                    //                 },
                    //                 child: const Icon(
                    //                   Icons.timeline,
                    //                   size: 50,
                    //                 ),
                    //               )
                    //             ],
                    //           ),
                    //           SizedBox(height: screenHeight(context) * 0.03)
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      flex: 5,
                      child: SizedBox(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(50, 30, 50, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    txt(
                                      txt: projectController.project['title'],
                                      fontSize: 60,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 7,
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            txt(
                                              txt: projectController
                                                  .project['lead'],
                                              fontSize: 20,
                                            ),
                                            txt(
                                              txt: projectController
                                                  .project['copilot'],
                                              fontSize: 20,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                txt(
                                  txt: projectController.project['subtitle'],
                                  fontSize: 30,
                                ),
                                SizedBox(
                                  height: screenHeight(context) * 0.05,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        txt(txt: 'TO DO', fontSize: 20),
                                        SizedBox(
                                          height: screenHeight(context) * 0.85,
                                          width: screenWidth(context) * 0.15,
                                          child: GridView.builder(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              gridDelegate:
                                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                                      maxCrossAxisExtent: 200,
                                                      childAspectRatio: 2 / 2,
                                                      crossAxisSpacing: 30,
                                                      mainAxisSpacing: 30),
                                              itemCount: 200,
                                              itemBuilder:
                                                  (BuildContext ctx, index) {
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
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              gridDelegate:
                                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                                      maxCrossAxisExtent: 200,
                                                      childAspectRatio: 2 / 2,
                                                      crossAxisSpacing: 30,
                                                      mainAxisSpacing: 30),
                                              itemCount: 200,
                                              itemBuilder:
                                                  (BuildContext ctx, index) {
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
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              gridDelegate:
                                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                                      maxCrossAxisExtent: 200,
                                                      childAspectRatio: 2 / 2,
                                                      crossAxisSpacing: 30,
                                                      mainAxisSpacing: 30),
                                              itemCount: 200,
                                              itemBuilder:
                                                  (BuildContext ctx, index) {
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
                          padding: const EdgeInsets.fromLTRB(50, 30, 30, 80),
                          child: Column(
                            children: [
                              txt(
                                txt: 'NOTES',
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 5,
                              ),
                              SizedBox(
                                height: screenHeight(context) * 0.03,
                              ),
                              SizedBox(
                                height: screenHeight(context) * 0.55,
                                child: ListView(
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
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 5),
                                  child: TextFormField(
                                    maxLines: null,
                                    decoration: const InputDecoration(
                                        suffixIcon: Icon(Icons.send,
                                            color: Color(brownishColor)),
                                        border: InputBorder.none,
                                        hintText: 'Add Comment...',
                                        hintStyle: TextStyle(
                                            color: Color(brownishColor),
                                            fontWeight: FontWeight.w600)),
                                  ),
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
        });
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
