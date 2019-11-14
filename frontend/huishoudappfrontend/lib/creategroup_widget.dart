import 'package:flutter/material.dart';

class Creategroup_widget extends StatefulWidget {
  static String tag = "Creategroup_widget";
  _Creategroup_widget createState() => _Creategroup_widget();
}

class _Creategroup_widget extends State {
  void _makeGroup() {}

  @override
  Widget build(BuildContext context) {
    final titleText = Text(
      "Groep aanmaken",
      textAlign: TextAlign.center,
    );

    final groupName = TextFormField(
      keyboardType: TextInputType.text,
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
      child: Text('Uitnodigen en verder', style: TextStyle(fontSize: 20)),
    );

    // return Scaffold(
    //   body: Center(
    //       child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: <Widget>[
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: <Widget>[
    //           Padding(
    //             padding: EdgeInsets.all(20),
    //             child: titleText,
    //           )
    //         ],
    //       ),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: <Widget>[
    //           Padding(
    //             padding: EdgeInsets.all(20),
    //             child: groupName,
    //           )
    //         ],
    //       ),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: <Widget>[
    //           Padding(
    //             padding: EdgeInsets.all(20),
    //             child: groepsledenText,
    //           )
    //         ],
    //       ),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: <Widget>[
    //           Padding(
    //             padding: EdgeInsets.all(20),
    //             child: makeGroupButton,
    //           )
    //         ],
    //       )
    //     ],
    //   )),
    // );
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: titleText,
          ),
          Container(child: groepsledenText,),
          Container(child: makeGroupButton,)
        ],
      )
    );
  }
}
