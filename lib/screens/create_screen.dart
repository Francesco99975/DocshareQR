import 'dart:io';

import 'package:docshareqr/providers/qrdocs.dart';
import 'package:docshareqr/screens/error_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'loading_screen.dart';

class CreateScreen extends StatefulWidget {
  static const routeName = "/create";
  const CreateScreen({Key? key}) : super(key: key);

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  late Size deviceSize;
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _isLoading = false;
  bool _isProtected = false;

  String _name = "";
  String _password = "";
  List<File> _files = [];

  Future<void> _pickFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      setState(() {
        _files = result.paths.map((path) => File(path!)).toList();
      });
    } else {
      setState(() {
        _files = [];
      });
    }
  }

  Future<void> _save() async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      var res = await Provider.of<QRDocs>(context, listen: false)
          .addQRDoc(_name, _password, _files.map((e) => e.path).toList());

      if (res) {
        Navigator.of(context).pop();
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Theme.of(context).primaryColorDark,
            duration: const Duration(seconds: 3),
            content: Text(
              Provider.of<QRDocs>(context, listen: false).lastError,
              style: Theme.of(context).textTheme.bodyText1,
            )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return _isLoading
        ? const LoadingScreen()
        : Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              foregroundColor: Theme.of(context).primaryColor,
              centerTitle: true,
              title: Text(
                "Create QR Code",
                style: Theme.of(context).textTheme.headline1,
              ),
              actions: [
                TextButton.icon(
                    onPressed: _save,
                    icon: Icon(
                      Icons.save,
                      size: 30,
                      color: Theme.of(context).primaryColor,
                    ),
                    label: Text(
                      "SAVE",
                      style: Theme.of(context).textTheme.bodyText2!,
                    ))
              ],
            ),
            body: InkWell(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SafeArea(
                    child: SingleChildScrollView(
                        child: Column(
                  children: [
                    Container(
                      height: deviceSize.height / 1.3,
                      width: deviceSize.width,
                      color: Theme.of(context).backgroundColor,
                      margin: const EdgeInsets.all(18.0),
                      padding: const EdgeInsets.all(5.0),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TextFormField(
                                autocorrect: false,
                                initialValue: _name,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                                decoration: InputDecoration(
                                  labelText: "Name",
                                  labelStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(fontSize: 16),
                                  hintText: 'Enter name',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(fontSize: 14),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                                validator: (value) => value!.trim().isEmpty
                                    ? "Enter a name please"
                                    : null,
                                onSaved: (newValue) => _name = newValue!.trim(),
                              ),
                              const SizedBox(
                                height: 50.0,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Protect with password",
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  Switch.adaptive(
                                      value: _isProtected,
                                      onChanged: (_) {
                                        setState(() {
                                          _isProtected = !_isProtected;
                                        });
                                      }),
                                ],
                              ),
                              if (_isProtected)
                                TextFormField(
                                  autocorrect: false,
                                  initialValue: _password,
                                  obscureText: true,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                  decoration: InputDecoration(
                                    labelText: "Password",
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(fontSize: 16),
                                    hintText: 'Enter password',
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(fontSize: 14),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                  validator: (value) => value!.trim().isEmpty
                                      ? "Enter a password please"
                                      : null,
                                  onSaved: (newValue) =>
                                      _password = newValue!.trim(),
                                ),
                              const SizedBox(
                                height: 50.0,
                              ),
                              TextButton.icon(
                                  onPressed: _pickFiles,
                                  icon: Icon(
                                    Icons.file_copy,
                                    size: 30,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  label: Text(
                                    "Select Files",
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  )),
                              if (_files.isNotEmpty)
                                SizedBox(
                                  height: 200,
                                  child: ListView.builder(
                                    itemCount: _files.length,
                                    itemBuilder: (context, index) => ListTile(
                                      title: Text(
                                        _files[index].path.substring(
                                            _files[index]
                                                    .path
                                                    .lastIndexOf("/") +
                                                1),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )))));
  }
}
