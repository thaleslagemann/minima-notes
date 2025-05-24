import 'package:flutter/material.dart';

class DrawerTile {
  DrawerTile(
    this.id, {
    this.title,
    this.icon,
    String? route,
  }) : _route = route ?? 'no-route';

  int id;
  IconData? icon;
  String? title;
  String? _route;

  void setRoute(String route) {
    _route = route;
  }

  String getRoute() {
    return _route ?? 'no-route';
  }
}
