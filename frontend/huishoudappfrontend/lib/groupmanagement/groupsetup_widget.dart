import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:huishoudappfrontend/groupmanagement/creategroup_widget.dart';
import 'package:huishoudappfrontend/groupmanagement/title_widget.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'package:huishoudappfrontend/setup/provider.dart';

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

    final makeGroupButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: EdgeInsets.all(12),
        color: Colors.orange[700],
        onPressed: _makeGroup,
        child: Text('Maak een nieuw huis aan',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
      ),
    );

    final joinGroupButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: EdgeInsets.all(12),
        color: Colors.orange[700],
        onPressed: _joinGroup,
        child: Text(
          'Neem deel aan een huis',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    final logout = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: EdgeInsets.all(12),
        color: Colors.orange[700],
        onPressed: () => {Provider.of(context).auth.signOut()},
        child: Text(
          "Log uit",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    // TODO: implement build
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Title_Widget(text: "Aan de slag..."),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(child: explanationText1),
              Center(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: explanationText2,
              )),
              Column(
                children: <Widget>[
                  Center(child: makeGroupButton),
                  Center(child: joinGroupButton),
                  Center(child: logout),
                ],
              )
            ],
          ),
        ),
      ],
    ));
  }
}
