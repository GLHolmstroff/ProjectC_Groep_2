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

  void _joinGroup() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => new Creategroup_widget(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final titleText = Text(
      "Setup",
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: 40.0,
        fontWeight: FontWeight.w400
        ),
  
    );

    final explanationText1 = Text(
      "U zit nog niet in een groep",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20.0,
        // fontWeight: FontWeight.w400
        ),
  
    );

     final explanationText2 = Text(
      "Maak een groep aan of neem deel aan een groep",
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
      child: Text('Maak een nieuwe groep', style: TextStyle(fontSize: 20)),
    );

    final joinGroupButton = RaisedButton(
      onPressed: _joinGroup,
      child: Text('Neem deel aan een groep', style: TextStyle(fontSize: 20)),
    );

    // TODO: implement build
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,  
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top:50.0 ),
            child: Container(
              height: 90,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: titleText,
              ),
            ),
          ),
           Center(
            child: Container(
              width: 250.0,
              height: 100.0,
              child:explanationText1
            ),
          ),
          Center(
            child: Container(
              width: 250.0,
              height:200,
              child:explanationText2
            ),
          ),
          Center(
            child: makeGroupButton
          ),
          Center(
            child: joinGroupButton
          ),
            
          
        ],

      ));
  }
}
