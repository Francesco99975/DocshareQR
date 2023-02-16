import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:docshareqr/providers/qrdoc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class QrDetailScreen extends StatefulWidget {
  final QRDoc qrDoc;
  const QrDetailScreen(this.qrDoc, {Key? key}) : super(key: key);

  @override
  State<QrDetailScreen> createState() => _QrDetailScreenState();
}

class _QrDetailScreenState extends State<QrDetailScreen> {
  GlobalKey globalKey = GlobalKey();

  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary? boundary = globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary?;
      var image = await boundary!.toImage();
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);

      await Share.shareFiles([file.path],
          subject: "DocshareQR",
          text: widget.qrDoc.title,
          sharePositionOrigin:
              boundary.localToGlobal(Offset.zero) & boundary.size);
    } catch (e) {
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        foregroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(
          widget.qrDoc.title,
          style: Theme.of(context).textTheme.headline1,
        ),
        actions: [
          IconButton(
              onPressed: () async => await _captureAndSharePng(),
              icon: Icon(
                Icons.share,
                size: 30,
                color: Theme.of(context).colorScheme.secondary,
              ))
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(16.0),
            width: deviceSize.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("URL",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: 22)),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () async {
                    if (await canLaunch(widget.qrDoc.url)) {
                      await launch(widget.qrDoc.url);
                    }
                  },
                  child: Container(
                    width: deviceSize.width / 1.5,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(widget.qrDoc.url,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                RepaintBoundary(
                  key: globalKey,
                  child: Center(
                    child: SizedBox(
                      width: 280,
                      child: CustomPaint(
                        size: const Size.square(280),
                        painter: QrPainter(
                          data: widget.qrDoc.url,
                          version: QrVersions.auto,
                          eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: Color.fromRGBO(255, 103, 0, 1),
                          ),
                          dataModuleStyle: const QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.circle,
                            color: Color.fromRGBO(255, 103, 0, 1),
                          ),
                          // size: 320.0,
                          // embeddedImage: snapshot.data,
                          // embeddedImageStyle: QrEmbeddedImageStyle(
                          //   size: const Size.square(60),
                          // ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
