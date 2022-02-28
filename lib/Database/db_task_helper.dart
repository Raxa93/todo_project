// ignore_for_file: prefer_const_declarations, missing_return, avoid_print, unnecessary_string_interpolations

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:todo_softui/Model/category_model.dart';
import 'package:todo_softui/Model/todo_model.dart';
import 'package:todo_softui/Model/user_model.dart';

class DatabaseHelper {
  static final _dbName = 'TodoTask.db';
  static final _taskTableName = 'taskTable';
  static final _categoryTableName = 'categoryTable';
  static final _userTableName = 'userTable';
  static final columntaskId = 'taskId';
  static final columntaskDescription = 'taskDescription';
  static final columntaskDateTime = 'taskDateTime';
  static final columntaskAdditionalNotes = 'taskAdditionalNotes';
  static final columntaskCategory = 'taskCategory';
  static final columnCategoryId = 'taskId';
  static final columnCategoryName = 'categoryName';
  static final columnCategoryColor = 'categoryColor';
  static final columnCategoryIcon = 'categoryIcon';
  static final columnNoOfTask = 'numberOfTask';
  static final columnUserId = 'userId';
  static final columnUserName = 'userName';
  static final columnUserEmail = 'userEmail';
  static final columnUserImageCode = 'userImage';


  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      print('Databae Exists $_dbName so i am ignoring rest of create functions');
      print('db value is $_db');

      return _db;
    }
    print('I am creating Database $_dbName Now ');
    _db = await initDatabase();
    print('db value is $_db');
    return _db;
  }

  initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = p.join(databasesPath, _dbName);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {

    await db.execute(
        'CREATE TABLE $_taskTableName($columntaskId INTEGER PRIMARY KEY AUTOINCREMENT,$columntaskDescription TEXT,$columntaskDateTime TEXT,$columntaskAdditionalNotes TEXT,$columntaskCategory TEXT)');
    await db.execute('CREATE TABLE $_categoryTableName($columnCategoryId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
        '$columnCategoryName TEXT,$columnCategoryColor INTEGER,$columnCategoryIcon INTEGER,$columnNoOfTask INTEGER)');

    await db.execute('CREATE TABLE $_userTableName($columnUserId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
        '$columnUserName TEXT,$columnUserEmail TEXT,$columnUserImageCode TEXT)');

    print("Table $_taskTableName , $_userTableName And $_categoryTableName Created!!");
  }

  Future<int> insertTask(Todo todo) async {
    var dbClient = await db;
    return await dbClient.insert(_taskTableName, todo.toMap());
  }


  Future<int> deleteTask(int id) async {
    var dbClient = await db;
    print('delete function ID = $id');
    return await dbClient.rawDelete('DELETE FROM $_taskTableName WHERE $columntaskId = ?', ['$id']);
  }


  Future<List<Todo>> getAllTask() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery('SELECT * FROM $_taskTableName');

    List<Todo> taskList = [];

    for (int i = 0; i < maps.length; i++) {
      taskList.add(Todo.fromMap(maps[i]));
    }

    return taskList;
  }

  Future<List<Todo>> getSpecificTasksFromDB(String categoryName) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery('SELECT * FROM $_taskTableName WHERE $columntaskCategory =?', ['$categoryName']);

    List<Todo> taskList = [];

    for (int i = 0; i < maps.length; i++) {
      taskList.add(Todo.fromMap(maps[i]));
      print('Data is ${taskList[i].taskDescription}');
    }


    return taskList;
  }

  //Category Functions below this

  Future<List<TaskCategory>> getAllCategoryFromDB() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery('SELECT * FROM $_categoryTableName');
    List<TaskCategory> categoryList = [];

    for (int i = 0; i < maps.length; i++) {
      categoryList.add(TaskCategory.fromMap(maps[i]));
    }


    return categoryList;
  }

  Future<int> insertCategory(TaskCategory category) async {
    var dbClient = await db;
    return await dbClient.insert(_categoryTableName, category.toMap());
  }

  Future<int> selectCategoryNumberOfTaskAndDecrement(String categoryName) async {
    var dbClient = await db;
    try {
      List<Map> maps = await dbClient.rawQuery('SELECT $columnNoOfTask FROM $_categoryTableName WHERE $columnCategoryName = ?', ['$categoryName']);
      var _currentNumberOfTask = maps[0].values.first;
      await decrementNumberOfTask(categoryName, _currentNumberOfTask);
    } catch (e) {
      print('Exception is $e');
    }
  }


  Future<int> selectCategoryNumberOfTaskAndIcrement(String categoryName) async {
    var dbClient = await db;
    var updatedNoOfTask = 0;
    try {
      List<Map> maps = await dbClient.rawQuery('SELECT $columnNoOfTask FROM $_categoryTableName WHERE $columnCategoryName = ?', ['$categoryName']);
      var _currentNumberOfTask = maps[0].values.first;

      updatedNoOfTask = _currentNumberOfTask + 1;
      await dbClient.rawUpdate('UPDATE $_categoryTableName SET $columnNoOfTask = ? WHERE $columnCategoryName = ?',
          [updatedNoOfTask, categoryName]);

    } catch (e) {
      print('Exception is $e');
    }
  }


  Future<void> decrementNumberOfTask(String categoryName, currentNumberOfTask )async {
    var dbClient = await db;
    var updatedNoOfTask = currentNumberOfTask - 1;

    try {
      await dbClient.rawUpdate('UPDATE $_categoryTableName SET $columnNoOfTask = ? WHERE $columnCategoryName = ?',
          [updatedNoOfTask, categoryName]);

    } catch (e) {
      print('Exception is $e');
    }
  }

  Future<List<Users>> getAllUserData() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery('SELECT * FROM $_userTableName');
    List<Users> userList = [];
    for (int i = 0; i < maps.length; i++) {
      userList.add(Users.fromMap(maps[i]));
       print('This is user map ${maps[i]}');
    }
    return userList;
  }

  Future<int> insertUser(Users user) async {
    var dbClient = await db;
    print('Inside DB insert function ');
    return await dbClient.insert(_userTableName, user.toMap());
  }

  Future<int> updateUser(Users user) async {
    var dbClient = await db;
    print('Inside Update function ');
    return  await dbClient.rawUpdate('UPDATE $_userTableName SET $columnUserName = ?,$columnUserEmail = ?,$columnUserImageCode = ? WHERE $columnUserId = ?',
        [user.userName,user.userEmail,user.userImage, 1]);
  }
}
