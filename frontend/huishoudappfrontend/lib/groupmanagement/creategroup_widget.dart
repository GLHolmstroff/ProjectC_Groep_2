import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:huishoudappfrontend/groupmanagement/title_widget.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'package:huishoudappfrontend/page_container.dart';
import '../Objects.dart';

class Creategroup_widget extends StatefulWidget {
  static String tag = "Creategroup_widget";
  _Creategroup_widget createState() => _Creategroup_widget();
}

class _Creategroup_widget extends State {
  final _groupnameController = TextEditingController();
  Future<void> _makeGroup() async {
    String groupname = _groupnameController.text;
    if (groupname.length > 4) {
      String uid = await Auth().currentUser();

      final response = await get(
          "http://10.0.2.2:8080/createGroup?name=$groupname&uid=$uid");
      if (response.statusCode == 200) {
        print("Succesfully Registered");
      } else {
        print("Connection Failed");
      }
      Navigator.popAndPushNamed(context, HomePage.tag);
    }
  }

  @override
  Widget build(BuildContext context) {

    

    
    final explanationText1 = Text(
      "Verzin een huisnaam",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20.0,
        // fontWeight: FontWeight.w400
      ),
    );

    

    final groupName = TextFormField(
      keyboardType: TextInputType.text,
      controller: _groupnameController,
      decoration: InputDecoration(
        hintText: 'Huisnaam',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final groepsledenText = Text(
      "Groepsleden",
      textAlign: TextAlign.center,
    );

    final makeGroupButton = RaisedButton(
      onPressed: _makeGroup,
      child: Text('Aanmaken', style: TextStyle(fontSize: 20)),
    );

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Title_Widget(text:"Huis aanmaken"),
          Expanded(
                      child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              
              
              Center(
                child:
                    Container(width: 250.0, height: 50.0, child: explanationText1),
              ),
              Center(child: Container(width: 250.0, height: 100.0,child: groupName)),
              Center(
              child:Container(
                
                child: makeGroupButton,
              ))
            ],
    ),
          ),
        ],
      ));
  }
}
