import 'package:flutter/material.dart';
import 'package:huishoudappfrontend/createaccount_page.dart';

import 'login_page.dart';
import 'home_page.dart';
import 'createaccount_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
    CreateAccount.tag: (context) => CreateAccount(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project-C app',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: LoginPage(),
      routes: routes,
    );
  }
}
