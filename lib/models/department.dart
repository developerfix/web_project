import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firedart.dart';

class Department {
  String? departmentId;
  String? title;
  int? iconCode;

  Department({
    this.departmentId,
    this.title,
    this.iconCode,
  });

  Map<String, dynamic> toJson() => {
        "departmentId": departmentId,
        "title": title,
        "iconCode": iconCode,
      };

  static Department fromSnap(Document snap) {
    var snapshot = snap.map;
    return Department(
      departmentId: snapshot['departmentId'],
      title: snapshot['title'],
      iconCode: snapshot['iconCode'],
    );
  }

  static Department fromQuerySnap(QueryDocumentSnapshot snap) {
    var snapshot = snap;
    return Department(
      departmentId: snapshot['departmentId'],
      title: snapshot['title'],
      iconCode: snapshot['iconCode'],
    );
  }

  static Department fromDocSnap(DocumentSnapshot snap) {
    var snapshot = snap;
    return Department(
      departmentId: snapshot['departmentId'],
      title: snapshot['title'],
      iconCode: snapshot['iconCode'],
    );
  }
}
