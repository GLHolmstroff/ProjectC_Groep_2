import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:huishoudappfrontend/creategroup_widget.dart';

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

  @override
  Widget build(BuildContext context) {
    final titleText = Text(
      "U zit nog niet in een groep",
      textAlign: TextAlign.center,
    );

    final explanationText = Text(
      "Maak een groep aan, of accepteer een uitnodiging",
      textAlign: TextAlign.center,
    );

    final uitnodigingText = Text(
      "Uitnodigingen",
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.bold),
    );

    final makeGroupButton = RaisedButton(
      onPressed: _makeGroup,
      child: Text('Maak een nieuwe groep', style: TextStyle(fontSize: 20)),
    );

    // TODO: implement build
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(padding: const EdgeInsets.all(20.0), child: titleText)
            ],
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child: explanationText,
              )
            ],
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child: uitnodigingText,
              )
            ],
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: makeGroupButton,
              )
            ],
          ),
        ],
      )),
    );
  }
}
