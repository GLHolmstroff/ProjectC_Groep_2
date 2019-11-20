import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Title_Widget extends StatelessWidget{
  String text;
  Title_Widget({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return Container(
        height: 200.0,
        decoration: BoxDecoration(
          color: Colors.blue,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 20.0, // has the effect of softening the shadow
              spreadRadius: 5.0, // has the effect of extending the shadow
              offset: Offset(
               0, // horizontal, move right 10
                4.0, // vertical, move down 10
              ),
            )
          ],
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    this.text,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.w300,
                        color: Colors.white),
                  ))
            ]));

  }

}