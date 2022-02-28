// ignore_for_file: prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures, unused_local_variable, prefer_final_fields, unused_field

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_softui/Constants/text_styles.dart';
import 'package:todo_softui/Controller/task_provider.dart';
import 'package:todo_softui/Controller/theme_provider.dart';
import 'package:todo_softui/Model/category_model.dart';
import 'package:todo_softui/Screens/home_screen.dart';
import 'package:todo_softui/Services/notification_services.dart';
import 'package:todo_softui/ThemeSetting/themes.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({Key key}) : super(key: key);

  @override
  _AddNewTaskState createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  DateTime _now = DateTime.now();
  TimeOfDay _selectedTime =TimeOfDay.now();
  String _currentCategory;
  TaskProvider taskProvider = TaskProvider();
  final _descriptionController = TextEditingController();
  var _notesController = TextEditingController();
  final DateFormat format =  DateFormat("yyyy-MM-dd hh:mm a");
  var alarmId = Random();


  List<TaskCategory> allTaskCategoryData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationService().requestPermission();
    getAllCategoryFromProvider();
    _notesController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('yyy-MM-dd');
    final String _formattedDate = formatter.format(_now);
    final String dateTimeString = _formattedDate + " " + _selectedTime.format(context);
    final DateTime scheduleDateTime =  format.parse(dateTimeString);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    allTaskCategoryData = Provider.of<TaskProvider>(context, listen: false).categoryList;
    final themeNotifier = Provider.of<ThemeProvider>(context);
    var alarmid = allTaskCategoryData.length;

    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: themeNotifier.getTheme() == darkTheme ?  Colors.grey[900] : Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: themeNotifier.getTheme() == darkTheme ? Colors.white : Colors.black),
        title: Text('New Task', style: TextStyle( fontSize: 18)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 60, right: 15),
          child: AnimationLimiter(
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: Duration(milliseconds: 800),
                childAnimationBuilder: (widget) => SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
                children: <Widget>[
                  Row(
                    children: [
                      Text('What are you planning?', style: kTitleStyle.copyWith(color: themeNotifier.getTheme() == darkTheme ? Colors.white : Colors.black)),
                    ],
                  ),
                  TextField(
                    decoration: InputDecoration(),
                    controller: _descriptionController,
                    cursorHeight: 30,
                    maxLines: 2,
                  ),
                  SizedBox(height: screenHeight * 0.08),
                  Row(
                    children: <Widget>[
                      Icon(Icons.alarm_add_outlined, color: Colors.lightBlue),
                      SizedBox(width: screenWidth * 0.03),
                      GestureDetector(
                        onTap: ()  async {
                          await _selectDate(context);
                          await  _selectTime(context);
                        },
                        child: Text(
                          '$_formattedDate ${_selectedTime.format(context)}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Row(
                    children: <Widget>[
                      Icon(Icons.note_add, color: Colors.lightBlue),
                      SizedBox(width: screenWidth * 0.03),
                      GestureDetector(
                        onTap: () async {
                          var name = await openDialogToEnterName();
                        },
                        child: Text(
                          _notesController.text.isNotEmpty ? _notesController.text : 'Enter Task Name',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  DropdownButtonFormField<String>(
                    hint: allTaskCategoryData.isEmpty ? Text('No Category available') : Text('Select category'),
                    onChanged: (val) => setState(() => _currentCategory = val),
                    items: allTaskCategoryData.map((cat) => DropdownMenuItem(child: Text(cat.categoryName), value: cat.categoryName)).toList()

                  ),
                  SizedBox(height: screenHeight * 0.08),
                  Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () async {
                                EasyLoading.show(status: 'Saving Task');
                                await taskProvider.insertTaskWithProvider(_descriptionController.text, _formattedDate, _notesController.text, _currentCategory);
                                await taskProvider.selectNumberOfTaskAndIcrement(_currentCategory);
                                await taskProvider.insertTaskToModel(_descriptionController.text, _formattedDate, _notesController.text, _currentCategory);
                                 NotificationService().showScheduledNotification(alarmid+1 , 'main_channel', _notesController.text, _descriptionController.text, scheduleDateTime);
                                EasyLoading.showSuccess('Great!! Task Added');
                                _notesController.clear();
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                              },
                              child: Text('Create'))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
  Future<void> _selectTime(BuildContext context) async{
    final TimeOfDay pickedS = await showTimePicker(
        context: context,
        initialTime: _selectedTime, builder: (BuildContext context, Widget child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
        child: Theme(
          data: ThemeData.dark(),
          child: child,
        ),
      );});
    if (pickedS != null && pickedS != _selectedTime ) {
      setState(() {
        _selectedTime = pickedS;
      });
    }
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      selectableDayPredicate: _decideWhichDayToEnable,
      confirmText: 'Set',
      cancelText: 'Not Now',
      // initialDatePickerMode: DatePickerMode.year,
      helpText: 'Pick date for remainder',
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(), // This will change to light theme.
          child: child,
        );
      },
    );
    if (picked != null && picked != _now)
      setState(() {
        _now = picked;
      });
  }

  bool _decideWhichDayToEnable(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(Duration(days: 1))) &&
        day.isBefore(DateTime.now().add(Duration(days: 30))))) {
      return true;
    }
    return false;
  }

  Future<String> openDialogToEnterName() async {
    showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Add additional notes'),
              content: TextField(
                controller: _notesController,
                decoration: InputDecoration(hintText: 'Enter Notes Here'),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      submit();
                    },
                    child: Text('Submit'))
              ],
            ));
    return _notesController.text;
  }

  void submit() {
    Navigator.of(context).pop(_notesController.text);
  }

  void getAllCategoryFromProvider() async {
    Provider.of<TaskProvider>(context, listen: false).getAllCategory();
  }
}
