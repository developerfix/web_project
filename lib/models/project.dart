import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  String? projectId;
  String? title;
  String? subtitle;
  String? lead;
  String? copilot;
  String? category;

  Project(
      {this.projectId,
      this.title,
      this.subtitle,
      this.lead,
      this.copilot,
      this.category});

  Map<String, dynamic> toJson() => {
        "projectId": projectId,
        "title": title,
        "subtitle": subtitle,
        "lead": lead,
        "copilot": copilot,
        "category": category
      };

  static Project fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Project(
        projectId: snapshot['projectId'],
        title: snapshot['title'],
        subtitle: snapshot['subtitle'],
        copilot: snapshot['copilot'],
        category: snapshot['category'],
        lead: snapshot['lead']);
  }
}
