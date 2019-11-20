import 'package:flutter/material.dart';
import 'package:huishoudappfrontend/loading_indicator.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class Loading_Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      body: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Center(
            
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(width: 80, height:80,child: CircularProgressIndicator()),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("Uw gegevens worden geladen..."),
                  )
                ],
              )
                ,
            ),
         
      ))
      );
  }
}
