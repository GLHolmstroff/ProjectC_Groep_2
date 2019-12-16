import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:huishoudappfrontend/Objects.dart';
import 'package:huishoudappfrontend/groupmanagement/title_widget.dart';

class InviteCode_widget extends StatefulWidget {
  _InviteCodeWidgetState createState() => _InviteCodeWidgetState();
}

class _InviteCodeWidgetState extends State {

  String text = "Nog geen code gegeneerd";

  Future<void> _getCode() async {
    CurrentUser currentUser = CurrentUser();
    int gid = currentUser.groupId;
    Response res =  await get("http://10.0.2.2:8080/getInviteCode?gid=$gid");
    String code = json.decode(res.body)["code"].toString();
    setState(() {
      text = code;
    });
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final getCodeButton = RaisedButton(
      color: Colors.orange[700],
      onPressed: _getCode,
      child: Text('Krijg een eenmalige code', style: TextStyle(color: Colors.white)),
    );

    final codeText = Text(
      text,
      style: TextStyle(fontSize: 20)
    );

    return 
    Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Title_Widget(text: "Uitnodigingscode"),
          Expanded(
                      child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                
                Center(child: codeText),
                Center(child: getCodeButton)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
