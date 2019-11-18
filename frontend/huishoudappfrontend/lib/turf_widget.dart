import 'package:flutter/material.dart';


class Turf_Widget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _Turf_Widget();
    
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


