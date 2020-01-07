import 'package:http/http.dart';
import 'package:huishoudappfrontend/page_container.dart';
import 'package:huishoudappfrontend/turf_widget.dart';
import 'package:huishoudappfrontend/turf_widget_admin.dart';

import 'Objects.dart';
import 'package:flutter/material.dart';

import 'design.dart';

class TurfWidgetEdit extends StatefulWidget {
  TurfWidgetEdit();

  static get tag => 'TurfWidgetEdit';

  @override
  State<StatefulWidget> createState() => TurfWidgetEditState();
}

class TurfWidgetEditState extends State<TurfWidgetEdit> {
  final _formKey = GlobalKey<FormState>();
  String houseName = "Loading...";
  BeerEvent event;
  BeerEvent eventNew;

  void initState() {
    super.initState();
    setHouseName();
  }

  Future<void> setHouseName() async {
    var temp = (await House.getCurrentHouse()).houseName;
    setState(() {
      houseName = temp;
    });
  }

  void updateEntry() async {
    final Response res = await get(
        "http://seprojects.nl:8080/updateTallyEntry?gid=${eventNew.gid}&authorid=${eventNew.authorid}&targetid=${eventNew.targetid}&mutation=${eventNew.mutation}&date=${eventNew.date}");
    if (res.statusCode == 200) {
      print("updated");
    } else {
      print(res.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    //Initialization via named route arguments must happen in build.
    //Only initialize if event is still null. Otherwise event would be overwritten
    if (event == null){
      setState(() {
        this.event = ModalRoute.of(context).settings.arguments;
        this.eventNew = event.copyByVal();
      });
      
    }
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Design.rood,
          title: Center(
            child: Text(
              "Wijzig beer event",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(padding: const EdgeInsets.only(bottom: 20)),
            Text("Huis: $houseName"),
            Text("Aangemaakt door: ${event.authorname}"),
            Text("Aangemaakt voor: ${event.targetname}"),
            Text("Aangemaakt op: ${event.date}"),
            Padding(padding: const EdgeInsets.only(bottom: 40)),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Oud verschil",
                  textAlign: TextAlign.center,
                ),
                Padding(padding: const EdgeInsets.only(top: 20)),
                Text(
                  event.mutation.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(padding: const EdgeInsets.only(top: 20)),
                Text(
                  "Maak nieuw verschil",
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          print("+ " + this.eventNew.mutation.toString());
                          setState(() {
                            this.eventNew.mutation += 1;
                          });
                        }),
                    Text(eventNew.mutation.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(
                        Icons.remove,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        print("-" + this.eventNew.mutation.toString());
                        setState(() {
                          if (this.eventNew.mutation >= 0) {
                            this.eventNew.mutation -= 1;
                          }
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Text("Verwijderen"),
                      onPressed: () {
                        setState(() {
                          eventNew.mutation = 0;
                        });
                        updateEntry();
                        Navigator.of(context)
                            .popUntil(ModalRoute.withName(TurfWidgetAdmin.tag));
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text("Verandering opslaan"),
                      onPressed: () {
                        updateEntry();
                        Navigator.of(context)
                            .popUntil(ModalRoute.withName(TurfWidgetAdmin.tag));
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
