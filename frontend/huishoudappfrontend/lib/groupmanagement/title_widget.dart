import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../design.dart';

class Title_Widget extends StatelessWidget{
  String text;
  Title_Widget({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return Container(
        height: 200.0,
        decoration: BoxDecoration(
          color: Design.rood,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 10.0, // has the effect of softening the shadow
              spreadRadius: 1.0, // has the effect of extending the shadow
              offset: Offset(
               1.0, // horizontal, move right 10
                1.0, // vertical, move down 10
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
                        fontSize: 35.0,
                        fontWeight: FontWeight.w300,
                        color: Colors.white),
                  ))
            ]));

  }

}