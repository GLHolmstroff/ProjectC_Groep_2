import 'package:flutter/material.dart';
import 'package:huishoudappfrontend/groupmanagement/groupsetup_widget.dart';
import 'package:huishoudappfrontend/Objects.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'package:huishoudappfrontend/setup/provider.dart';
import 'package:http/http.dart';
import 'package:huishoudappfrontend/setup/validators.dart';

class NameSetup extends StatefulWidget {
  static String tag = "NameSetup_widget";
  _NameSetup createState() => _NameSetup();
}

class _NameSetup extends State<NameSetup> {
  final formkey = GlobalKey<FormState>();
  String _name;

  void _submitname() async {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      print(_name);
      String uid = await Provider.of(context).auth.currentUser();
      try {
        final Response res = await get(
            "http://seprojects.nl:8080/userUpdateDisplayName?uid=$uid&displayname=$_name",
            headers: {'Content-Type': 'application/json'});
        try {
          //CurrentUser tempCurrentUser = await CurrentUser.updateCurrentUser();
          Navigator.popAndPushNamed(context, GroupWidget.tag);
        } catch (e1) {
          print(e1);
        }
      } catch (e) {
        print("namesetuperror: " + e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final nameSetupText = Text("Hoe kunnen we je noemen?");
    final buttonSubmitname = RaisedButton(
      onPressed: _submitname,
      child: Text("zo heet ik!"),
    );
    final nameSetupField = Form(
      key: formkey,
      child: TextFormField(
        keyboardType: TextInputType.text,
        validator: NameValidator.validate,
        onSaved: (value) => _name = value,
        decoration: InputDecoration(
          hintText: "Je naam",
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      ),
    );
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          nameSetupText,
          nameSetupField,
          buttonSubmitname,
        ],
      ),
    );
  }
}
