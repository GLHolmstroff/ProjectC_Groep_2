import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:huishoudappfrontend/Objects.dart';

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
      onPressed: _getCode,
      child: Text('Krijg een eenmalige code', style: TextStyle(fontSize: 20)),
    );

    final codeText = Text(
      text
    );

    return 
    Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          codeText,
          getCodeButton
        ],
      ),
    );
  }
}
