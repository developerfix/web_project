import 'package:ava/models/asset.dart';
import 'package:ava/widgets/edit_asset_file_popup.dart';
import 'package:ava/widgets/edit_cat_name_popup.dart';
import 'package:ava/widgets/plus_icon_widget.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hovering/hovering.dart';
import 'package:ava/controllers/project_controller.dart';
import 'package:ava/widgets/edit_asset_link_popup.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/style.dart';
import 'add_asset_popup.dart';

StatefulBuilder assetsSection(
  BuildContext context,
) {
  final ProjectController projectController = Get.find();
  return StatefulBuilder(builder: (context, setState) {
    List categories = [];
    List finalCategories = [];
    List<Asset> noCategoriesAssets = [];

    for (var assets in projectController.assets) {
      if (assets.assetCategory == noCategory) {
        noCategoriesAssets.add(assets);
      } else {
        categories.add(assets.assetCategory);
      }
    }
    finalCategories = categories.toSet().toList();

    return SizedBox(
      width: screenWidth(context) * 0.13,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: screenHeight(context) * 0.12,
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: txt(
                      txt: "ASSETS",
                      font: 'comfortaa',
                      fontSize: 30.0,
                      letterSpacing: 5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Divider()
              ],
            ),
          ),
          SizedBox(
            height: screenHeight(context) * 0.77,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                children: [
                  projectController.assets.isNotEmpty
                      ? assetsList(noCategoriesAssets, projectController,
                          finalCategories)
                      : Expanded(
                          child: Center(
                          child: txt(txt: 'Add assets here', fontSize: 18),
                        )),
                  plusIconWidget(context, ontap: () {
                    addAssetPopUp(context).then((value) {
                      projectController.assetCategory.value = noCategory;
                      projectController.update();
                    });
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  });
}

Expanded assetsList(List<Asset> noCategoriesAssets,
    ProjectController projectController, List<dynamic> finalCategories) {
  return Expanded(
    child: ListView(
      children: [
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: noCategoriesAssets.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return HoverCrossFadeWidget(
                cursor: SystemMouseCursors.click,
                duration: const Duration(milliseconds: 100),
                firstChild: ListTile(
                    onTap: () async {
                      await canLaunchUrl(
                              Uri.parse(noCategoriesAssets[index].path!))
                          ? await launchUrl(
                              Uri.parse(noCategoriesAssets[index].path!))
                          : null;
                    },
                    leading: Icon(
                        noCategoriesAssets[index].type == linkAssetType
                            ? Icons.link
                            : Icons.insert_drive_file,
                        color: checkThemeColorwhite54,
                        size: 18),
                    title: txt(
                        txt: noCategoriesAssets[index].pathName ?? '',
                        fontSize: 14,
                        minFontSize: 14,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    trailing: Icon(Icons.more_horiz,
                        color: checkThemeColorwhite54, size: 18)),
                secondChild: ListTile(
                  onTap: () async {
                    await canLaunchUrl(
                            Uri.parse(noCategoriesAssets[index].path!))
                        ? await launchUrl(
                            Uri.parse(noCategoriesAssets[index].path!))
                        : null;
                  },
                  leading: Icon(
                      noCategoriesAssets[index].type == linkAssetType
                          ? Icons.link
                          : Icons.insert_drive_file,
                      color: checkThemeColorwhite54,
                      size: 18),
                  title: txt(
                      txt: noCategoriesAssets[index].pathName!,
                      fontSize: 14,
                      minFontSize: 14,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  trailing: PopupMenuButton(
                      onSelected: (value) async {
                        if (value == 1) {
                          noCategoriesAssets[index].type! == linkAssetType
                              ? editAssetLinkPopUp(context,
                                  path: noCategoriesAssets[index].path!,
                                  category:
                                      noCategoriesAssets[index].assetCategory,
                                  pathName: noCategoriesAssets[index].pathName!,
                                  assetID: noCategoriesAssets[index].assetID)
                              : editAssetFilePopUp(context,
                                  path: noCategoriesAssets[index].path!,
                                  category:
                                      noCategoriesAssets[index].assetCategory,
                                  pathName: noCategoriesAssets[index].pathName!,
                                  assetID: noCategoriesAssets[index].assetID);
                        } else {
                          await projectController.deleteProjectAsset(
                              assetID: noCategoriesAssets[index].assetID);
                        }
                      },
                      elevation: 3.2,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 1,
                              child: Text(
                                'Edit',
                                maxLines: 1,
                                style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    overflow: TextOverflow.visible,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              value: 2,
                              child: Text(
                                'Delete',
                                maxLines: 1,
                                style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    overflow: TextOverflow.visible,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                      child: const Icon(Icons.more_horiz,
                          color: Color(
                            secondaryColor,
                          ),
                          size: 18)),
                ),
              );
            }),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: finalCategories.length,
            itemBuilder: (context, index) {
              return finalCategories[index] == noCategory
                  ? Container()
                  : assetSectionWidget(
                      title: finalCategories[index],
                      expandedWidget: expandableWidget(
                          projectController, finalCategories[index]));
            }),
      ],
    ),
  );
}

ListView expandableWidget(
    ProjectController? projectController, String category) {
  return ListView.builder(
      shrinkWrap: true,
      itemCount: projectController!.assets.length,
      itemBuilder: (context, i) {
        String path = '';
        String pathName = '';
        String assetID = '';
        String cat = '';
        String type = '';

        path = projectController.assets[i].path!;
        pathName = projectController.assets[i].pathName!;
        assetID = projectController.assets[i].assetID!;
        cat = projectController.assets[i].assetCategory!;
        type = projectController.assets[i].type!;

        return cat == category
            ? HoverCrossFadeWidget(
                cursor: SystemMouseCursors.click,
                duration: const Duration(milliseconds: 100),
                firstChild: ListTile(
                    onTap: () async {
                      await canLaunchUrl(Uri.parse(path))
                          ? await launchUrl(Uri.parse(path))
                          : null;
                    },
                    leading: Icon(
                        type == linkAssetType
                            ? Icons.link
                            : Icons.insert_drive_file,
                        color: checkThemeColorwhite54,
                        size: 18),
                    title: txt(
                        txt: pathName,
                        fontSize: 14,
                        minFontSize: 14,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    trailing: Icon(Icons.more_horiz,
                        color: checkThemeColorwhite54, size: 18)),
                secondChild: ListTile(
                  onTap: () async {
                    await canLaunchUrl(Uri.parse(path))
                        ? await launchUrl(Uri.parse(path))
                        : null;
                  },
                  leading: Icon(
                      type == linkAssetType
                          ? Icons.link
                          : Icons.insert_drive_file,
                      color: checkThemeColorwhite54,
                      size: 18),
                  title: txt(
                      txt: pathName,
                      fontSize: 14,
                      minFontSize: 14,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  trailing: PopupMenuButton(
                      onSelected: (value) async {
                        if (value == 1) {
                          type == linkAssetType
                              ? editAssetLinkPopUp(context,
                                  path: path,
                                  pathName: pathName,
                                  category: cat,
                                  assetID: assetID)
                              : editAssetFilePopUp(context,
                                  path: path,
                                  category: cat,
                                  pathName: pathName,
                                  assetID: assetID);
                        } else {
                          await projectController.deleteProjectAsset(
                              assetID: projectController.assets[i].assetID);
                        }
                      },
                      elevation: 3.2,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 1,
                              child: Text(
                                'Edit',
                                maxLines: 1,
                                style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    overflow: TextOverflow.visible,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              value: 2,
                              child: Text(
                                'Delete',
                                maxLines: 1,
                                style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    overflow: TextOverflow.visible,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                      child: const Icon(Icons.more_horiz,
                          color: Color(
                            secondaryColor,
                          ),
                          size: 18)),
                ),
              )
            : Container();
      });
}

ExpandableNotifier assetSectionWidget({
  required String title,
  // required String assetCatTitle,
  required Widget expandedWidget,
}) {
  return ExpandableNotifier(
      initialExpanded: true,
      child: Column(children: [
        ScrollOnExpand(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Builder(builder: (context) {
                var controller =
                    ExpandableController.of(context, required: true)!;

                return Expandable(
                  collapsed: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: txt(
                                  txt: title,
                                  fontSize: 14,
                                  minFontSize: 14,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  fontColor: checkThemeColorwhite54),
                            ),
                            GestureDetector(
                                onTap: () {
                                  editAssetCategoryNamePopUp(context, title);
                                },
                                child: Icon(
                                  Icons.edit,
                                  size: 16,
                                  color: checkThemeColorwhite54,
                                )),
                            GestureDetector(
                                onTap: () {
                                  controller.toggle();
                                },
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: checkThemeColorwhite54,
                                )),
                          ],
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                  expanded: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: txt(
                                  txt: title,
                                  fontSize: 14,
                                  minFontSize: 14,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  fontColor: checkThemeColorwhite54),
                            ),
                            const Spacer(),
                            GestureDetector(
                                onTap: () {
                                  editAssetCategoryNamePopUp(context, title);
                                },
                                child: Icon(
                                  Icons.edit,
                                  size: 16,
                                  color: checkThemeColorwhite54,
                                )),
                            GestureDetector(
                                onTap: () {
                                  controller.toggle();
                                },
                                child: Icon(Icons.keyboard_arrow_up,
                                    color: checkThemeColorwhite54)),
                          ],
                        ),
                        const Divider(),
                        expandedWidget
                      ],
                    ),
                  ),
                );
              })
            ]))
      ]));
}
