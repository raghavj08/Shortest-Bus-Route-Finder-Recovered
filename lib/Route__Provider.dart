import 'package:daa_project/model/Route_Model.dart';
import 'package:flutter/material.dart';

class Route_Provider extends ChangeNotifier {
  final List<RouteModel> _routes = [];

  List<RouteModel> get routes => _routes;

  void add_Route(String from, String to, DateTime date) {
    _routes.add(RouteModel(from: from, to: to, date: date));
    notifyListeners();
  }
}
