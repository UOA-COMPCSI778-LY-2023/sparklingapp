import 'package:flutter/material.dart';

class MyRouter {
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
        var tween = Tween<Offset>(begin: Offset(x, y), end: Offset.zero);
        var curveTween = CurveTween(curve: curv); //fastLinearToSlowEaseIn

        return SlideTransition(
          position: animation.drive(curveTween).drive(tween),
          child: child,
        );
      },
    );
  }
}
