import 'package:flutter/material.dart';
import 'package:sugarscanning/pages/NavigatePage.dart';

final routes = {
  '/': (context) => NavigatePage(),
  '/form': (context) => NavigatePage(),
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
