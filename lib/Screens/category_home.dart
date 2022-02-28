// ignore_for_file: prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unused_import, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:todo_softui/Constants/drawer_data.dart';
import 'package:todo_softui/Constants/home_screen_card.dart';
import 'package:todo_softui/Controller/task_provider.dart';
import 'package:todo_softui/Model/category_model.dart';
import 'package:todo_softui/Model/todo_model.dart';
import 'package:todo_softui/Screens/add_new_category.dart';

import 'add_new_task.dart';
import 'specific_category.dart';

class CategoryHomeScreen extends StatefulWidget {
  const CategoryHomeScreen({Key key}) : super(key: key);

  @override
  _CategoryHomeScreenState createState() => _CategoryHomeScreenState();
}

class _CategoryHomeScreenState extends State<CategoryHomeScreen> {
  Future<List<TaskCategory>> allTaskCategoryData;

  @override
  void initState() {
    super.initState();
    getAllCategoryFromProvider();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var taskInfo = Provider.of<TaskProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white60,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        drawer: Drawer(
          child: DrawerData(),
        ),
        body: FutureBuilder<List<TaskCategory>>(
          future: allTaskCategoryData,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            } else {

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200, childAspectRatio: 3 / 3, crossAxisSpacing: 20, mainAxisSpacing: 20),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, index) {
                  Color cl = Color(snapshot.data[index].categoryColor);

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
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) => SpecificCategoryTask(
                                      //
                                      //           taskNumber: taskInfo.todoList.length,
                                      //           taskCategory: snapshot.data[index].categoryName)),
                                      // );
                                    },
                                    child: HomeScreenCard(
                                      iconDetail: snapshot.data[index].categoryIcon,
                                      displayTxt: snapshot.data[index].categoryName,
                                      numberOfTask: taskInfo.todoList.length,
                                      iconColor: cl,
                                    )),
                              ],
                            )
                          ]),
                    ),
                  ));
                },
              );
            }
          },
        ),
        floatingActionButton: SpeedDial(
          icon: Icons.add,
          activeIcon: Icons.close,
          backgroundColor: Colors.deepOrangeAccent,
          foregroundColor: Colors.white,
          activeBackgroundColor: Colors.deepPurpleAccent,
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
              onTap: () => {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddNewTask()))},
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
    );
  }

  Widget categoryCard({List<Todo> todo, String category, int index}) {
    return Container(
      alignment: Alignment.center,
      child: Text(todo[index].taskCategory),
      decoration: BoxDecoration(color: Colors.yellow, borderRadius: BorderRadius.circular(10)),
    );
  }

  void getAllCategoryFromProvider() async {
    TaskProvider taskprovider = TaskProvider();
    allTaskCategoryData = taskprovider.getAllCategory();
  }
}
