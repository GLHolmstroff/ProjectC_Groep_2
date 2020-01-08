import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:huishoudappfrontend/Objects.dart';
import 'package:huishoudappfrontend/groupmanagement/title_widget.dart';

import '../page_container.dart';

class Joingroup_Widget extends StatefulWidget {
  static String tag = "Creategroup_widget";
  Joingroup_WidgetState createState() => Joingroup_WidgetState();
}

void showToast(text){
  Fluttertoast.showToast(
        msg: "Code moet uit zes cijfers bestaan",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
}

class Joingroup_WidgetState extends State {
  final _inviteCodeController = TextEditingController();

  Future<void> _joinGroup() async {
    var currentUser = CurrentUser();
    var code = int.tryParse(_inviteCodeController.text);
    if(code == null){
       showToast("Code mag alleen cijfers bevatten");
    }
    else if(code < 99999){
      showToast("Code moet uit 6 cijfers bestaan");
    }
    else{
    var uid = currentUser.userId;
    final response = await get(
        "http://seprojects.nl:8080/joinGroupByCode?uid=$uid&ic=$code");
    if (response.statusCode == 200) {
      print("Succesfully Registered");
      CurrentUser.updateCurrentUser();
      Navigator.popAndPushNamed(context, HomePage.tag);
      Navigator.pop(context);
    } else {
      print("Connection Failed");
      Fluttertoast.showToast(
        msg: "Ongeldige code",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
      print(response.body);
    }
    }
  }

  @override
  Widget build(BuildContext context) {
    final joinGroupButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: EdgeInsets.all(12),
        color: Colors.orange[700],
        onPressed: _joinGroup,
        child: Text(
          'Neem deel aan een groep',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    final explanationText1 = Text(
      "Voer jouw unieke code in om deel te nemen aan je huis",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20.0,
        // fontWeight: FontWeight.w400
      ),
    );

    final inviteCode = TextFormField(
      keyboardType: TextInputType.text,
      controller: _inviteCodeController,
      decoration: InputDecoration(
        hintText: 'Code',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange[700]),
          borderRadius: BorderRadius.circular(32.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );

    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
          Title_Widget(text: "Deelnemen aan een huis"),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: explanationText1,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left:8.0, right: 8.0),
                    child: inviteCode,
                  ),
                ),
                Center(child: joinGroupButton),
              ],
            ),
          ),
        ]));
  }
}
