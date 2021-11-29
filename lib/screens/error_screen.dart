import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  static const routeName = '/error';
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final Map<String, dynamic> args;
    try {
      args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    } catch (e) {
      args = {'home': false};
    }
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            heightFactor: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Could not connect to server.${!args['home'] ? ' Refresh' : ''}",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                if (!args['home'])
                  Icon(
                    Icons.arrow_downward,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 50,
                  ),
                if (args['home'])
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColorDark),
                      onPressed: () =>
                          Navigator.of(context).pushReplacementNamed("/"),
                      child: Text(
                        "Return to Platters",
                        style: Theme.of(context).textTheme.bodyText2,
                      ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
