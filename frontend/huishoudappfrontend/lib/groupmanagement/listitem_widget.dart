
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:huishoudappfrontend/Objects.dart';

class listitem extends StatefulWidget{
  final String uid;
  final String username;
  final String grouppermission;
  

  listitem(this.username, this.uid, this.grouppermission);

  @override
  State<StatefulWidget> createState() {
    return new listitem_state(username,uid,grouppermission);
  }

  
}

class listitem_state extends State{
  final String username;
  final String userid;
  String grouppermission;
  bool iscurrentuser;
  Text grouppermissiontext;
  bool visible = true;

  
  listitem_state(this.username, this.userid, this.grouppermission){
print(grouppermission);
    if (grouppermission != "user") {
      grouppermissiontext = Text("beheerder", style:TextStyle(color: Colors.green));
    } else {
      grouppermissiontext = Text("");
    }
    
  }
  
  bool _checkCurrentUser(){
    var currentUser = CurrentUser();
    if(currentUser.userId == userid){
      return true;
    }
    return false;
  }

  void _changePermission() async{
    bool admin = (grouppermission != "groupAdmin");
    final Response res= await get("http://seprojects.nl:8080/setGroupPermission?uid=$userid&admin=$admin");
    print(userid);
    if(json.decode(res.body)["result"] == "success"){
      print("success");
      var newText =  Text("");
      grouppermission = "user";
      if(admin){
        newText = Text("beheerder", style:TextStyle(color: Colors.green));
        grouppermission = "groupAdmin";
      }
      setState(() {
        grouppermissiontext = newText;
      });
    }
  }
  

  void _kickUser() async{
    final Response res = await get("http://seprojects.nl:8080/deleteUserFromGroup?uid=$userid");
    if(json.decode(res.body)["result"] == "success"){
      setState(() {
        visible = false;
      });
      Navigator.pop(context);
    }
  }

  void _kickUserDialog(){
    showDialog(
      context: (context),
      builder: (BuildContext context) { return(AlertDialog(
        title: Text("Huisgenoot verwijderen"),
        content: Container(
          height: 100,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom:8.0),
                child: Text("Weet u zeker dat u " + username + " wilt verwijderen?"),
              ),
              Text("Alle data van " + username + " zal hierdoor verloren gaan.")
            ],
          ),
        ),
      actions: <Widget>[
         new FlatButton(
              child: new Text(
                "Verwijderen",
                style: TextStyle(color: Colors.orange[700]),
              ),
              onPressed: _kickUser,

             
            ),
             new FlatButton(
              child: new Text(
                "Anuleren",
                style: TextStyle(color: Colors.orange[700]),
              ),
              onPressed:() => Navigator.pop(context),
            ),
      ],
      ));}
    );
  }

  Widget _simplePopup() {
    Text actionText = Text("Beheerder maken");
    
    if(grouppermission == "groupAdmin"){
      actionText = Text("Verwijderen als beheerder");
    }
    return PopupMenuButton<int>(
          enabled: !iscurrentuser,
          itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Text(username + " uit huis verwijderen"),
                  
                ),
                PopupMenuItem(
                  value: 2,
                  child: actionText,
                ),
              ],
              onSelected: (value){
                switch(value){
                  case 2:
                    _changePermission();
                    break;
                  case 1:
                    _kickUserDialog();
                    break;
                }
              },
        );
      
      }

  @override
  Widget build(BuildContext context) {
    iscurrentuser = _checkCurrentUser();
    return Visibility(
      visible: visible,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Text(
                username,
                style: TextStyle(fontSize: 17),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                  
                  grouppermissiontext,
          
                  _simplePopup()
                  // IconButton(
                  //   icon: Icon(Icons.more_vert),
                  // )
                ]),
              ), 
            )
          ],
        ),
      ),
    );
  }
}
