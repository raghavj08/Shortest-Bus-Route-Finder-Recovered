import 'package:daa_project/Save.dart';
import 'package:daa_project/Search.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';

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

  TextEditingController from_Controller = new TextEditingController();
  TextEditingController to_Controller = new TextEditingController();
  TextEditingController date_Controller = new TextEditingController();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 2, 75, 201),
                borderRadius: BorderRadius.all(Radius.circular(35))),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
            ]),
          ),
          Center(
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 110, 0, 0),
                child: Container(
                  height: 320,
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
                          width: 60,
                          height: 100,
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
                height: 380,
              ),
              Padding(
                padding: EdgeInsets.all(25),
                child: Container(
                  height: 45,
                  width: 500,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 233, 230, 230),
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                      ),
                      Icon(Icons.search),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Search Routes'),
                    ],
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(27, 10, 0, 10),
                  child: Text(
                    'Popular Routes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
                        ),
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              'Route A',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            )),
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text('Fastest Route')),
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
                        ),
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              'Route B',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            )),
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text('Cheapest Route')),
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
                        ),
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              'Route C',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            )),
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text('Fastest Route')),
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
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text(
                                'Route D',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              )),
                          Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text('Cheapest Route')),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          'Route C',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        )),
                    Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text('Fastest Route')),
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
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
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
                            builder: (context) => Search(),
                          ));
                    },
                    icon: Icon(Icons.search)),
                label: "Search"),
            BottomNavigationBarItem(
                icon: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Save(),
                          ));
                    },
                    icon: Icon(Icons.save_alt_rounded)),
                label: 'Saved')
          ]),
    );
  }
}
