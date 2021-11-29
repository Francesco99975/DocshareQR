import 'dart:io';

import 'package:docshareqr/providers/qrdocs.dart';
import 'package:docshareqr/providers/theme_changer.dart';
import 'package:docshareqr/screens/create_screen.dart';
import 'package:docshareqr/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:device_info/device_info.dart';

Future<List<String>> _getDeviceDetails() async {
  late String deviceName;
  late String deviceVersion;
  late String identifier;
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  try {
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      deviceName = build.model;
      deviceVersion = build.version.toString();
      identifier = build.androidId; //UUID for Android
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      deviceName = data.name;
      deviceVersion = data.systemVersion;
      identifier = data.identifierForVendor; //UUID for iOS
    }
  } on PlatformException {
    exit(0);
  }

//if (!mounted) return;
  return [deviceName, deviceVersion, identifier];
}

Future<void> main() async {
  List<String> info = await _getDeviceDetails();
  runApp(DocshareQR(info));
}

class DocshareQR extends StatelessWidget {
  final List<String> info;
  const DocshareQR(this.info, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => ThemeChanger(ThemeChanger.dark)),
          ChangeNotifierProvider(create: (_) => QRDocs(deviceId: info[2]))
        ],
        builder: (context, child) {
          final themeChanger = Provider.of<ThemeChanger>(context);
          return MaterialApp(
            title: 'Docshare QR',
            theme: themeChanger.theme,
            home: const Home(),
            routes: {CreateScreen.routeName: (_) => const CreateScreen()},
          );
        });
  }
}
