import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:huishoudappfrontend/groupmanagement/listitem_widget.dart';
import 'package:huishoudappfrontend/groupmanagement/title_widget.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'package:huishoudappfrontend/setup/validators.dart';

import '../Objects.dart';
import 'invitecode_widget.dart';

class Admin_widget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new Admin_widget_state();
  }
}

class Admin_widget_state extends State {
  final fromkey = GlobalKey<FormState>();
  String _name;
  String userhouseName = "laden...";
  Future<Group> currentGroup = Group.getGroup();

  CurrentUser currentUser = CurrentUser();
  void initState() {
    initActual();
  }

  Future<void> initActual() async {
    CurrentUser tempCurrentUser = await CurrentUser.updateCurrentUser();
    String temphouse = (await House.getCurrentHouse()).houseName;
    

    setState(() {
      currentUser = tempCurrentUser;
      userhouseName = temphouse;
    });
  }

  void _submitnewname() async {
    if (fromkey.currentState.validate()) {
      fromkey.currentState.save();
      Navigator.pop(context);
      print(_name);
      int groupid = currentUser.groupId;
      final Response res = await get(
          "http://seprojects.nl:8080/setGroupName?gid=$groupid&newName=$_name",
          headers: {'Content-Type': 'application/json'});
      if (json.decode(res.body)["Succes"] == 1) {
        setState(() {
          userhouseName = _name;
        });
      }
    }
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
          title: new Text(
            "Verander huisnaam",
            style: TextStyle(color: Colors.orange[700]),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: fromkey,
              child: new TextFormField(
                keyboardType: TextInputType.text,
                validator: NameValidator.validate,
                onSaved: (value) => _name = value,
                decoration: InputDecoration(
                  hintText: 'Je nieuwe naam',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(
                      color: Colors.orange[700],
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Opslaan",
                style: TextStyle(color: Colors.orange[700]),
              ),
              onPressed: _submitnewname,
            ),
          ],
        );
      },
    );
  }

  ListView _userlist(data) {
    List<Future<User>> users = [];
    List<String> uids = data.users;
    for (var i = 0; i < uids.length; i++) {
      users.add(User.getUser(uids[i]));
    }

    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return FutureBuilder(
            future: users[index],
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('Press button to start.');
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Text('Awaiting result...');
                case ConnectionState.done:
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  // return(Text(snapshot.data.group_permission));
                  return listitem(snapshot.data.displayName, snapshot.data.userId, snapshot.data.group_permission);
                // Text('Result: ${snapshot.data.users}');
              }
              return null; // unreachable
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Title_Widget(
          text: "Huisbeheer",
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            FlatButton(
              onPressed: _showDialog,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                
                Padding(
                  padding: const EdgeInsets.only(right:8.0),
                  child: Text(userhouseName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
                ),
                Icon(Icons.edit)
                ]
                ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: currentGroup,
                builder: (BuildContext context, AsyncSnapshot<Group> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Text('Press button to start.');
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                      return Text('Awaiting result...');
                    case ConnectionState.done:
                      if (snapshot.hasError)
                        return Text('Error: ${snapshot.error}');
                      return Container(
                          height: 300, child: _userlist(snapshot.data));
                    // Text('Result: ${snapshot.data.users}');
                  }
                  return null; // unreachable
                },
              ),
            ),
            Center(
              child: RaisedButton(
                color: Colors.orange[700],
        child: Text("Toevoegen", style:TextStyle(color: Colors.white)),
        onPressed: () {
          Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InviteCode_widget(),
                ));
        }),
            )
          ],
        )
      ],
    ));
  }
}
