import 'package:flutter/material.dart';
import 'package:huishoudappfrontend/Objects.dart';
import 'package:huishoudappfrontend/setup/widgets.dart';
import 'package:huishoudappfrontend/turf_widget_edit.dart';

import 'design.dart';

class TurfWidgetAddProduct extends StatefulWidget {
  static get tag => 'turfwidgetaddproduct';

  @override
  State<StatefulWidget> createState() => TurfWidgetAddProductState();
}


class TurfWidgetAddProductState extends State<TurfWidgetAddProduct> {
  

  

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Design.rood,
          title: Center(
            child: Text(
              "Producten toevoegen",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),);
        
        
      
  }
}
