import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Design {
    static Color geel = const Color.fromRGBO(242, 203, 5, 1);
    static Color orange1 = const Color.fromRGBO(242, 259, 5, 1);
    static Color orange2 = const Color.fromRGBO(242, 135, 5, 1);
    static Color rood = const Color.fromRGBO(191, 15, 15, 1);
    static Color zwart = const Color.fromRGBO(13, 13, 13, 1);

    static int navBarHeight = 50;

    static Map<int, Color> roodMap = {
      50:Color.fromRGBO(191,15,15, .1),
      100:Color.fromRGBO(191,15,15, .2),
      200:Color.fromRGBO(191,15,15, .3),
      300:Color.fromRGBO(191,15,15, .4),
      400:Color.fromRGBO(191,15,15, .5),
      500:Color.fromRGBO(191,15,15, .6),
      600:Color.fromRGBO(191,15,15, .7),
      700:Color.fromRGBO(191,15,15, .8),
      800:Color.fromRGBO(191,15,15, .9),
      900:Color.fromRGBO(191,15,15, 1),
    };
    static MaterialColor materialRood = new MaterialColor(0xFFBF0F0F, roodMap);
}