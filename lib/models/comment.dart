import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firedart.dart';

class Comment {
  String? type;
  String? comment;
  Map? fileNameAndDownloadUrl;
  String? username;
  DateTime? createdAt;

  Comment(
      {this.type,
      this.comment,
      this.fileNameAndDownloadUrl,
      this.username,
      this.createdAt});

  Map<String, dynamic> toJson() => {
        "type": type,
        "comment": comment,
        "username": username,
        "fileNameAndDownloadUrl": fileNameAndDownloadUrl,
        "createdAt": createdAt
      };

  static Comment fromSnap(Document snap) {
    var snapshot = snap.map;
    return Comment(
        type: snapshot['type'],
        comment: snapshot['comment'],
        username: snapshot['username'],
        fileNameAndDownloadUrl: snapshot['fileNameAndDownloadUrl'],
        createdAt: snapshot['createdAt']);
  }

  static Comment fromQuerySnap(QueryDocumentSnapshot snap) {
    var snapshot = snap;
    return Comment(
        type: snapshot['type'],
        comment: snapshot['comment'],
        username: snapshot['username'],
        fileNameAndDownloadUrl: snapshot['fileNameAndDownloadUrl'],
        createdAt: snapshot['createdAt']);
  }
}
