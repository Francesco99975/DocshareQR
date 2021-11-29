import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRDoc with ChangeNotifier {
  String? id;
  late String title;
  late String url;
  late QrImage qrCode;
  late DateTime createdAt;

  QRDoc(
      {this.id,
      required this.title,
      required this.url,
      required this.qrCode,
      required this.createdAt});

  QRDoc.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    title = map["name"];
    url = map["url"];
    qrCode = QrImage(
      data: map["url"],
      version: QrVersions.auto,
      size: 200.0,
    );
    createdAt = DateTime.parse(map["createdAt"]);
  }

  // Map<String, dynamic> toMapAdd() {
  //   var map = <String, dynamic>{'title': title, 'url': qrCode.toStringDeep()};

  //   return map;
  // }

  // Map<String, dynamic> toMapUpdate() {
  //   var map = <String, dynamic>{
  //     'id': id,
  //     'title': title,
  //     'url': qrCode.toStringDeep()
  //   };

  //   return map;
  // }
}
