// ignore: file_names
import 'package:flutter/foundation.dart';

class Issue extends ChangeNotifier {
  Issue({
    this.id,
    this.number,
    this.title,
    this.selected = false,
    this.processing = false,
    this.dragPosFactor = 0,
    this.draggingRemainingWidth,
    this.startPanChartPos = 0,
    this.remainingWidth,
    this.startTime,
    this.endTime,
    this.dependencies = const [],
  });

  String? id;

  int? number;
  String? title;

  double _width = 0;
  bool selected = false;
  bool processing = false;
  double dragPosFactor = 0;
  int? draggingRemainingWidth;
  int? remainingWidth;
  double startPanChartPos = 0;
  DateTime? startTime = DateTime.now();
  DateTime? endTime = DateTime.now();
  List<int> dependencies = [];

  double get width => _width;
  set width(double value) {
    _width = value;
    update();
  }

  void update() {
    notifyListeners();
  }

  void toggleSelect() {
    selected = !selected;
    update();
  }

  void toggleProcessing({bool notify = true}) {
    processing = !processing;

    if (notify) update();
  }

  Issue.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['number'] = number;
    data['title'] = title;
    return data;
  }
}
