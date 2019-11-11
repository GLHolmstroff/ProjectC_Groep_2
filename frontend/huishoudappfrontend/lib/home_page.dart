import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:huishoudappfrontend/home_widget.dart';
import 'package:huishoudappfrontend/beer_page.dart';
import 'package:huishoudappfrontend/createaccount_page.dart';
import 'package:huishoudappfrontend/main.dart';
import 'package:huishoudappfrontend/setup/provider.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'package:huishoudappfrontend/setup/validators.dart';
import 'package:http/http.dart';
import 'Objects.dart';
import 'profile.dart'

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
    PlaceholderWidget(Colors.deepOrange),
    PlaceholderWidget(Colors.green),
    PlaceholderWidget(Colors.green)
  ];

 

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome Page'),
        actions: <Widget>[
          FlatButton(
            child: Text("Jouw profiel"),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Profilepage()));
            },
          )
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex:
            _currentIndex, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Huis'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.list),
            title: new Text('Rooster'),
          ),
          BottomNavigationBarItem(
              icon: new Icon(Icons.list), title: new Text("Turven")),
          BottomNavigationBarItem(
              icon: new Icon(Icons.people), title: new Text("Profile"))
        ],
      ),
    );
  }
}
