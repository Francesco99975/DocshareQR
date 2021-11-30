import 'package:docshareqr/providers/qrdocs.dart';
import 'package:docshareqr/providers/theme_changer.dart';
import 'package:docshareqr/screens/create_screen.dart';
import 'package:docshareqr/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const DocshareQR());
}

class DocshareQR extends StatelessWidget {
  const DocshareQR({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => ThemeChanger(ThemeChanger.dark)),
          ChangeNotifierProvider(create: (_) => QRDocs())
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
