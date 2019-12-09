import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:huishoudappfrontend/groupmanagement/title_widget.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'package:huishoudappfrontend/setup/validators.dart';

import '../Objects.dart';

class Admin_widget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new Admin_widget_state();
  }
}

class Admin_widget_state extends State {
  final fromkey = GlobalKey<FormState>();
  String _name;
  String userhouseName;
  var currentUser = CurrentUser();
  void initState() {
    initActual();
  }

  Future<void> initActual() async {
    String temphouse = (await House.getCurrentHouse()).houseName;

    setState(() {
      userhouseName = temphouse;
    });
  }

  
  void _submitnewname() async {
    if (fromkey.currentState.validate()) {
      fromkey.currentState.save();
      Navigator.pop(context);
      print(_name);
      int groupid = currentUser.groupId;
      final Response res = await get(
          "http://seprojects.nl:8080/setGroupName?gid=$groupid&newName=$_name",
          headers: {'Content-Type': 'application/json'});
      if(json.decode(res.body)["Succes"] == 1){
        setState(() {
          userhouseName = _name;
        });
      }
    }
  }



   void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
          title: new Text(
            "Verander huisnaam",
            style: TextStyle(color: Colors.orange[700]),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: fromkey,
              child: new TextFormField(
                keyboardType: TextInputType.text,
                validator: NameValidator.validate,
                onSaved: (value) => _name = value,
                decoration: InputDecoration(
                  hintText: 'Je nieuwe naam',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(
                      color: Colors.orange[700],
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Opslaan",
                style: TextStyle(color: Colors.orange[700]),
              ),
              onPressed: _submitnewname,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Title_Widget(
          text: "Huisbeheer",
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            FlatButton(
              
              onPressed: _showDialog, child: Text(userhouseName),
            )
          ],
        )
      ],
    ));
  }
}
