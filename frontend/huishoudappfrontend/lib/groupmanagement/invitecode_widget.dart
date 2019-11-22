import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

class InviteCode_widget extends StatefulWidget {
  _InviteCodeWidgetState createState() => _InviteCodeWidgetState();
}

class _InviteCodeWidgetState extends State {
  void _getCode() {
    
    // Response code =  await get("http://10.0.2.2:8080/getInviteCode?gid=$uid";
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final getCodeButton = RaisedButton(
      onPressed: _getCode,
      child: Text('Krijg een eenmalige code', style: TextStyle(fontSize: 20)),
    );

    return Container(
      child: Column(
        children: <Widget>[],
      ),
    );
  }
}
