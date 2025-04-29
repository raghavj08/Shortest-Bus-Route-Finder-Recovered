import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _image;
  final picker = ImagePicker();

  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final bioController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _saveProfile(){
    Navigator.pop(context,{
      'name':nameController.text,
      'username': usernameController.text,
      'bio': bioController.text,
      'image': _image
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile',style: TextStyle(fontWeight: FontWeight.w700,color: Color.fromARGB(255, 2, 75, 201)),),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            
          ],
        ),
      ),
    );
  }
}
