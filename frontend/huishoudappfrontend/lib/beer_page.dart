import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:huishoudappfrontend/createaccount_page.dart';
import 'package:huishoudappfrontend/main.dart';
import 'package:huishoudappfrontend/setup/provider.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'package:huishoudappfrontend/setup/validators.dart';
import 'package:http/http.dart';
import 'Objects.dart';

class BeerPage extends StatefulWidget {
  // Declare a field that holds the Todo.
  final User currentUser;

  // In the constructor, require a Todo.
  BeerPage({Key key, @required this.currentUser}) : super(key: key);
  

  @override
  State<StatefulWidget> createState() {
    return new BeerPageState();
  }

}

class BeerPageState extends State<BeerPage> {
  String _beerinfo;

    void _changeBeerInfo(String newinfo) {
      setState(() {
      _beerinfo =  newinfo;
      });
    }

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text("Beer Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_beerinfo',
            ),
            (FlatButton(
              child: Text('Get Beer info'),
              onPressed: () async {
                try {
                  Auth auth = Provider.of(context).auth;
                  User currentUser = widget.currentUser;
                  int gid = currentUser.groupId;
                  final Response res2 = await get("http://10.0.2.2:8080/getTallyByName?gid=$gid",
                  headers: {'Content-Type': 'application/json' });
                  print(res2.statusCode);
                  if (res2.statusCode == 200){
                    BeerTally beer = BeerTally.fromJson(json.decode(res2.body));
                    _changeBeerInfo(beer.toString());
                  }
                  
                } catch (e) {
                  print(e);
                }
                },
            )
            ),
            (FlatButton(
              child: Text("Drink a beer"),
              onPressed: () async {
                Auth auth = Provider.of(context).auth;
                User currentUser = widget.currentUser;
                String uid = currentUser.userId;
                int gid = currentUser.groupId;
                final Response res2 = await get("http://10.0.2.2:8080/getTally?gid=$gid",
                headers: {'Content-Type': 'application/json' });
                print(res2.statusCode);
                if (res2.statusCode == 200){
                  BeerTally beer = BeerTally.fromJson(json.decode(res2.body));
                  int count = beer.count[uid] + 1;
                  final Response res = await get("http://10.0.2.2:8080/updateTally?gid=$gid&uid=$uid&count=$count",
                  headers: {'Content-Type': 'application/json' });
                  print(res.statusCode);
                  if (res.statusCode == 200) {
                    BeerTally beer = BeerTally.fromJson(json.decode(res.body));
                    _changeBeerInfo(beer.toString());
                  }
                }
              })
            ),
            ],
          ),
        ),
    );
  }
}
