import 'package:daa_project/Home_Page.dart';
import 'package:daa_project/Profile.dart';
import 'package:daa_project/graphql_service.dart';
import 'package:flutter/material.dart';

class AllRoutes extends StatefulWidget {
  const AllRoutes({super.key});

  @override
  State<AllRoutes> createState() => _AllRoutesState();
}

class _AllRoutesState extends State<AllRoutes> {
  int selected_index = 1;
  List<Map<String, dynamic>> availableRoutes = [];
  bool loading = true;

  void _onItemTapped(int index) {
    setState(() {
      selected_index = index;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAvailableRoutes();
  }

  Future<void> fetchAvailableRoutes() async {
    try {
      final items = await GraphQLService.listBusRoutes(limit: 1000);
      setState(() {
        availableRoutes = items.map((r) {
          return {
            'from': r['from'],
            'to': r['to'],
            'distance_km': r['distance'],
            'bus': r['roadway'],
          };
        }).toList();
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('All Routes',style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),),
        backgroundColor: Color.fromARGB(255, 2, 75, 201),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: availableRoutes.length,
              itemBuilder: (context, index) {
                final route = availableRoutes[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    title: Text('${index + 1}. From: ${route['from']}',style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text(
                        '   To: ${route['to']} (Distance: ${route['distance_km']} km)'),
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
