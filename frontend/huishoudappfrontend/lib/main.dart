import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:huishoudappfrontend/Objects.dart';
import 'package:huishoudappfrontend/createaccount_widget.dart';
import 'package:huishoudappfrontend/creategroup_widget.dart';
import 'groupsetup_widget.dart';
import 'login_widget.dart';
import 'page_container.dart';
import 'createaccount_widget.dart';
import 'package:huishoudappfrontend/setup/provider.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'package:huishoudappfrontend/setup/validators.dart';
import 'profile.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
    CreateAccount.tag: (context) => CreateAccount(),
    Profilepage.tag: (context) => Profilepage(),
  };
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: Auth(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: MyHomePage(),
        routes: routes,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  Future<bool> _checkGroup() async {
    String uid = await Auth().currentUser();
    final Response res = await get("http://10.0.2.2:8080/authCurrent?uid=$uid");
    User user = User.fromJson(json.decode(res.body));
    print("user loaded" + user.toString());
    if (user.groupId == null) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of(context).auth;
    return StreamBuilder<String>(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool loggedIn = snapshot.hasData;
          if (loggedIn == true) {
            print("Waiting");
           
             FutureBuilder<bool>(
              future: _checkGroup(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if(snapshot.data ){
                    return(HomePage());
                  }
                  else{
                    return(GroupWidget());
                  }
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                // By default, show a loading spinner.
                
                return CircularProgressIndicator();
              });
          }
         else {
          print('to the loginpage');
          return LoginPage();
        }

        return CircularProgressIndicator();
      }
      });
  }
}
