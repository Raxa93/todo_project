// ignore_for_file: unused_local_variable, must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:todo_softui/Controller/task_provider.dart';
import 'package:todo_softui/Model/todo_model.dart';
import 'package:todo_softui/Screens/home_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

class SpecificTaskCard extends StatefulWidget {
  Todo todoItem;

  SpecificTaskCard({Key key, this.todoItem}) : super(key: key);

  @override
  State<SpecificTaskCard> createState() => _SpecificTaskCardState();
}

class _SpecificTaskCardState extends State<SpecificTaskCard> {
  TaskProvider taskprovider = TaskProvider();
  bool _checkbox = false;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    var datePosted = DateTime.parse(widget.todoItem.taskDateTime);
    final difference = DateTime.now().difference(datePosted);
    DateTime daysAgo = DateTime.now().subtract(difference);

    return SingleChildScrollView(
        child: AnimationLimiter(
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            difference.inDays == 0 ? Text('Today') : Text('${difference.inDays} days ago'),
            ListTile(
              title: Text(widget.todoItem.taskAdditionalNotes,
                  style: _checkbox
                      ? TextStyle(fontSize: 20, color: Colors.lightBlueAccent, decoration: TextDecoration.lineThrough)
                      : TextStyle(fontSize: 20, color: Colors.black)),
              subtitle: Text(widget.todoItem.taskDateTime),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Checkbox(
                      onChanged: (bool val) {
                        setState(() {
                          _checkbox = val;
                        });
                      },
                      value: _checkbox),
                  _checkbox
                      ? GestureDetector(
                          onTap: () {
                            EasyLoading.show(status: 'Deleting');
                            taskprovider.selectNumberOfTaskAndDecremtn(widget.todoItem.taskCategory);
                            taskprovider.deleteTaskWithProvider(int.parse(widget.todoItem.taskId));
                            EasyLoading.showSuccess('Task Deleted!');
                            Navigator.pop(context);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                          },
                          child: Icon(Icons.delete_outline, color: Colors.red))
                      : Text('')
                ],
              ),
            ),
          ],
        ),
      ),

      // child: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: AnimationConfiguration.toStaggeredList
      //     (
      //     duration:  Duration(milliseconds: 800),
      //     childAnimationBuilder: (widget) => SlideAnimation(
      //       horizontalOffset: 50.0,
      //       child: FadeInAnimation(
      //         child: widget,
      //       ),
      //     ),
      //     children: <Widget>[
      //       SizedBox(height: screenHeight * 0.03),
      //       Text('Late', style: TextStyle(fontSize: 15, color: Colors.grey)),
      //       SizedBox(height: 10),
      //       Row(
      //         children: <Widget>[
      //           Text(widget.taskName, style: _checkbox ? TextStyle(fontSize: 20, color: Colors.lightBlueAccent , decoration: TextDecoration.lineThrough) : TextStyle(fontSize: 20, color: Colors.black)),
      //             SizedBox(width: screenWidth * .45),
      //           _checkbox ? GestureDetector(
      //             onTap: (){
      //               EasyLoading.show(status: 'Deleting');
      //               taskprovider.selectNumberOfTaskAndDecremtn(widget.categoryName);
      //               taskprovider.deleteTask(widget.taskId);
      //               EasyLoading.showSuccess('Task Deleted!');
      //               Navigator.pop(context);
      //               Navigator.pushReplacement(
      //                   context, MaterialPageRoute(builder: (context) => HomeScreen()));
      //             },
      //               child: Icon(Icons.delete_outline_outlined,color: Colors.red)) : SizedBox(height: 1),
      //            Checkbox(
      //             onChanged: (bool val) {
      //               setState(() {
      //                 _checkbox = val;
      //               });
      //             },
      //             value: _checkbox,
      //           ),
      //         ],
      //       ),
      //       SizedBox(height: screenHeight * 0.01),
      //       Text(widget.dateofTask, style: TextStyle(fontSize: 18, color: Colors.red[300])),
      //
      //     ],
      //   ),
      // )),
    ));
  }
}
