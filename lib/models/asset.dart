import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firedart.dart';

class Asset {
  String? path;
  String? pathName;
  String? created;
  String? assetID;
  String? assetCategory;
  String? type;

  Asset({
    this.path,
    this.pathName,
    this.created,
    this.type,
    this.assetID,
    this.assetCategory,
  });

  Map<String, dynamic> toJson() => {
        "path": path,
        "pathName": pathName,
        "created": created,
        "type": type,
        "assetID": assetID,
        "assetCategory": assetCategory,
      };

  static Asset fromSnap(Document snap) {
    var snapshot = snap.map;
    return Asset(
      path: snapshot['path'],
      pathName: snapshot['pathName'],
      created: snapshot['created'],
      assetID: snapshot['assetID'],
      type: snapshot['type'],
      assetCategory: snapshot['assetCategory'],
    );
  }

  static Asset fromQuerySnap(QueryDocumentSnapshot snap) {
    var snapshot = snap;
    return Asset(
      path: snapshot['path'],
      pathName: snapshot['pathName'],
      assetID: snapshot['assetID'],
      type: snapshot['type'],
      created: snapshot['created'].toDate(),
      assetCategory: snapshot['assetCategory'],
    );
  }
}
