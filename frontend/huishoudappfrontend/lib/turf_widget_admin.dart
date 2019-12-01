import 'package:flutter/material.dart';
import 'package:huishoudappfrontend/Objects.dart';
import 'package:huishoudappfrontend/setup/widgets.dart';

class TurfWidgetAdmin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TurfWidgetAdminState();
}

class TurfWidgetAdminState extends State<TurfWidgetAdmin> {
  List<BeerEvent> events = [];

   Future<String> getUserName(String uid) async {
      return (await User.getUser(uid)).displayName;

   } 

   FutureBuilder<List<BeerEvent>> createListTile(int gid) {
    return FutureBuilder<List<BeerEvent>>(
      future: BeerEvent.getData(gid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          snapshot.data.forEach((event) 
          async { event.authorid = await getUserName(event.authorid);
                  event.targetid = await getUserName(event.targetid);
                }
              );
          events = snapshot.data;  
         return ListView.builder(
           itemCount: events.length,
           itemBuilder: (context, index) {
             return ListTile(
              leading: Text(events[index].mutation.toString()),
              title: Text("By: " + events[index].authorid + '\nTo: '
              + events[index].targetid),
              trailing: Text(events[index].date),
              onTap: () {},
             );
           },
         ); 
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return AnimatedLiquidCustomProgressIndicator();
      }
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
                  height: MediaQuery.of(context).size.height / 2,
                  padding: const EdgeInsets.only(top: 20),
                  child: createListTile(CurrentUser().groupId),
                )
        );
  }
}
