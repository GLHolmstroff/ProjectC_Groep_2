import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:huishoudappfrontend/Objects.dart';
import 'package:huishoudappfrontend/createaccount_widget.dart';
import 'package:huishoudappfrontend/groupmanagement/groupsetup_widget.dart';
import 'package:huishoudappfrontend/groupmanagement/creategroup_widget.dart';
import 'package:huishoudappfrontend/setup/widgets.dart';
import 'package:huishoudappfrontend/services/permission_serivce.dart';
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
    GroupWidget.tag: (context) => GroupWidget(),
  };

  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: Auth(),
      perm: PermissionsService(),
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
    CurrentUser currentUser = await CurrentUser.updateCurrentUser();

    print("user loaded" + currentUser.toString());
    if (currentUser.groupId == null) {
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
          if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.waiting) {
            if (snapshot.hasData) {
              print("Waiting");
              return FutureBuilder<CurrentUser>(
                  future: CurrentUser.updateCurrentUser(),
                  builder: (context, innersnapshot) {
                    if (innersnapshot.hasData) {
                      if (innersnapshot.data.groupId != null) {
                        return (HomePage());
                      } else {
                        return (GroupWidget());
                      }
                    } else if (innersnapshot.hasError) {
                      return Text("${innersnapshot.error}");
                    }
                    // By default, show a loading spinner.
                    return AnimatedLiquidCustomProgressIndicator();
                  });
            } else {
              print('to the loginpage');
              return LoginPage();
            }
          }
        });
  }
}
