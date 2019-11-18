import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'Objects.dart';


class Turf_Widget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _Turf_Widget();
    
}


Future<Group> getGroup() async{
  String groupID = User.getCurrentUser.groupId.toString();
  Group currentGroup;
  final Response res = await get(
    'http;//10.0.2.2:8080/getAllInGroup?gid=$groupID',
    headers: {'Content-Type': 'application/json'});
    print(res.statusCode);
    if (res.statusCode == 200){
      // If server returns an OK response, parse the JSON.
      currentGroup = Group.fromJson(json.decode(res.body));
    }












class _Turf_Widget extends State<Turf_Widget>{
  @override
  Widget build(BuildContext context) {







    return Scaffold(

      body: 

      Padding(
        padding: const EdgeInsets.only(top: 30),
        child: ListTile(
          leading: Icon(Icons.person),
          title: Text('Username'),
          subtitle: Text('groupname'),
          trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.green,
                        ),
                      onPressed: (){
                        print('pressed button');
                      }
                      
                      ),
                      IconButton(
                      icon: Icon(
                        Icons.remove,
                        color: Colors.red,
                        
                        ),
                      onPressed: (){
                        print('pressed button');
                      },
                      
                      ),
                      Text('0')
                      ]

        )
    ),
      ));
}

}


