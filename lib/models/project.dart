import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firedart.dart';

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

  static Project fromSnap(Document snap) {
    var snapshot = snap.map;
    return Project(
        projectId: snapshot['projectId'],
        title: snapshot['title'],
        subtitle: snapshot['subtitle'],
        copilot: snapshot['copilot'],
        category: snapshot['category'],
        lead: snapshot['lead']);
  }

  static Project fromQuerySnap(QueryDocumentSnapshot snap) {
    var snapshot = snap;
    return Project(
        projectId: snapshot['projectId'],
        title: snapshot['title'],
        subtitle: snapshot['subtitle'],
        copilot: snapshot['copilot'],
        category: snapshot['category'],
        lead: snapshot['lead']);
  }

  static Project fromDocSnap(DocumentSnapshot snap) {
    var snapshot = snap;
    return Project(
        projectId: snapshot['projectId'],
        title: snapshot['title'],
        subtitle: snapshot['subtitle'],
        copilot: snapshot['copilot'],
        category: snapshot['category'],
        lead: snapshot['lead']);
  }
}
