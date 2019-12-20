import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:huishoudappfrontend/Objects.dart';
import 'package:huishoudappfrontend/setup/widgets.dart';
import 'package:huishoudappfrontend/turf_widget.dart';
import 'package:huishoudappfrontend/turf_widget_admin.dart';
import 'package:huishoudappfrontend/turf_widget_edit.dart';

import 'design.dart';

class TurfWidgetAddProduct extends StatefulWidget {
  static get tag => 'turfwidgetaddproduct';

  @override
  State<StatefulWidget> createState() => TurfWidgetAddProductState();
}

class TurfWidgetAddProductState extends State<TurfWidgetAddProduct> {
  final formKey = GlobalKey<FormState>();
  final listFormKey = GlobalKey<FormState>();
  List<ListItem<Product>> products = [];
  String _listProductName;
  String _listProductPrice;
  String _productName;
  String _productPrice;

  Future<void> sentProductData(String name, String price) async {
    int gid = CurrentUser().groupId;
    print(name);
    print(price);
    final Response res = await get(
        "http://10.0.2.2:8080/addProduct?gid=$gid&name=$name&price=$price");

    if (res.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      print('Product added');
      print('Naam van het product: ' + name);
      print('Prijs van het product: €' + price);
    } else {
      print(res.statusCode);
    }
  }

  @override
  void initState() {
    initActual();
    super.initState();
  }

  void initActual() async {
    List<Product> productstemp = await Product.getData(CurrentUser().groupId);
    List<ListItem<Product>> productItems = [];
    for (var product in productstemp) {
      productItems.add(ListItem(product));
    }
    setState(() {
      products = productItems;
    });
  }

  Future<String> getUserName(String uid) async {
    return (await User.getUser(uid)).displayName;
  }

  Container buildRegularItem(
      int index, TextFormField nameField, TextFormField priceField) {
    return Container(
        color: Colors.white,
        child: ListTile(
          leading: Text("Naam: ", textAlign: TextAlign.start),
          title: Text(products[index].data.name.toString(),
              textAlign: TextAlign.start),
          trailing: Text(products[index].data.price.toString(),
              textAlign: TextAlign.end),
          //Make item selected
          onTap: () {
            nameField.controller.clear();
            priceField.controller.clear();
            setState(() {
              for (var product in products) {
                product.isSelected = false;
              }
              products[index].isSelected = true;
            });
          },
        ));
  }

  GestureDetector buildSelectedItem(BuildContext context, int index,
      TextFormField nameField, TextFormField priceField) {
    return GestureDetector(
      child: Container(
        color: Design.orange2,
        child: SizedBox(
            height: MediaQuery.of(context).size.height * .2,
            child: Form(
                key: listFormKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Naam",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .05,
                        ),
                        Container(
                            alignment: Alignment.bottomCenter,
                            width: MediaQuery.of(context).size.width * .33,
                            child: nameField),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .08,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24)),
                            onPressed: () {
                              listFormKey.currentState.save();
                              sentProductData(_listProductName, _listProductPrice);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => new Turfwidget(),
                                  ));
                            },
                            padding: EdgeInsets.all(12),
                            color: Design.rood,
                            child: Text(
                              'Product wijzigen',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text("Prijs",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .05,
                        ),
                        Container(
                            alignment: Alignment.bottomCenter,
                            width: MediaQuery.of(context).size.width * .33,
                            child: priceField),
                      ],
                    )
                  ],
                ))),
      ),
    );
  }

  TextFormField makeListNameField(int index) {
    return TextFormField(
      textAlign: TextAlign.center,
      controller: TextEditingController(),
      keyboardType: TextInputType.text,
      onSaved: (value) {
        setState(() {
          _listProductName = value;
        });
      },
      decoration: InputDecoration(
          hintText: '${products[index].data.name.toString()}',
          hintStyle: TextStyle(fontWeight: FontWeight.bold),
          contentPadding: const EdgeInsets.all(5.0),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Design.rood),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Design.rood))),
    );
  }

  TextFormField makeListPriceField(int index) {
    return TextFormField(
      textAlign: TextAlign.center,
      controller: TextEditingController(),
      keyboardType: TextInputType.text,
      onSaved: (value) {
        setState(() {
          _listProductPrice = value;
        });
      },
      decoration: InputDecoration(
          hintText: '${products[index].data.price.toString()}',
          hintStyle: TextStyle(fontWeight: FontWeight.bold),
          contentPadding: const EdgeInsets.all(5.0),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Design.rood),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Design.rood))),
    );
  }

  ListView createListTile(int gid) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        TextFormField listName = makeListNameField(index);
        TextFormField listPrice = makeListPriceField(index);
        //Build list items
        return products[index].isSelected
            ? buildSelectedItem(context, index, listName, listPrice)
            : buildRegularItem(index, listName, listPrice);
      },
    );
  }

  Widget build(BuildContext context) {
    final inputProductName = TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (value) {
        setState(() {
          _productName = value;
        });
      },
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
      onSaved: (value) {
        setState(() {
          _productPrice = value;
        });
      },
      decoration: InputDecoration(
          hintText: '€ (Prijs per eenheid)',
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
          formKey.currentState.save();
          sentProductData(_productName, _productPrice);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => new Turfwidget(),
              ));
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
          child: Column(children: <Widget>[
            SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: createListTile(CurrentUser().groupId)),
            Form(
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
          ]),
        ));
  }
}
