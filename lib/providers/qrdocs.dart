import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:docshareqr/providers/qrdoc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const testUrl = "http://10.0.2.2:5000";
const baseUrl = "https://docshareqr.francescobarranca.dev";

class QRDocs with ChangeNotifier {
  List<QRDoc> _items = [];
  late String deviceId;

  List<QRDoc> get items => _items;

  int get size => _items.length;

  QRDocs({required this.deviceId});

  Future<bool> loadQRDocs() async {
    try {
      var res = json
          .decode((await http.get(Uri.parse('$testUrl/media/$deviceId'))).body);

      List<QRDoc> temp = [];

      for (var el in res) {
        temp.add(QRDoc.fromMap(el));
      }

      _items = temp;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addQRDoc(
      String name, String password, List<String> files) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$testUrl/media'));
      request.fields["name"] = name;
      request.fields["password"] = password;
      request.fields["deviceId"] = deviceId;

      for (var file in files) {
        request.files.add(http.MultipartFile.fromBytes(
            file, File(file).readAsBytesSync(),
            filename: file.split("/").last));
      }

      var response = await request.send();

      _items.add(QRDoc.fromMap(response.headers));
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Future<bool> updateQRDoc(QRDoc qrdoc) async {
  //   try {
  //     var res = json.decode((await http.put(Uri.parse('$testUrl/qrdocs'),
  //             headers: {
  //               'Content-type': 'application/json',
  //               "Accept": "application/json"
  //             },
  //             body: json.encode(qrdoc.toMapUpdate())))
  //         .body);

  //     final index = _items.indexWhere((itm) => itm.id == qrdoc.id);
  //     _items[index] = QRDoc.fromMap(res['result']);
  //     notifyListeners();
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  Future<bool> deleteQRDoc(String id) async {
    try {
      await http.delete(Uri.parse('$testUrl/media/$id'));

      _items.removeWhere((itm) => itm.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}
