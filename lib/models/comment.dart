import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firedart.dart';

class Comment {
  String? type;
  String? comment;
  String? downloadUrl;
  String? username;
  String? filename;
  DateTime? createdAt;

  Comment(
      {this.type,
      this.comment,
      this.downloadUrl,
      this.username,
      this.filename,
      this.createdAt});

  Map<String, dynamic> toJson() => {
        "type": type,
        "comment": comment,
        "username": username,
        "downloadUrl": downloadUrl,
        "filename": filename,
        "createdAt": createdAt
      };

  static Comment fromSnap(Document snap) {
    var snapshot = snap.map;
    return Comment(
        type: snapshot['type'],
        comment: snapshot['comment'],
        username: snapshot['username'],
        downloadUrl: snapshot['downloadUrl'],
        filename: snapshot['filename'],
        createdAt: snapshot['createdAt']);
  }

  static Comment fromQuerySnap(QueryDocumentSnapshot snap) {
    var snapshot = snap;
    return Comment(
        type: snapshot['type'],
        comment: snapshot['comment'],
        username: snapshot['username'],
        downloadUrl: snapshot['downloadUrl'],
        filename: snapshot['filename'],
        createdAt: snapshot['createdAt']);
  }
}
