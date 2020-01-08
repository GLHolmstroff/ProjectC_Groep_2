import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:huishoudappfrontend/Objects.dart';
import 'package:huishoudappfrontend/groupmanagement/title_widget.dart';

import '../page_container.dart';

class Joingroup_Widget extends StatefulWidget {
  static String tag = "Creategroup_widget";
  Joingroup_WidgetState createState() => Joingroup_WidgetState();
}

class Joingroup_WidgetState extends State {
  final _inviteCodeController = TextEditingController();

  Future<void> _joinGroup() async {
    var currentUser = CurrentUser();
    var code = int.parse(_inviteCodeController.text);
    var uid = currentUser.userId;
    final response =
        await get("http://10.0.2.2:8080/joinGroupByCode?uid=$uid&ic=$code");
    if (response.statusCode == 200) {
      print("Succesfully Registered");
      CurrentUser.updateCurrentUser();
      //Navigator.popAndPushNamed(context, HomePage.tag);
      Navigator.pop(context);
    } else {
      print("Connection Failed");
      print(response.body);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    final joinGroupButton = RaisedButton(
      onPressed: _joinGroup,
      child: Text('Neem deel aan een groep', style: TextStyle(fontSize: 20)),
    );

    final explanationText1 = Text(
      "Voer jouw unieke code in om deel te nemen aan je huis",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20.0,
        // fontWeight: FontWeight.w400
      ),
    );

    final inviteCode = TextFormField(
      keyboardType: TextInputType.text,
      controller: _inviteCodeController,
      decoration: InputDecoration(
        hintText: 'Code',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
          Title_Widget(text: "Deelnemen aan een huis"),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: explanationText1,
                ),
                Center(
                  child: inviteCode,
                ),
                Center(child: joinGroupButton),
              ],
            ),
          ),
        ]));
  }
}
