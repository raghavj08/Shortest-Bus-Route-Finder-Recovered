import 'dart:convert';
import 'package:daa_project/model/Route_Model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Route_Provider extends ChangeNotifier {
  List<RouteModel> _routes = [];

  List<RouteModel> get routes => _routes;

  Route_Provider() {
    loadRoutes();
  }

  void add_Route(String from, String to, DateTime date) async {
    _routes.add(RouteModel(from: from, to: to, date: date));
    notifyListeners();
    await saveRoutes();
  }

  Future<void> saveRoutes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> routeList = _routes
        .map((route) => jsonEncode({
              'from': route.from,
              'to': route.to,
              'date': route.date.toIso8601String(),
            }))
        .toList();
    await prefs.setStringList('routes', routeList);
  }

  Future<void> loadRoutes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? routeList = prefs.getStringList('routes');
    if (routeList != null) {
      _routes = routeList.map((routeString) {
        Map<String, dynamic> map = jsonDecode(routeString);
        return RouteModel(
          from: map['from'],
          to: map['to'],
          date: DateTime.parse(map['date']),
        );
      }).toList();
      notifyListeners();
    }
  }
}
