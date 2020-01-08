import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:huishoudappfrontend/design.dart';
import 'package:huishoudappfrontend/home_widget.dart';
import 'package:huishoudappfrontend/turf_widget.dart';
import 'package:huishoudappfrontend/turf_widget_gridview.dart';
import 'profile.dart';
import 'package:huishoudappfrontend/schedules/schoonmaakrooster_widget.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'objects.dart';

class HomePage extends StatefulWidget {
  static String tag = 'home-page';

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Widget> _children;

  //void initState() {
  //  super.initState();
  //  setState(() {
  //    _children = [
  //      Home_widget(),
  //      SchoonmaakPage(),
  //      TurfwidgetGrid(),
  //      Profilepage()
  //    ];
  //  });
  //}

  /*List<Widget> _children = [
    Home_widget(),
    SchoonmaakPage(),
    TurfwidgetGrid(),
    Profilepage()
  ];*/

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

// set all the child widgets for the scaffold body
  void _setChildren() {
    // replace the placeholder widget with your widget
    // give _steNewBody as argument if you want to change the currentwidget from inside your widget
    setState(() =>

        _children = [Home_widget(), SchoonmaakPage(), TurfwidgetGrid(), Profilepage()]);
  }

  @override
  Widget build(BuildContext context) {
    // initialize all the children, cant be done in the constructor because we are parsing a function
    _setChildren();
    CurrentUser.updateCurrentUser;
    return Scaffold(
      body: _children[_currentIndex],
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: CurvedNavigationBar(
        // type needs to be fixed otherwise the color of the navigationBariItems will be white, (weird bug)
        // set function for when an navigationbaritem is tapped
        onTap: onTabTapped,
        backgroundColor: Colors.grey[100],
        buttonBackgroundColor: Design.rood,

        height: 50,
        color: Design.rood,
        animationCurve: Curves.easeInBack,
        index: _currentIndex, // this will be set when a new tab is tapped
        items: <Widget>[
          Icon(
            LineAwesomeIcons.home,
            color: Colors.white,
          ),
          Icon(
            LineAwesomeIcons.clipboard,
            color: Colors.white,
          ),
          Icon(
            LineAwesomeIcons.beer,
            color: Colors.white,
          ),
          Icon(
            LineAwesomeIcons.user,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
