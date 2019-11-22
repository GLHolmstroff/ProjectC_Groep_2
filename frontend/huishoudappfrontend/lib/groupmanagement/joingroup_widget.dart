import 'package:flutter/material.dart';
import 'package:huishoudappfrontend/groupmanagement/title_widget.dart';

class Joingroup_Widget extends StatelessWidget {
  final _inviteCodeController = TextEditingController();

  void _joinGroup() {}

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
            children: <Widget>[
          Title_Widget(text:"Deelnemen aan een huis"),
          Center(
            child: explanationText1,
          ),
          Center(
            child: inviteCode,
          ),
          Center(child: joinGroupButton),
        ]));
  }
}
