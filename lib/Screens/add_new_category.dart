// ignore_for_file: prefer_const_literals_to_create_immutables, unused_local_variable
import 'dart:ui';

import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:todo_softui/Controller/task_provider.dart';
import 'package:todo_softui/Controller/theme_provider.dart';
import 'package:todo_softui/Screens/home_screen.dart';
import 'package:todo_softui/ThemeSetting/themes.dart';

class AddNewCategory extends StatefulWidget {
  const AddNewCategory({Key key}) : super(key: key);

  @override
  _AddNewCategoryState createState() => _AddNewCategoryState();
}

class _AddNewCategoryState extends State<AddNewCategory> {

  Color pickerColor = Colors.blue;
  int defaultColor = 4282201409;
  var defaultIcon = 58136;
  dynamic colorToSave;
  dynamic iconToSave;
  final _categoryNameController = TextEditingController();
  bool _validate = false;
  Color _selectedCurrentColor = Colors.blue;
  IconData _selectedIcon;
  TaskProvider categoryProvider = TaskProvider();

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeProvider>(context);
    Color textColor = themeNotifier.getTheme() == darkTheme ? Colors.white : Colors.black;
    Color buttonColor = themeNotifier.getTheme() == darkTheme ? Colors.grey[700] : Colors.blue[400];

    //
    // _darkTheme = (themeNotifier.getTheme() == darkTheme);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: themeNotifier.getTheme() == darkTheme ?  Colors.grey[900] : Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData( color: themeNotifier.getTheme() == darkTheme ? Colors.white : Colors.black),
        title: Text('Add New Category', style: TextStyle( color: textColor , fontSize: 18)),
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: buttonColor
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(500)
            ),
            color: themeNotifier.getTheme() == darkTheme ?  Colors.grey[900] : Colors.white
          ),

          height: screenHeight * 0.9,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 40, right: 15),
              child: AnimationLimiter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: AnimationConfiguration.toStaggeredList(
                      duration: Duration(milliseconds: 900),
                      childAnimationBuilder: (widget) => SlideAnimation(
                            horizontalOffset: 50.0,
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        TextField(
                          controller: _categoryNameController,
                          decoration: InputDecoration(
                            errorText: _validate ? 'Value cant be empty' : null,
                              border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: 'Enter Category Name'),
                          cursorHeight: 15,
                          maxLines: 1,
                        ),
                        SizedBox(height: screenHeight * 0.05),
                        ElevatedButton(
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(_selectedCurrentColor)),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Pick a color!'),
                                  content: SingleChildScrollView(
                                    child: ColorPicker(
                                      pickerColor: pickerColor,
                                      onColorChanged: changeColor,
                                    ),
                                  ),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      child: Text('Pick'),
                                      onPressed: () {
                                        setState(() => _selectedCurrentColor = pickerColor);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Text('Select Icon Color')),
                        SizedBox(height: screenHeight * 0.03),
                        ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              minimumSize: MaterialStateProperty.all(Size(screenWidth, 40)),
                              backgroundColor:
                              MaterialStateProperty.all(buttonColor),
                              // elevation: MaterialStateProperty.all(3),
                              shadowColor: MaterialStateProperty.all(Colors.black),
                            ),
                            onPressed: () {
                              _pickIcon();
                            },
                            child: Text('Pick Icon')),
                        SizedBox(height: screenHeight * 0.05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BlinkText(
                              'Icon will look like this :',
                              style: TextStyle(fontSize: 15.0, color: Colors.red),
                              duration: Duration(milliseconds: 600),
                            ),
                            SizedBox(width: screenWidth * 0.05),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 800),
                              child: Icon(_selectedIcon, color: _selectedCurrentColor, size: 40) ?? Container(),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.2),
                        Row(
                          children: [
                            Container(
                              width: screenWidth * 0.9,
                              height: screenHeight * 0.072,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
                                ],
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  stops: [0.0, 1.0],
                                  colors: [
                                    Colors.blue[500],
                                    Colors.blue[200],
                                  ],
                                ),
                                color: Colors.deepPurple.shade300,
                                borderRadius: BorderRadius.circular(20),
                            ),
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                    ),
                                    minimumSize: MaterialStateProperty.all(Size(screenWidth, 50)),
                                    backgroundColor:
                                    MaterialStateProperty.all(buttonColor),
                                    // elevation: MaterialStateProperty.all(3),
                                    shadowColor:
                                    MaterialStateProperty.all(Colors.transparent),
                                  ),
                                  onPressed: () {
                                    var abc = validateTextField(_categoryNameController.text);
                                    if(abc){
                                      print('State is validated $abc');
                                      EasyLoading.show(status: 'Saving');
                                      categoryProvider.insertCategoryToDb(_categoryNameController.text ?? 'Home',
                                          colorToSave ?? defaultColor, iconToSave ?? defaultIcon);
                                      categoryProvider.insertCategoryToModel(_categoryNameController.text ?? 'Home',
                                          colorToSave ?? defaultColor, iconToSave ?? defaultIcon);

                                      EasyLoading.showSuccess('Great Category saved!');
                                      _categoryNameController.clear();
                                      print('You are here');
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(
                                          context, MaterialPageRoute(builder: (context) => HomeScreen()));
                                    }
                                    else
                                      {
                                        print('State is not validated $abc');
                                      }
                                  },
                                  child: Text('Save Category',style: TextStyle(fontSize: 16))),
                            ),
                          ],
                        ),
                      ]),
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }

  void changeColor(Color color) {
    setState(() {
      pickerColor = color;
      colorToSave = color.value;
      print('This is default color $colorToSave');
    });
    // print(color.value);
    // Color cl = Color(color.value);
    // print('cl $cl');
  }

  _pickIcon() async {
    IconData icon = await FlutterIconPicker.showIconPicker(context, iconPackModes: [IconPack.material]);

    setState(() {
      _selectedIcon = icon;
      print('This is icon when adding $_selectedIcon');
      iconToSave = icon.codePoint;
      print('This is icon code when adding $iconToSave');
    });
    // var iconcode = icon.codePoint;
    // print('IconCode = $iconcode');
    // var decodeicon = IconData(iconcode);
    // print('Decode icon = $decodeicon');
    // debugPrint('Picked Icon:  $icon');
  }

  bool validateTextField(String userInput) {
    if (userInput.isEmpty) {
      setState(() {
        _validate = true;
      });
      return false;
    }
    setState(() {
      _validate = false;
    });
    return true;
  }
}
