import 'dart:convert';

import 'package:daa_project/Home_Page.dart';
import 'package:daa_project/Profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AllRoutes extends StatefulWidget {
  const AllRoutes({super.key});

  @override
  State<AllRoutes> createState() => _AllRoutesState();
}

class _AllRoutesState extends State<AllRoutes> {
  int selected_index = 1;

  List<Map<String, dynamic>> avaliableRoutes = [];

  void _onItemTapped(int index) {
    setState(() {
      selected_index = index;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAvaliableRoutes();
  }

  Future<void> fetchAvaliableRoutes() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:5000/all-available-routes'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        avaliableRoutes =
            List<Map<String, dynamic>>.from(data['all_available_routes']);
      });
    } else {
      throw Exception('Failed to load available stops');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Routes'),
        backgroundColor: Color.fromARGB(255, 2, 75, 201),
      ),
      body: avaliableRoutes.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: avaliableRoutes.length,
              itemBuilder: (context, index) {
                final route = avaliableRoutes[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    title: Text('${index + 1} From: ${route['from']}',style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text(
                        '   To: ${route['to']} (Distance: ${route['distance_km']})'),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: selected_index,
          onTap: _onItemTapped,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
                icon: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ));
                    },
                    icon: Icon(Icons.home)),
                label: "Home"),
            BottomNavigationBarItem(
                icon: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllRoutes(),
                          ));
                    },
                    icon: Icon(Icons.route_outlined)),
                label: "All Routes"),
            BottomNavigationBarItem(
                icon: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Profile(),
                          ));
                    },
                    icon: Icon(Icons.person)),
                label: 'Profile')
          ]),
    );
  }
}
