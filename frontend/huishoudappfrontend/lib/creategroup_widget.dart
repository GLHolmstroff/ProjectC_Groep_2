import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:huishoudappfrontend/setup/auth.dart';

import 'Objects.dart';

class Creategroup_widget extends StatefulWidget {
  static String tag = "Creategroup_widget";
  _Creategroup_widget createState() => _Creategroup_widget();
}

class _Creategroup_widget extends State {
  final _groupnameController = TextEditingController();
  Future<void> _makeGroup() async {
    String groupname = _groupnameController.text;
    if (groupname.length > 4) {
      String uid = await Auth().currentUser();
      
      final response = await get("http://10.0.2.2:8080/createGroup?name=$groupname&uid=$uid");
      if (response.statusCode == 200) {
        print("Succesfully Registered");
      } else {
        print("Connection Failed");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleText = Text(
      "Groep aanmaken",
      textAlign: TextAlign.left,
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold));

    final groupName = TextFormField(
      keyboardType: TextInputType.text,
      controller: _groupnameController,
      decoration: InputDecoration(
        hintText: 'Groepsnaam',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final groepsledenText = Text(
      "Groepsleden",
      textAlign: TextAlign.center,
    );

    final makeGroupButton = RaisedButton(
      onPressed: _makeGroup,
      child: Text('Uitnodigen en verder', style: TextStyle(fontSize: 20)),
    );

    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top:40.0, left: 8.0),
          child: Container(
            height: 80.0,
            child: titleText,
          ),
        ),
        Container(child: groupName),
        Container(
          child: groepsledenText,
        ),
        Container(
          child: makeGroupButton,
        )
      ],
    ));
  }
}
