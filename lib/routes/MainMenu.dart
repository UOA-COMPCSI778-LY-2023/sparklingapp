import 'package:flutter/material.dart';
import 'package:sugatiol/pages/StartPage.dart';
import '../pages/NavigatePage.dart';

final routes = {
  '/': (context) => NavigatePage(),
  '/form': (context) => NavigatePage(),
  '/start': (context) => StartPage()
};

var onGenerateRoute = (RouteSettings settings) {
  final String? name = settings.name;
  final Function pageContentBuilder = routes[name] as Function;
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
          MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};
