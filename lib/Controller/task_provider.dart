import 'package:flutter/cupertino.dart';
import 'package:todo_softui/Database/db_task_helper.dart';
import 'package:todo_softui/Model/category_model.dart';
import 'package:todo_softui/Model/todo_model.dart';
import 'package:todo_softui/Model/user_model.dart';

class TaskProvider extends ChangeNotifier {
  DatabaseHelper dbHelper = DatabaseHelper();

  // CategoryDatabaseHelper dbcategoryhelper = CategoryDatabaseHelper();

  List<Todo> todoList = [];
  List<TaskCategory> categoryList = [];
  List<Users> userList = [];

  Future<List<Todo>> getAllTasks() async {
    todoList = await dbHelper.getAllTask();
    notifyListeners();
    return todoList;
  }

  Future<List<Todo>> getAllTasksForSpecificCategory(String categoryName) async {
    todoList = await dbHelper.getSpecificTasksFromDB(categoryName);
    notifyListeners();
    return todoList;
  }

  Future<void> insertTaskWithProvider(
      String taskDescription, String taskDate, String taskNotes, String taskCategory) async {
    var newTask = Todo(
        taskDescription: taskDescription,
        taskDateTime: taskDate,
        taskAdditionalNotes: taskNotes,
        taskCategory: taskCategory);
    dbHelper.insertTask(newTask);
    notifyListeners();
  }

  Future<void> insertTaskToModel(String taskDescription, String taskDate, String taskNotes, String taskCategory) async {
    var newTask = Todo(
        taskDescription: taskDescription,
        taskDateTime: taskDate,
        taskAdditionalNotes: taskNotes,
        taskCategory: taskCategory);
    todoList.add(newTask);
    notifyListeners();
  }

  Future<void> deleteTaskWithProvider(int id) async {
    await dbHelper.deleteTask(id);
    notifyListeners();
  }

  Future<void> selectNumberOfTaskAndIcrement(String categoryName) async {
    await dbHelper.selectCategoryNumberOfTaskAndIcrement(categoryName);
    notifyListeners();
  }

  Future<void> selectNumberOfTaskAndDecremtn(String categoryName) async {
    await dbHelper.selectCategoryNumberOfTaskAndDecrement(categoryName);
    notifyListeners();
  }

  Future getAllCategory() async {
    categoryList = await dbHelper.getAllCategoryFromDB();
     notifyListeners();
  }

  Future<void> insertCategoryToDb(String _categoryName, int colorCode, int iconDataCode) async {
    var newCategory = TaskCategory(
        categoryName: _categoryName, categoryColor: colorCode, categoryIcon: iconDataCode, numberOfTask: 0);
    await dbHelper.insertCategory(newCategory);
    notifyListeners();
  }

  void insertCategoryToModel(String _categoryName, int colorCode, int iconDataCode) async {
    var newCategory = TaskCategory(
        categoryName: _categoryName, categoryColor: colorCode, categoryIcon: iconDataCode, numberOfTask: 0);
    categoryList.add(newCategory);
    notifyListeners();
  }

  Future<List<Users>> getAllUserData() async {
    userList = await dbHelper.getAllUserData();
    // if(userList.isEmpty)
    //   {
    //    await insertUserDataToProvider('Sample_User', 'Sample_email', 'A');
    //   }
    notifyListeners();
    return userList;

  }


  Future<void> updateUserDataToProvider(String _userName , String _userEmail,String _userImage) async {
      var newUser = Users(
          userName: _userName,
          userEmail: _userEmail,
          userImage: _userImage
      );
      await dbHelper.updateUser(newUser);
      notifyListeners();
  }

  Future<void> insertUserDataToProvider(String _userName , String _userEmail,String _userImage) async {
    var newUser = Users(
        userName: _userName,
        userEmail: _userEmail,
        userImage: _userImage
    );
    await dbHelper.insertUser(newUser);
    notifyListeners();
  }

  // void insertUserToModel(String _userName , String _userEmail,String _userImage) async {
  //   var newUser = Users(
  //       userName: _userName,
  //       userEmail: _userEmail,
  //       userImage: _userImage
  //   );
  //   userList.add(newUser);
  //
  //   notifyListeners();
  // }
}
