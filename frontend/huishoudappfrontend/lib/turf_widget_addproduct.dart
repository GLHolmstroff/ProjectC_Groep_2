import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:huishoudappfrontend/Objects.dart';
import 'package:huishoudappfrontend/setup/widgets.dart';
import 'package:huishoudappfrontend/turf_widget.dart';
import 'package:huishoudappfrontend/turf_widget_edit.dart';

import 'design.dart';

class TurfWidgetAddProduct extends StatefulWidget {
  static get tag => 'turfwidgetaddproduct';

  @override
  State<StatefulWidget> createState() => TurfWidgetAddProductState();
}

class TurfWidgetAddProductState extends State<TurfWidgetAddProduct> {
  final formKey = GlobalKey<FormState>();
  String _productName;
  String _productPrice;

  Future<void> sentProductData() async {
    int gid = CurrentUser().groupId;
    String name = _productName;
    String price = _productPrice;
    print(name);
    print(price);
    formKey.currentState.save();

    final Response res = await get(
        "http://10.0.2.2:8080/addProduct?gid=$gid&name=$name&price=$price");

    if (res.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      print('Product added');
      print(name);
      print(price);
    } else {
      print(res.statusCode);
    }
  }

  Widget build(BuildContext context) {
    final inputProductName = TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (value) => _productName = value,
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
      keyboardType: TextInputType.number,
      onSaved: (value) => _productPrice = value,
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
          sentProductData();
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => Turfwidget()));
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
        body: Center(
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                inputProductName,
                SizedBox(
                  height: 10,
                ),
                inputProductPrice,
                SizedBox(
                  height: 20,
                ),
                addProductButton
              ],
            ),
          ),
        ));
  }
}
