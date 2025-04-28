import 'package:daa_project/Home_Page.dart';
import 'package:daa_project/Save.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  int selected_index = 1;

   void _onItemTapped(int index) {
    setState(() {
      selected_index = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Bye'),
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
                              builder: (context) => Search(),
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
                              builder: (context) => Save(),
                            ));
                      },
                      icon: Icon(Icons.person)),
                  label: 'Profile')
            ]),
    );
  }
}