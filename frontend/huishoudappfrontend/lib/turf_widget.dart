import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'Objects.dart';


class Turfwidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _Turfwidget();
    
}


class _Turfwidget extends State<Turfwidget>{
  
  Future<User> getUser() async {
    String uid = await Auth().currentUser();
    User currentUser;
      final Response res = await get("http://10.0.2.2:8080/authCurrent?uid=$uid",
          headers: {'Content-Type': 'application/json'});
      if (res.statusCode == 200) {
        // If server returns an OK response, parse the JSON.
        currentUser = User.fromJson(json.decode(res.body));
    } else {
        print("Could not find user");
    }
    return currentUser;
  }


Future<Group> getGroup() async{
  String groupID = (await getUser()).groupId.toString();
  Group currentGroup;
  final Response res = await get(
    'http;//10.0.2.2:8080/getAllInGroup?gid=$groupID',
    headers: {'Content-Type': 'application/json'});
    if (res.statusCode == 200){
      // If server returns an OK response, parse the JSON.
      currentGroup = Group.fromJson(json.decode(res.body));
    } else {
      print('Could not find group');
    }
    return currentGroup;  
}




  Widget build(BuildContext context) {
    return Scaffold(

      body: 

      Padding(
        padding: const EdgeInsets.only(top: 30),
        child: ListTile(
          leading: Icon(Icons.person),
          title: Text('Username'),
          subtitle: Text('groupname'),
          trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.green,
                        ),
                      onPressed: (){
                        print('pressed button');
                      }
                      
                      ),
                      IconButton(
                      icon: Icon(
                        Icons.remove,
                        color: Colors.red,
                        
                        ),
                      onPressed: (){
                        print('pressed button');
                      },
                      
                      ),
                      Text('0')
                      ]

        )
    ),
      ));
}

}


