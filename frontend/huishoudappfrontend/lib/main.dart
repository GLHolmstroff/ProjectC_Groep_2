import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:huishoudappfrontend/Objects.dart';
import 'package:huishoudappfrontend/createaccount_widget.dart';
import 'package:huishoudappfrontend/design.dart';
import 'package:huishoudappfrontend/groupmanagement/groupsetup_widget.dart';
import 'package:huishoudappfrontend/groupmanagement/creategroup_widget.dart';
import 'package:huishoudappfrontend/groupmanagement/namesetup_widget.dart';
import 'package:huishoudappfrontend/schedules/admintaskadder_widget.dart';
import 'package:huishoudappfrontend/home_widget.dart';
import 'package:huishoudappfrontend/schedules/clickedOnCheckHousemate.dart';
import 'package:huishoudappfrontend/setup/widgets.dart';
import 'package:huishoudappfrontend/services/permission_serivce.dart';
import 'package:huishoudappfrontend/turf_widget.dart';
import 'package:huishoudappfrontend/turf_widget_addproduct.dart';
import 'package:huishoudappfrontend/turf_widget_admin.dart';
import 'package:huishoudappfrontend/turf_widget_edit.dart';
import 'package:huishoudappfrontend/turf_widget_gridview.dart';
import 'login_widget.dart';
import 'page_container.dart';
import 'createaccount_widget.dart';
import 'package:huishoudappfrontend/setup/provider.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'package:huishoudappfrontend/setup/validators.dart';
import 'profile.dart';
import 'schedules/schoonmaakrooster_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
    Home_widget.tag: (context) => Home_widget(),
    CreateAccount.tag: (context) => CreateAccount(),
    Profilepage.tag: (context) => Profilepage(),
    GroupWidget.tag: (context) => GroupWidget(),
    // Turfwidget.tag: (context) => Turfwidget(),
    TurfWidgetAdmin.tag: (context) => TurfWidgetAdmin(),
    TurfWidgetAddProduct.tag: (context) => TurfWidgetAddProduct(),
    TurfWidgetEdit.tag: (context) => TurfWidgetEdit(),
    TurfWidgetAddProduct.tag: (context) => TurfWidgetAddProduct(),
    TurfwidgetGrid.tag: (context) => TurfwidgetGrid(),
    SchoonmaakPage.tag: (context) => SchoonmaakPage(),
    AdminTaskAdder.tag: (context) => AdminTaskAdder(),
    NameSetup.tag: (context) => NameSetup(),
  };

  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: Auth(),
      perm: PermissionsService(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Design.materialRood),
        home: MyHomePage(),
        routes: routes,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  Future<bool> _checkGroup() async {
    String uid = await Auth().currentUser();
    final Response res = await get("http://seprojects.nl:8080/authCurrent?uid=$uid");
    User user = User.fromJson(json.decode(res.body));
    print("user loaded" + user.toString());
    if (user.groupId == null) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context){

    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
 
    final Auth auth = Provider.of(context).auth;
    return StreamBuilder<String>(
        stream: auth.onAuthStateChanged,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.waiting) {
            if (snapshot.hasData) {
              print("Waiting");
              return FutureBuilder<CurrentUser>(
                  future: CurrentUser.updateCurrentUser(),
                  builder: (context, innersnapshot) {
                    if (innersnapshot.hasData) {
                          if (CurrentUser().displayName == "EmptyName") {
                            return (NameSetup());
                          } else if (CurrentUser().groupId == null) {
                            return (GroupWidget());
                          } else {
                            return (HomePage());
                          }
                    } else if (innersnapshot.hasError) {
                      return Text("${innersnapshot.error}");
                    }
                    // By default, show a loading spinner.
                    return Image(image: AssetImage('assets/brc.gif'),);
                  });
            } else {
              print('to the loginpage');
              return LoginPage();
            }
          }
        });
  }
}
