import 'package:flutter/material.dart';
import 'package:huishoudappfrontend/Objects.dart';
import 'package:huishoudappfrontend/setup/widgets.dart';
import 'package:huishoudappfrontend/turf_widget_edit.dart';

class TurfWidgetAdmin extends StatefulWidget {
  static get tag => 'turfwidgetadmin';

  @override
  State<StatefulWidget> createState() => TurfWidgetAdminState();
}

class ListItem<T> {
  bool isSelected = false;

  T data;

  ListItem(this.data);
}

class TurfWidgetAdminState extends State<TurfWidgetAdmin> {
  List<ListItem<BeerEvent>> events = [];

  @override
  void initState() {
    initActual();
    super.initState();
  }

  void initActual() async {
    List<BeerEvent> eventstemp = await BeerEvent.getData(CurrentUser().groupId);
    List<ListItem<BeerEvent>> eventItems = [];
    for (var event in eventstemp) {
      eventItems.add(ListItem<BeerEvent>(event));
    }

    setState(() {
      events = eventItems;
    });
  }

  Future<String> getUserName(String uid) async {
    return (await User.getUser(uid)).displayName;
  }

  ListView createListTile(int gid) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Row(children: <Widget>[
            new Expanded(
                child: new Text("Aantal:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center)),
            new Expanded(
                child: new Text("Door:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center)),
            new Expanded(
                child: new Text("Datum:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center)),
          ]);
        }
        index -= 1;

        //Build list items
        return Container(
            color: events[index].isSelected ? Colors.blue[100] : Colors.white,
            child: ListTile(
              leading: Text(events[index].data.mutation.toString(),
                  textAlign: TextAlign.center),
              title: Text(
                  "Door: " +
                      events[index].data.authorname +
                      '\nVoor: ' +
                      events[index].data.targetname,
                  textAlign: TextAlign.center),
              trailing: Text(events[index].data.date.substring(0, 10),
                  textAlign: TextAlign.center),
              //Make item selected
              onTap: () {
                setState(() {
                  if (events[index].isSelected) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              new TurfWidgetEdit(events[index].data),
                        ));
                  } else {
                    for (var event in events) {
                      event.isSelected = false;
                    }
                    events[index].isSelected = true;
                  }
                });
              },
              onLongPress: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          new TurfWidgetEdit(events[index].data),
                    ));
              },
            ));
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Edit Beer events",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.only(top: 0),
          child: createListTile(CurrentUser().groupId),
        ));
  }
}
