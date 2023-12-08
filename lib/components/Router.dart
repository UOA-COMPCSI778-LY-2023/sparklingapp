import 'package:flutter/material.dart';

class MyRouter {
  /**
   * 创建一个新页面进入效果
   */
  static Route createRoute(page, String whereIn) {
    return PageRouteBuilder<SlideTransition>(
      barrierColor: Colors.white.withOpacity(0.5),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        double x = 0;
        double y = 0;
        var curv = Curves.fastLinearToSlowEaseIn;
        switch (whereIn) {
          case "top":
            {
              x = 0;
              y = -1;
            }
            break;
          case "right":
            {
              x = 1;
              y = 0;
            }
            break;
          case "bottom":
            {
              x = 0;
              y = 1;
              curv = Curves.linearToEaseOut;
            }
            break;
          case "left":
            {
              x = -1;
              y = 0;
            }
        }
        var tween = Tween<Offset>(
            begin: Offset(x, y),
            end: Offset.zero); //0，1 为从下往上进入，1，0为从右往左进入，0，-1为从上往下
        var curveTween = CurveTween(curve: curv); //fastLinearToSlowEaseIn

        return SlideTransition(
          position: animation.drive(curveTween).drive(tween),
          child: child,
        );
      },
    );
  }
}
