// ignore_for_file: prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unused_import, unused_local_variable, prefer_is_empty

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:todo_softui/Constants/drawer_data.dart';
import 'package:todo_softui/Constants/home_screen_card.dart';
import 'package:todo_softui/Controller/task_provider.dart';
import 'package:todo_softui/Controller/theme_provider.dart';
import 'package:todo_softui/Model/category_model.dart';
import 'package:todo_softui/Model/todo_model.dart';
import 'package:todo_softui/Screens/add_new_category.dart';
import 'package:todo_softui/Services/notification_services.dart';
import 'package:todo_softui/ThemeSetting/themes.dart';

import 'add_new_task.dart';
import 'specific_category.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    print('Home screen initState');
    super.initState();
    getAllCategoryFromProvider();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeProvider>(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => showDialog(
            context: context,
            builder: (context) => AlertDialog(title: Text('Are you sure you want to Exit?'), actions: <Widget>[
                  ElevatedButton(child: Text('Exit'), onPressed: () => Navigator.of(context).pop(true)),
                  ElevatedButton(child: Text('Cancel'), onPressed: () => Navigator.of(context).pop(false)),
                ])),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: themeNotifier.getTheme() == darkTheme ? Colors.grey[900] : Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: themeNotifier.getTheme() == darkTheme ? Colors.white : Colors.black),
          ),
          drawer: Drawer(
            child: DrawerData(),
          ),
          body: Consumer(builder: (context, TaskProvider taskProvider, widget) {
            if (taskProvider.categoryList.isEmpty) {
              return Center(
                child: Text('No task added Yet'),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(top: 25.0, right: 12, left: 12),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200, childAspectRatio: 3 / 3, crossAxisSpacing: 20, mainAxisSpacing: 20),
                  itemCount: Provider.of<TaskProvider>(context, listen: false).categoryList.length,
                  itemBuilder: (BuildContext context, index) {
                    Color cl = Color(Provider.of<TaskProvider>(context, listen: false).categoryList[index].categoryColor);
                    TaskCategory category = Provider.of<TaskProvider>(context, listen: false).categoryList[index];
                    return SingleChildScrollView(
                        child: AnimationLimiter(
                      child: Column(
                        children: AnimationConfiguration.toStaggeredList(
                            duration: Duration(milliseconds: 2000),
                            childAnimationBuilder: (widget) => SlideAnimation(
                                  horizontalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: widget,
                                  ),
                                ),
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SpecificCategoryTask(
                                                  headerIcon: category.categoryIcon,
                                                  taskNumber: category.numberOfTask,
                                                  taskCategory: category.categoryName)),
                                        );
                                      },
                                      child: HomeScreenCard(
                                        iconDetail: category.categoryIcon,
                                        displayTxt: category.categoryName,
                                        numberOfTask: category.numberOfTask,
                                        iconColor: cl,
                                      )),
                                ],
                              )
                            ]),
                      ),
                    ));
                  },
                ),
              );
            }
          }),
          floatingActionButton: SpeedDial(
            icon: Icons.add,
            activeIcon: Icons.close,
            backgroundColor: themeNotifier.getTheme() == darkTheme ? Colors.grey[800] : Colors.deepOrangeAccent,
            foregroundColor: Colors.white,
            activeBackgroundColor: themeNotifier.getTheme() == darkTheme ? Colors.grey[800] : Colors.deepPurpleAccent,
            activeForegroundColor: Colors.white,
            visible: true,
            closeManually: false,
            curve: Curves.bounceIn,
            overlayColor: Colors.grey,
            overlayOpacity: 0.5,
            elevation: 12.0,
            shape: CircleBorder(),
            children: [
              SpeedDialChild(
                //speed dial child
                child: Icon(Icons.add_task_outlined),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                label: 'Add Task',
                labelStyle: TextStyle(fontSize: 10.0),
                onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewTask()))},
              ),
              SpeedDialChild(
                child: Icon(Icons.category_outlined),
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                label: 'Add Category',
                labelStyle: TextStyle(fontSize: 10.0),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddNewCategory()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getAllCategoryFromProvider() async {
    await Provider.of<TaskProvider>(context, listen: false).getAllCategory();
  }
}
