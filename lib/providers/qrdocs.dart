import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:docshareqr/providers/qrdoc.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

const testUrl = "http://10.0.2.2:5000";
const baseUrl = "https://docshareqr.dmz.urx.ink";

Future<List<String>> _getDeviceDetails() async {
  late String deviceName;
  late String deviceVersion;
  late String identifier;
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  try {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceName = androidInfo.model!;
      deviceVersion = androidInfo.version.toString();
      identifier = androidInfo.androidId!; //UUID for Android
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceName = iosInfo.utsname.machine!;
      deviceVersion = iosInfo.systemVersion!;
      identifier = iosInfo.identifierForVendor!; //UUID for iOS
    }
  } on PlatformException {
    exit(0);
  }

//if (!mounted) return;
  return [deviceName, deviceVersion, identifier];
}

class QRDocs with ChangeNotifier {
  List<QRDoc> _items = [];
  late String deviceId;
  String lastError = "Something went wrong";

  List<QRDoc> get items => _items;

  int get size => _items.length;

  Future<bool> loadQRDocs() async {
    deviceId = (await _getDeviceDetails())[2];
    try {
      var res = json
          .decode((await http.get(Uri.parse('$baseUrl/media/$deviceId'))).body);

      List<QRDoc> temp = [];

      for (var el in res) {
        temp.add(QRDoc.fromMap(el));
      }

      _items = temp;
      return true;
    } catch (e) {
      lastError = "Files too large or invalid";

      return false;
    }
  }

  Future<bool> addQRDoc(
      String name, String password, List<String> files) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/media'));
      request.fields["name"] = name;
      request.fields["password"] = password;
      request.fields["deviceId"] = deviceId;

      for (var file in files) {
        var fileData = File(file).readAsBytesSync();
        var mime = lookupMimeType(file);
        request.files.add(http.MultipartFile.fromBytes(file, fileData,
            contentType: MediaType(mime!.substring(0, mime.indexOf("/")),
                mime.substring(mime.indexOf("/") + 1)),
            filename: file.split("/").last));
      }

      http.Response response =
          await http.Response.fromStream(await request.send());

      _items.add(QRDoc.fromMap(json.decode(response.body)));
      notifyListeners();
      return true;
    } catch (e) {
      lastError = "Files too large or invalid";

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
      await http.delete(Uri.parse('$baseUrl/media/$id'));

      _items.removeWhere((itm) => itm.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      lastError = "Files too large or invalid";

      return false;
    }
  }
}
