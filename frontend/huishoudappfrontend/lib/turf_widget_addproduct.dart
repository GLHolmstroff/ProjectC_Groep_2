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
    final inputProductName = TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: 'Naam van het product',
          contentPadding: const EdgeInsets.all(15.0),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Design.rood),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
              borderSide: BorderSide(color: Design.rood))),
    );

    final inputProductPrice = TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: '€',
          contentPadding: const EdgeInsets.all(15.0),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Design.rood),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
              borderSide: BorderSide(color: Design.rood))),
    );

    final addProductButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        onPressed: () {
          print('product toegevoegd');
        },
        padding: EdgeInsets.all(12),
        color: Colors.orange[700],
        child: Text(
          'Product toevoegen',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Design.rood,
        title: Center(
          child: Text(
            "Producten toevoegen",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 50),
          inputProductName,
          SizedBox(height: 10,),
          inputProductPrice,
          SizedBox(height: 20),
          addProductButton
        ],
      ),
    );
  }
}
