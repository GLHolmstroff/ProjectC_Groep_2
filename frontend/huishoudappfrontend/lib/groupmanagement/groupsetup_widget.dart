import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:huishoudappfrontend/groupmanagement/creategroup_widget.dart';
import 'package:huishoudappfrontend/groupmanagement/title_widget.dart';

import 'joingroup_widget.dart';

class GroupWidget extends StatefulWidget {
  static String tag = "group_widget";
  _GroupWidget createState() => _GroupWidget();
}

class _GroupWidget extends State<GroupWidget> {
  void _makeGroup() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => new Creategroup_widget(),
        ));
  }

  void _joinGroup() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Joingroup_Widget(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final explanationText1 = Text(
      "U zit nog niet in een huis",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20.0,
        // fontWeight: FontWeight.w400
      ),
    );

    final explanationText2 = Text(
      "Maak een huis aan of neem deel aan een huis",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20.0,
      ),
    );

    final uitnodigingText = Text(
      "Uitnodigingen",
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.w300),
    );

    final makeGroupButton = RaisedButton(
      onPressed: _makeGroup,
      child: Text('Maak een nieuw huis aan', style: TextStyle(fontSize: 20)),
    );

    final joinGroupButton = RaisedButton(
      onPressed: _joinGroup,
      child: Text('Neem deel aan een huis', style: TextStyle(fontSize: 20)),
    );

    // TODO: implement build
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Title_Widget(text: "Setup"),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(child: explanationText1),
              Center(child: explanationText2),
              Column(
                children: <Widget>[
                  Center(child: makeGroupButton),
                  Center(child: joinGroupButton),
                ],
              )
            ],
          ),
        ),
      ],
    ));
  }
}
