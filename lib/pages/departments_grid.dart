import 'package:ava/pages/projects_grid.dart';
import 'package:ava/widgets/create_department_popup.dart';
import 'package:ava/widgets/plus_icon_widget.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ava/constants/style.dart';
import 'package:ava/widgets/loading_indicator.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/auth_controller.dart';
import '../controllers/department_controller.dart';
import '../controllers/profile_controller.dart';
import '../controllers/project_controller.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/left_side_icons.dart';
import '../widgets/project_box.dart';

class DepartmentsGrid extends StatefulWidget {
  const DepartmentsGrid({Key? key}) : super(key: key);
  @override
  State<DepartmentsGrid> createState() => _DepartmentsGridState();
}

class _DepartmentsGridState extends State<DepartmentsGrid> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final DepartmentController departmentController =
      Get.put(DepartmentController());
  final ProfileController profileController = Get.put(ProfileController());
  final ProjectController projectController = Get.put(ProjectController());

  final _uid = AuthController.instance.user!.uid;
  final ScrollController _scrollController = ScrollController();
  List tempList = [];
  List projectsCategoriesList = [];

  // bool isAtTop = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileController.updateUserData(_uid);
      profileController.getDepartments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Form(
          key: _formKey,
          child: Obx(() {
            return Scaffold(
              key: _key,
              drawerEnableOpenDragGesture: false,
              appBar: customAppBar(
                context,
                isNeedAppbar: false,
                pageName: 'HOME',
              ),
              endDrawer: const EndDrawerWidget(),
              backgroundColor: const Color(mainColor),
              body: Row(
                children: [
                  leftSideIcons(context, isProjectsScreen: true),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Column(
                          children: [
                            txt(
                                txt: 'HOME',
                                font: 'comfortaa',
                                fontSize: constraints.maxWidth < 800 ? 40 : 80,
                                letterSpacing: 8.0,
                                fontColor: Colors.white),
                            SizedBox(
                              height: screenHeight(context) * 0.03,
                            ),
                            profileController.departments.isEmpty
                                ? Container()
                                : searchDepartmentsWidget(context),
                            profileController.isFetchingDepartments.isTrue
                                ? SizedBox(
                                    height: screenHeight(context) * 0.5,
                                    width: screenWidth(context) * 0.7,
                                    child: const LoadingIndicator(
                                      color: Colors.white,
                                    ))
                                : profileController.departments.isEmpty
                                    ? SizedBox(
                                        height: screenHeight(context) * 0.5,
                                        width: screenWidth(context) * 0.7,
                                        child: Center(
                                          child: txt(
                                              txt:
                                                  'Click below to make your first department for the projects with ava',
                                              fontSize: 24,
                                              fontColor: Colors.white),
                                        ),
                                      )
                                    : departmentController
                                            .searchedDepartment.isEmpty
                                        ? departmentTilesWidget(context)
                                        : searchedDepartmentTilesWidget(context)
                          ],
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            plusIconWidget(
                              context,
                              color: Colors.white,
                              ontap: () {
                                createDepartmentPopUp(context, uid: _uid);
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight(context) * 0.05,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }));
    });
  }

  Padding departmentTilesWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          final metrices = notification.metrics;
          if (metrices.pixels != 0) {
            departmentController.isRecentDepartmentsListAtTop.value = false;
            departmentController.update();
          } else {
            departmentController.isRecentDepartmentsListAtTop.value = true;
            departmentController.update();
          }

          return false;
        },
        child: AnimatedSize(
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
          child: SizedBox(
            height: departmentController.isRecentDepartmentsListAtTop.value
                ? screenHeight(context) * 0.5
                : screenHeight(context) * 0.6,
            width: screenWidth(context) * 0.7,
            child: RawScrollbar(
              thumbColor: Colors.white,
              thumbVisibility: true,
              trackColor: const Color(secondaryColor),
              trackRadius: const Radius.circular(50),
              thickness: 15,
              trackVisibility: true,
              interactive: true,
              controller: _scrollController,
              shape: const CircleBorder(
                side: BorderSide(
                  style: BorderStyle.none,
                ),
              ),
              child: FadingEdgeScrollView.fromScrollView(
                child: GridView.builder(
                  controller: _scrollController,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                      crossAxisSpacing: 150,
                      mainAxisExtent: 150,
                      mainAxisSpacing: 0),
                  shrinkWrap: true,
                  itemCount: profileController.departments.length,
                  itemBuilder: (context, i) {
                    bool isHovering = false;
                    String departmentTitle =
                        profileController.departments[i].title!;

                    int departmentIconCode =
                        profileController.departments[i].iconCode!;

                    return MouseRegion(
                        onEnter: (event) {
                          setState(() {
                            isHovering = true;
                          });
                        },
                        onExit: (event) {
                          setState(() {
                            isHovering = false;
                          });
                        },
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => ProjectsGrid(
                                  departmentId: profileController
                                      .departments[i].departmentId!,
                                ));
                          },
                          child: isHovering
                              ? departmentBox(context,
                                  text: departmentTitle,
                                  iconCode: departmentIconCode)
                              : departmentBox(context,
                                  text: departmentTitle,
                                  iconCode: departmentIconCode),
                        ));
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding searchedDepartmentTilesWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          final metrices = notification.metrics;
          if (metrices.pixels != 0) {
            departmentController.isRecentDepartmentsListAtTop.value = false;
            departmentController.update();
          } else {
            departmentController.isRecentDepartmentsListAtTop.value = true;
            departmentController.update();
          }

          return false;
        },
        child: AnimatedSize(
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
          child: SizedBox(
            height: departmentController.isRecentDepartmentsListAtTop.value
                ? screenHeight(context) * 0.5
                : screenHeight(context) * 0.6,
            width: screenWidth(context) * 0.7,
            child: RawScrollbar(
              thumbColor: Colors.white,
              thumbVisibility: true,
              trackColor: const Color(secondaryColor),
              trackRadius: const Radius.circular(50),
              thickness: 15,
              trackVisibility: true,
              interactive: true,
              controller: _scrollController,
              shape: const CircleBorder(
                side: BorderSide(
                  style: BorderStyle.none,
                ),
              ),
              child: FadingEdgeScrollView.fromScrollView(
                child: GridView.builder(
                  controller: _scrollController,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                      crossAxisSpacing: 150,
                      mainAxisExtent: 150,
                      mainAxisSpacing: 0),
                  shrinkWrap: true,
                  itemCount: departmentController.searchedDepartments.length,
                  itemBuilder: (context, i) {
                    bool isHovering = false;
                    String departmentTitle =
                        departmentController.searchedDepartments[i].title!;

                    int departmentIconCode =
                        departmentController.searchedDepartments[i].iconCode!;

                    return MouseRegion(
                        onEnter: (event) {
                          setState(() {
                            isHovering = true;
                          });
                        },
                        onExit: (event) {
                          setState(() {
                            isHovering = false;
                          });
                        },
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => ProjectsGrid(
                                  departmentId: profileController
                                      .departments[i].departmentId!,
                                ));
                          },
                          child: isHovering
                              ? departmentBox(context,
                                  text: departmentTitle,
                                  iconCode: departmentIconCode)
                              : departmentBox(context,
                                  text: departmentTitle,
                                  iconCode: departmentIconCode),
                        ));
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row searchDepartmentsWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
            width: screenWidth(context) * 0.17,
            child: TextField(
              cursorColor: Colors.white,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  departmentController.isSearchingDepartment.value = true;
                  departmentController.searchedDepartment.value = value;
                  departmentController.getSearchedDepartments();
                } else {
                  departmentController.isSearchingDepartment.value = false;
                  departmentController.searchedDepartment.value = '';
                }
                departmentController.update();
              },
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  overflow: TextOverflow.visible,
                  letterSpacing: 2,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            )),
        SizedBox(
            height: screenHeight(context) * 0.015,
            child: SvgPicture.asset(
              'assets/svgs/search_icon.svg',
              color: Colors.white,
            )),
      ],
    );
  }
}
