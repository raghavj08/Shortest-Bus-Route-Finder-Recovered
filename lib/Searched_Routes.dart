import 'package:flutter/material.dart';

class SearchedRoutes extends StatelessWidget {
  final String source;
  final String destination;
  final Map<String, dynamic> searchResults;
  const SearchedRoutes(
      {required this.source, required this.destination,required this.searchResults, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
