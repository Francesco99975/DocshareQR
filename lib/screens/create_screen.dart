import 'package:docshareqr/providers/qrdocs.dart';
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

  late String _name;
  late String _password;
  late List<String> _files = [];

  Future<void> _pickFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      _files = result.paths.map((path) => path!).toList();
    } else {
      _files = [];
    }
  }

  Future<void> _save() async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      var res = await Provider.of<QRDocs>(context, listen: false)
          .addQRDoc(_name, _password, _files);

      if (res) {
        Navigator.of(context).pop();
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    icon: const Icon(Icons.save),
                    label: const Text("SAVE"))
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
                                      .bodyText1!
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
                              Switch.adaptive(
                                  value: _isProtected,
                                  onChanged: (_) {
                                    setState(() {
                                      _isProtected = !_isProtected;
                                    });
                                  }),
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
                                        .bodyText1!
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
                                  icon: const Icon(Icons.file_copy),
                                  label: Text(
                                    "Select Files",
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  )),
                              if (_files.isNotEmpty)
                                ListView.builder(
                                  itemCount: _files.length,
                                  itemBuilder: (context, index) => ListTile(
                                    title: Text(_files[index]),
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
