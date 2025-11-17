import 'package:daa_project/Route__Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllRecentSearchViewer extends StatefulWidget {
  const AllRecentSearchViewer({super.key});

  @override
  State<AllRecentSearchViewer> createState() => _State();
}

class _State extends State<AllRecentSearchViewer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Route_Provider>(
      builder: (context, route_provider, child) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'All Recent Searches',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 2, 75, 201),
        ),
        body: route_provider.routes.isEmpty
            ? const Center(child: Text('Nothing Searched Yet'))
            : ListView.builder(
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
              ),
      ),
    );
  }
}
