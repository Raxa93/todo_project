// ignore_for_file: prefer_const_literals_to_create_immutables, unused_local_variable, missing_return, must_be_immutable

import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'dart:convert' show base64;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:todo_softui/Constants/text_styles.dart';
import 'package:todo_softui/Controller/task_provider.dart';


class UserProfile extends StatefulWidget {
  String dummyUser;
  String dummyEmail;
  MemoryImage imageFromDb;
  bool isInsert;
  UserProfile({Key key,this.dummyUser,this.dummyEmail,this.isInsert,this.imageFromDb}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  XFile _image;
  Uint8List imageBytes; //convert to bytes
  String decodedImage;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  TaskProvider taskProvider = TaskProvider();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  @override
  void initState() {
    print('drawer screen initState');
    super.initState();
    userNameController.text = widget.dummyUser;
    emailController.text = widget.dummyEmail;
  }
  @override
  Widget build(BuildContext context) {
    print('State rebuild');
    var usrList = Provider.of<TaskProvider>(context, listen: false).userList;
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;


    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white60,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10),
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: screenHeight * 0.36,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: screenWidth * 0.23,
                      top: screenHeight * 0.02,
                      child: CircleAvatar(
                        radius: screenHeight * 0.15,
                        child: _image != null
                            ? ClipOval(
                                child: Image.file(File(_image.path),
                                    fit: BoxFit.cover, width: screenWidth * 0.55, height: screenHeight * 0.55),
                              )
                            : CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: widget.imageFromDb,
                          radius: screenHeight * 0.148,
                        ))
                    ),
                    Positioned(
                      left: screenWidth * 0.58,
                      top: screenHeight * 0.22,
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: screenHeight * 0.043,
                        child: CircleAvatar(
                          radius: screenHeight * 0.040,
                          backgroundColor: Colors.white,
                          child: GestureDetector(
                              onTap: () async {
                                await _showPicker(context);
                              },
                              child: Icon(Icons.camera_alt, color: Colors.blue)),
                        ),
                      ),
                    ),
                    // CircleAvatar(backgroundColor: Colors.white)
                  ],
                ),
              ),
              // SizedBox(height: screenHeight * 0.05),
              Text('Hello! ${widget.dummyUser}', style: kTitleStyle),
              SizedBox(height: screenHeight * 0.05),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: userNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'User Name'),
                      cursorHeight: 15,
                      maxLines: 1,
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Email'),
                      cursorHeight: 15,
                      maxLines: 1,
                    ),
                    SizedBox(height: screenHeight * 0.10),
                  ],
                ),
              ),

              ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(Size(screenWidth, 50)),
                    shadowColor: MaterialStateProperty.all(Colors.black),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      if(widget.isInsert)
                        {
                          print('I will insert data');
                            await taskProvider.insertUserDataToProvider(userNameController.text, emailController.text, decodedImage);
                           Navigator.of(context).pop();
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                        }
                      else{
                        print('I will update data');
                        if(decodedImage==null){
                          setState(() {
                            imageBytes = widget.imageFromDb.bytes;
                            decodedImage = base64.encode(imageBytes);
                          });
                        }
                        print('decoded Image else is ${userNameController.text}');
                         await taskProvider.updateUserDataToProvider(userNameController.text, emailController.text, decodedImage);
                        Navigator.of(context).pop();
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                      }

                    }
                  },
                  child: Text('Save Info')),
            ],
          ),
        ),
      ),
    );
  }

  Future _showPicker(context) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Photo Library'),
                    onTap: () async {
                      await getImageFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Camera'),
                  onTap: () async {
                    await getImageFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<Void> getImageFromCamera() async {
    var pickedFile = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 50);
    imageBytes = await _image.readAsBytes();
    setState(() {
      if (pickedFile != null) {
        _image = pickedFile;
        decodedImage = base64.encode(imageBytes);
        print(_image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<Void> getImageFromGallery() async {
    var pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50);

    imageBytes = await pickedFile.readAsBytes();

    setState(() {
      if (pickedFile != null) {
        _image = pickedFile;
        decodedImage = base64.encode(imageBytes);
        print(decodedImage);
      } else {
        print('No image selected.');
      }
    });
  }
}
