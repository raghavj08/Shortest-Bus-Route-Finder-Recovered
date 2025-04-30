import 'dart:io';

import 'package:daa_project/Edit_Profile.dart';
import 'package:daa_project/Home_Page.dart';
import 'package:daa_project/All_Routes.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int selected_index = 2;

  String name = 'Raghav Joshi';
  String userName = '';
  String bio = 'Enter you bio here';
  File? image;

  void _goToEditPage() async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (_) => EditProfile()));

    if (result != null) {
      setState(() {
        name = result['name'];
        userName = result['username'];
        bio = result['bio'];
        image = result['image'];
      });
    }
  }


  void _onItemTapped(int index) {
    setState(() {
      selected_index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: _goToEditPage, 
            icon: Icon(Icons.edit))
        ],
        backgroundColor: Color.fromARGB(255, 2, 75, 201),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20,),
            CircleAvatar(
              radius: 60,
              backgroundImage: image != null ? FileImage(image!):null,
              child: image == null ? Icon(Icons.person,size: 60,):null,
            ),
            SizedBox(height: 10,),
            Text(name, style: TextStyle(fontSize: 22),),
            if(userName.isNotEmpty) 
            Text('@$userName', style: TextStyle(color: Colors.grey),),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(bio, textAlign: TextAlign.center,style: TextStyle(fontSize: 18),), 
            )
          ],
        ),
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
