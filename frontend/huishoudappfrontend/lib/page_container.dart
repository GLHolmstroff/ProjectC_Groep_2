import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:huishoudappfrontend/home_widget.dart';
import 'package:huishoudappfrontend/beer_widget.dart';
import 'package:huishoudappfrontend/createaccount_widget.dart';
import 'package:huishoudappfrontend/main.dart';
import 'package:huishoudappfrontend/setup/provider.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'package:huishoudappfrontend/setup/validators.dart';
import 'package:http/http.dart';
import 'Objects.dart';
import 'profile.dart';
import 'package:huishoudappfrontend/schoonmaakrooster_widget.dart';
import 'package:huishoudappfrontend/turf_widget.dart';

import 'placeholder_widget.dart';

class HomePage extends StatefulWidget {
  static String tag = 'home-page';

  static Future<HomePage> _init() async {
    return HomePage();
  }

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Home_widget(),
    SchoonmaakPage(),
    Turfwidget(),
    Profilepage()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

// set all the child widgets for the scaffold body
  void _setChildren() {
    // replace the placeholder widget with your widget
    // give _steNewBody as argument if you want to change the currentwidget from inside your widget
    setState(() => [
        Home_widget(),
        PlaceholderWidget(Colors.deepOrange),
        PlaceholderWidget(Colors.green),
        Profilepage()
      ]);
  }


  @override
  Widget build(BuildContext context) {
    // initialize all the children, cant be done in the constructor because we are parsing a function
    _setChildren();
    return Scaffold(
      /*appBar: AppBar(
        title: Text('Welcome Page'),
        actions: <Widget>[
          FlatButton(
            child: Text("Jouw profiel"),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Profilepage()));
            },
          )
        ],
      ),
      // The body of the scaffold is the currentwidget
      body: _currentWidget,
      ),*/
      body: _children[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        // type needs to be fixed otherwise the color of the navigationBariItems will be white, (weird bug)
        type: BottomNavigationBarType.fixed,
        // set function for when an navigationbaritem is tapped 
        onTap: onTabTapped,
        currentIndex:
            _currentIndex, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Huis'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.check),
            title: new Text('Rooster'),
          ),
          BottomNavigationBarItem(
              icon: new Icon(Icons.list), title: new Text("Turven")),
          BottomNavigationBarItem(
              icon: new Icon(Icons.person), title: new Text("Profile"))
        ],
      ),
    );
  }
}
