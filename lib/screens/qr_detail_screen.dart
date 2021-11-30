import 'package:docshareqr/providers/qrdoc.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrDetailScreen extends StatelessWidget {
  final QRDoc qrDoc;
  const QrDetailScreen(this.qrDoc, {Key? key}) : super(key: key);

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
          qrDoc.title,
          style: Theme.of(context).textTheme.headline1,
        ),
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
                Container(
                  width: deviceSize.width / 1.5,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(qrDoc.url,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: SizedBox(
                    width: 280,
                    child: CustomPaint(
                      size: const Size.square(280),
                      painter: QrPainter(
                        data: qrDoc.url,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
