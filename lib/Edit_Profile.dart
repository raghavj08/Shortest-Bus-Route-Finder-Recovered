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

  void _saveProfile() {
    Navigator.pop(context, {
      'name': nameController.text,
      'username': usernameController.text,
      'bio': bioController.text,
      'image': _image
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 2, 75, 201),
        title: Text(
          'Edit Profile',
          style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 40,),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? Icon(
                          Icons.person,
                          size: 60,
                        )
                      : null,
                ),
                FloatingActionButton(
                    mini: true,
                    child: Icon(Icons.edit),
                    onPressed: () {
                      _pickImage();
                    })
              ],
            ),
            SizedBox(
              height: 20,
            ),
            _buildTextField("Name", nameController),
            SizedBox(height: 10,),
            _buildTextField("Username", usernameController),
            SizedBox(height: 10,),
            _buildTextField("Bio", bioController, maxLines: 3),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(onPressed: _saveProfile, child: Text('Save'))
          ],
        ),
      ),
    );
  }
}

Widget _buildTextField(String label, TextEditingController controller,
    {int maxLines = 1}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 6),
    child: TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
    ),
  );
}
