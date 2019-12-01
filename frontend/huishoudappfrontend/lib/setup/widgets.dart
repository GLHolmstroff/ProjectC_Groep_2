import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

import '../design.dart';

class AnimatedLiquidCustomProgressIndicator extends StatefulWidget {
  Size size;
  
  AnimatedLiquidCustomProgressIndicator(Size size){
    this.size = size;
  }

  AnimatedLiquidCustomProgressIndicator.noContext();
  @override
  State<StatefulWidget> createState() =>
      AnimatedLiquidCustomProgressIndicatorState(size);
}

class AnimatedLiquidCustomProgressIndicatorState
    extends State<AnimatedLiquidCustomProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Size size;
  
AnimatedLiquidCustomProgressIndicatorState(Size size) {
 this.size = size;
}
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );

    _animationController.addListener(() => setState(() {}));
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentage = _animationController.value * 100;
    return Center(
      child: LiquidCustomProgressIndicator(
        value: _animationController.value,
        direction: Axis.vertical,
        backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation(Design.orange2),
        shapePath: _buildGlass(this.size),
        center: Text(
          "${percentage.toStringAsFixed(0)}%",
          style: TextStyle(
            color: Colors.yellowAccent,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Path _buildHeartPath() {
    return Path()
      ..moveTo(55, 15)
      ..cubicTo(55, 12, 50, 0, 30, 0)
      ..cubicTo(0, 0, 0, 37.5, 0, 37.5)
      ..cubicTo(0, 55, 20, 77, 55, 95)
      ..cubicTo(90, 77, 110, 55, 110, 37.5)
      ..cubicTo(110, 37.5, 110, 0, 80, 0)
      ..cubicTo(65, 0, 55, 12, 55, 15)
      ..close();
  }

  Path _buildGlass(Size size) {
    return Path()
    ..moveTo(0.2*size.width, size.height)
    ..lineTo(0, 0)
    ..lineTo(0.8*size.width, 0)
    ..lineTo(0.6*size.width, size.height)
    ..lineTo(0.2*size.width, size.height)
    ..close();
  }
}
