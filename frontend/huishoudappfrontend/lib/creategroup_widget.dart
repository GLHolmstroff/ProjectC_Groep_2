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

      final response = await get(
          "http://10.0.2.2:8080/createGroup?name=$groupname&uid=$uid");
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
      "Maak een groep",
      textAlign: TextAlign.left,
      style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.w400),
    );

    final explanationText1 = Text(
      "Verzin een groepsnaam",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20.0,
        // fontWeight: FontWeight.w400
      ),
    );

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
      child: Text('Aanmaken', style: TextStyle(fontSize: 20)),
    );

    return Scaffold(
      body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Container(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: titleText,
            ),
          ),
        ),
        Center(
          child:
              Container(width: 250.0, height: 50.0, child: explanationText1),
        ),
        Center(child: Container(width: 250.0, height: 100.0,child: groupName)),
        Center(
        child:Container(
          
          child: makeGroupButton,
        ))
      ],
    ));
  }
}
