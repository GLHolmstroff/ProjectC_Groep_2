import 'dart:async';
import 'dart:convert';
import 'dart:core' as prefix0;
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'package:huishoudappfrontend/setup/widgets.dart';
import 'Objects.dart';


class Turfwidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _Turfwidget();
    
}



class _Turfwidget extends State<Turfwidget>{
  
  void _printusers() async {
    Group group = await Group.getGroup();
    print(group.toString());
  }




  Widget build(BuildContext context) {

    FutureBuilder<House> houseDisplayname = FutureBuilder<House>(
      future: House.getCurrentHouse(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
            snapshot.data.houseName,
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return AnimatedLiquidCustomProgressIndicator();
      },
    );














    return Scaffold(

      body: 

      Padding(
        padding: const EdgeInsets.only(top: 30),
        child: ListTile(
          leading: Icon(Icons.person),
          title: Text(CurrentUser().displayName),
          subtitle: houseDisplayname,
          trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.green,
                        ),
                      onPressed: (){
                        _printusers();
                      }
                      
                      ),
                      IconButton(
                      icon: Icon(
                        Icons.remove,
                        color: Colors.red,
                        
                        ),
                      onPressed: (){
                        print('You pressed - button');
                      },
                      
                      ),
                      Text('0')
                      ]

        )
    ),
      ));
}

}


