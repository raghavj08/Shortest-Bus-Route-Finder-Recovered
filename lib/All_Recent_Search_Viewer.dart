import 'package:daa_project/Route__Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllRecentSearchViewer extends StatefulWidget {
  const AllRecentSearchViewer({super.key});

  @override
  State<AllRecentSearchViewer> createState() => _AllRecentSearchViewerState();
}

class _AllRecentSearchViewerState extends State<AllRecentSearchViewer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Route_Provider>(
      builder: (context, route_provider, child) => Scaffold(
        appBar: AppBar(
          title: Text('All Recent Searches'),
          backgroundColor: Color.fromARGB(255, 2, 75, 201),
        ),
        body: Expanded(child: Builder(builder: (context) {
          if (route_provider.routes.isEmpty) {
            return Center(
              child: Text('Nothing Searches Yet'),
            );
          }
          return ListView.builder(
            itemCount: route_provider.routes.length,
            itemBuilder: (context, index) {
              final route = route_provider.routes[index];
              return ListTile(
                leading: const Icon(Icons.route),
                title: Text('${route.from} --->  ${route.to}'),
                subtitle: Text(
                    'Date: ${route.date.toLocal().toString().split(' ')[0]}'),
              );
            },
          );
        })),
      ),
    );
  }
}
