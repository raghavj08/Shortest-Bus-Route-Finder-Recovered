import 'dart:convert';
import 'package:daa_project/All_Recent_Search_Viewer.dart';
import 'package:daa_project/Auth/Log_In.dart';
import 'package:daa_project/Route__Provider.dart';
import 'package:daa_project/Profile.dart';
import 'package:daa_project/All_Routes.dart';
import 'package:daa_project/Searched_Routes.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selected_index = 0;

  void _onItemTapped(int index) {
    setState(() {
      selected_index = index;
    });
  }

  TextEditingController from_Controller = TextEditingController();
  TextEditingController to_Controller = TextEditingController();
  TextEditingController date_Controller = TextEditingController();
  DateTime? selectedDate;

  void logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LogIn()));
  }

  Future<void> _searchRoutes(BuildContext context) async {
    if (from_Controller.text.isEmpty || to_Controller.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Fill both text fields')));
      return;
    }

    final String source = from_Controller.text.trim();
    final String destination = to_Controller.text.trim();

    final Uri uri = Uri.parse(
        'http://10.0.2.2:5000/shortest-path?source=$source&destination=$destination');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (!mounted) return;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SearchedRoutes(
                    source: source,
                    destination: destination,
                    searchResults: data)));
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.reasonPhrase}')));
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Failed to connect to the server: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Route_Provider>(
      builder: (context, route_provider, child) => Scaffold(
        body: SingleChildScrollView(
          child: Stack(children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 2, 75, 201),
                  borderRadius: BorderRadius.all(Radius.circular(35))),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 60, 0, 0),
                    child: Icon(
                      Icons.menu,
                      color: Colors.white,
                    )),
                Padding(
                    padding: EdgeInsets.fromLTRB(20, 60, 0, 0),
                    child: Text(
                      'Where would you like to go',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.white),
                    )),
                SizedBox(
                  width: 80,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(50, 47, 0, 0),
                  child: IconButton(
                      onPressed: logout,
                      icon: Icon(
                        Icons.logout,
                        color: Colors.white,
                      )),
                )
              ]),
            ),
            Center(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 110, 0, 0),
                  child: Container(
                    height: 310,
                    width: 390,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          )
                        ]),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Icon(Icons.location_on,
                                  color: const Color.fromARGB(255, 69, 68, 68)),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                      hintText: 'From',
                                      hintStyle: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 69, 68, 68),
                                          fontWeight: FontWeight.w700)),
                                  controller: from_Controller,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Row(
                            children: [
                              Icon(Icons.flag,
                                  color: const Color.fromARGB(255, 69, 68, 68)),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                      hintText: 'To',
                                      hintStyle: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 69, 68, 68),
                                          fontWeight: FontWeight.w700)),
                                  controller: to_Controller,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            'Select Date',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          DatePicker(
                            DateTime.now(),
                            width: 50,
                            height: 88,
                            initialSelectedDate: DateTime.now(),
                            selectionColor: Color.fromARGB(255, 2, 75, 201),
                            selectedTextColor: Colors.white,
                            onDateChange: (date) {
                              setState(() {
                                selectedDate = date;
                                date_Controller.text = date.toString();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 420,
                ),
                Padding(
                  padding: EdgeInsets.all(25),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              Color.fromARGB(255, 2, 75, 201)),
                          elevation: WidgetStatePropertyAll(10)),
                      onPressed: () {
                        if (from_Controller.text.isNotEmpty &&
                            to_Controller.text.isNotEmpty &&
                            selectedDate != null) {
                          Provider.of<Route_Provider>(context, listen: false)
                              .add_Route(from_Controller.text.trim(),
                                  to_Controller.text.trim(), selectedDate!);
                          _searchRoutes(context);
                          from_Controller.clear();
                          to_Controller.clear();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Please fill all the fields')));
                        }
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 107,
                          ),
                          Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Search Routes',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ],
                      )),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
                  child: Container(
                    height: 300,
                    width: double.infinity,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                child: Text(
                                  'Recent Search',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16),
                                )),
                            Padding(
                              padding: EdgeInsets.only(left: 220),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          AllRecentSearchViewer()));
                                },
                                child: Text(
                                  'see all',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 2, 75, 201),
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            )
                          ],
                        ),
                        Expanded(
                          child: Builder(builder: (context) {
                            final recent_Routes =
                                route_provider.routes.reversed.take(3).toList();

                            if (recent_Routes.isEmpty) {
                              return Center(
                                child: Text('No Recent Searches'),
                              );
                            }

                            return ListView.builder(
                              itemCount: recent_Routes.length,
                              itemBuilder: (context, index) {
                                final route = recent_Routes[index];
                                return ListTile(
                                  leading: const Icon(Icons.route),
                                  title:
                                      Text("${route.from}  --->  ${route.to}"),
                                  subtitle: Text(
                                      'Date: ${route.date.toLocal().toString().split(' ')[0]}'),
                                );
                              },
                            );
                          }),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(27, 10, 0, 10),
                    child: Text(
                      'Popular Routes',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    )),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            clipBehavior: Clip.hardEdge,
                            child: Image.asset('assets/PGI_to_Zirakpur.webp',fit: BoxFit.fill,),
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(45, 0, 0, 0),
                              child: Text(
                                'PGI - Zirakpur',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              )),
                        ],
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            clipBehavior: Clip.hardEdge,
                            child: Image.asset('assets/ISBT-43_to_Manimajra.webp',fit: BoxFit.fill,),
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(19, 0, 0, 0),
                              child: Text(
                                'ISBT-43 - Manimajra',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              )
                            ),
                        ],
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                          clipBehavior: Clip.hardEdge,
                          child: Image.asset('assets/IT-Park_to_Nada_Sahib.jpeg',fit: BoxFit.fill,),
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: Text(
                                'IT-Park - Nada Sahib',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              )),
                        ],
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              clipBehavior: Clip.hardEdge,
                              child: Image.asset('assets/Mansa_Devi_to_Ram_Darbar.avif',fit: BoxFit.fill,),
                            ),
                            Padding(
                                padding: EdgeInsets.fromLTRB(6, 0, 0, 0),
                                child: Text(
                                  'Mansa Devi - Ram Darbar',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(27, 10, 0, 10),
                    child: Text(
                      'Saved Routes',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    )),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Text(
                            'Route C',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                  child: Row(
                    children: [
                      Icon(Icons.add, size: 25),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Add a new Route',
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 16),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ]),
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
      ),
    );
  }
}
