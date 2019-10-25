import 'package:flutter/material.dart';

class PlaceholderWidget extends StatelessWidget{
  final Color color;

  PlaceholderWidget(this.color);

  Widget build(BuildContext context){
    return Container(
      color: color,
    );
  }
}