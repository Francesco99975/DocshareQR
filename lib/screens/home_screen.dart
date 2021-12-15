import 'package:docshareqr/providers/qrdocs.dart';
import 'package:docshareqr/providers/theme_changer.dart';
import 'package:docshareqr/screens/create_screen.dart';
import 'package:docshareqr/widgets/qr_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'error_screen.dart';
import 'loading_screen.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        backgroundColor: Theme.of(context).primaryColorDark,
        color: Theme.of(context).colorScheme.secondary,
        onRefresh: () => Navigator.of(context).pushReplacementNamed("/"),
        child: FutureBuilder<bool>(
            future: Provider.of<QRDocs>(context, listen: false).loadQRDocs(),
            builder: (_, snapshot) => snapshot.connectionState ==
                    ConnectionState.waiting
                ? const LoadingScreen()
                : snapshot.data! == false
                    ? const ErrorScreen()
                    : Scaffold(
                        backgroundColor: Theme.of(context).backgroundColor,
                        appBar: AppBar(
                          backgroundColor: Theme.of(context).backgroundColor,
                          foregroundColor: Theme.of(context).primaryColor,
                          centerTitle: true,
                          title: Text(
                            "Docshare QR",
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          actions: [
                            Consumer<ThemeChanger>(
                              builder: (_, themeChanger, __) => IconButton(
                                  onPressed: () => themeChanger.toggle(),
                                  icon: Icon(themeChanger.isDark
                                      ? Icons.light_mode
                                      : Icons.dark_mode)),
                            ),
                            IconButton(
                                onPressed: () => Navigator.of(context)
                                    .pushNamed(CreateScreen.routeName),
                                icon: const Icon(Icons.qr_code_2_sharp))
                          ],
                        ),
                        body: SafeArea(
                          child: Consumer<QRDocs>(
                              builder: (context, qrdocs, child) {
                                if (qrdocs.size > 0) {
                                  return ListView.builder(
                                    itemCount: qrdocs.size,
                                    itemBuilder: (context, index) =>
                                        ChangeNotifierProvider.value(
                                      value: qrdocs.items[index],
                                      child: const QrListItem(),
                                    ),
                                  );
                                } else {
                                  return child!;
                                }
                              },
                              child: Center(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.all(28.0),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                        alignment: Alignment.center),
                                    onPressed: () => Navigator.of(context)
                                        .pushNamed(CreateScreen.routeName),
                                    child: Text(
                                      "Tap here or QR icon to crete your first qr code",
                                      textAlign: TextAlign.center,
                                      style:
                                          Theme.of(context).textTheme.headline1,
                                    ),
                                  ),
                                ),
                              )),
                        ),
                      )));
  }
}
