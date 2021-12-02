import 'package:docshareqr/providers/qrdoc.dart';
import 'package:docshareqr/providers/qrdocs.dart';
import 'package:docshareqr/screens/error_screen.dart';
import 'package:docshareqr/screens/qr_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class QrListItem extends StatelessWidget {
  const QrListItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final qrDoc = Provider.of<QRDoc>(context);
    return Dismissible(
      key: ValueKey(qrDoc.id),
      // background: Container(
      //   padding: const EdgeInsets.only(left: 20),
      //   margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
      //   color: Theme.of(context).primaryColor,
      //   child: Icon(
      //     Icons.edit,
      //     color: Theme.of(context).colorScheme.secondary,
      //     size: 40,
      //   ),
      //   alignment: Alignment.centerLeft,
      // ),
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
        color: Theme.of(context).errorColor,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
      ),
      // ignore: missing_return
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Theme.of(context).backgroundColor,
              title: Text(
                "Are you sure ?",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              content: Text(
                "Do you want to remove this item?",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              actions: <Widget>[
                TextButton(
                  child: Text("No",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: Colors.red)),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: Text("Yes",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: Colors.green)),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            ),
          );
        }
      },
      onDismissed: (direction) async {
        if (direction == DismissDirection.endToStart) {
          final result = await Provider.of<QRDocs>(context, listen: false)
              .deleteQRDoc(qrDoc.id!);

          if (!result) {
            Navigator.of(context).pushReplacementNamed(ErrorScreen.routeName,
                arguments: {'home': true});
          }
        }
      },
      child: Card(
        elevation: 3,
        color: Theme.of(context).primaryColor,
        child: ListTile(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => QrDetailScreen(qrDoc),
          )),
          leading: CircleAvatar(
            child: Icon(Icons.document_scanner,
                color: Theme.of(context).colorScheme.secondary, size: 26),
          ),
          title: Text(
            qrDoc.title,
            style: Theme.of(context).textTheme.bodyText1!,
          ),
          subtitle: Text(
            "Available until: ${DateFormat.yMMMMEEEEd().format(qrDoc.createdAt.add(const Duration(days: 3)))}",
            style:
                Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
