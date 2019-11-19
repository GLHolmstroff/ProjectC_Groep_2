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
            child: Container(
              width: 100,
              height: 100,
              child: Loading_Indicator(),
            ),
          )),
    ));
  }
}
