import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:testdo/model/project.dart';
import 'package:testdo/model/todoItem.dart';
import 'package:testdo/model/todolist.dart';

class DbHelper {
  static final DbHelper _dbHelper = DbHelper._internal();

  String tblProject = "project";
  String colProjId = "id";
  String colProjName = "name";

  String tblToDoList = "toDoList";
  String colTdlId = "id";
  String colTdlName = "name";
  String colTdlProjectId = "projectId";

  String tblToDoItem = "todoItem";
  String colTdiId = "id";
  String colTdiName = "name";
  String colTdiToDoListId = "toDoListId";
  String colTdiComplete = "complete";

  static Database _db;

  DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "testDo.db";
    var dbTestDo = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbTestDo;
  }

  void _createDb(Database db, int newVersion) async {
    //Table: Project
    await db.execute(
        "CREATE TABLE $tblProject($colProjId INTEGER PRIMARY KEY, $colProjName TEXT);");
    //Table: ToDoList
    await db.execute(
        "CREATE TABLE $tblToDoList($colTdlId INTEGER PRIMARY KEY,"
        + "$colTdlName TEXT, $colTdlProjectId INTEGER,"
        + "CONSTRAINT fk_proj_tdl FOREIGN KEY($colTdlProjectId)"
        + "REFERENCES $tblProject($colProjId));"
        );
    //Table: ToDoItem
    await db.execute(
        "CREATE TABLE $tblToDoItem($colTdiId INTEGER PRIMARY KEY, $colTdiName TEXT, "
            + "$colTdiComplete INTEGER, $colTdiToDoListId INTEGER,"
            + "CONSTRAINT fk_tdl_tdi FOREIGN KEY($colTdiToDoListId)" 
            + "REFERENCES $tblToDoList($colTdlId));");
  }

  //Query methods
  //projects
  Future<List> getProjects() async {
    Database db = await this.db;
    var result = await db.rawQuery("SELECT * FROM $tblProject");
    return result;
  }

  Future<int> insertProject(Project proj) async {
    Database db = await this.db;
    var result = await db.insert(tblProject, proj.toMap());
    return result;
  }

  //Item ToDoLists
  Future<int> insertToDoList(ToDoList toDoList) async {
    Database db = await this.db;
    var result = await db.insert(tblToDoList, toDoList.toMap());
    return result;
  }

  Future<List> getToDoLists(int pId) async {
    Database db = await this.db;
    var result = await db
        .rawQuery("SELECT * FROM $tblToDoList WHERE $colTdlProjectId = $pId");
    return result;
  }

  //Item ToDos
  Future<int> insertTodoItem(ToDoItem todo) async {
    Database db = await this.db;
    var result = await db.insert(tblToDoItem, todo.toMap());
    return result; //if 0 something went wrong
  }

  Future<List> getToDos(int tdlId) async {
    Database db = await this.db;
    var result = await db
        .rawQuery("SELECT * FROM $tblToDoItem WHERE $colTdiToDoListId = $tdlId"); //possibly need ordering
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.db;
    var result = Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT (*) from $tblToDoItem"));
    return result;
  }

  Future<int> updateTodo(ToDoItem todo) async {
    var db = await this.db;
    var result = await db.update(tblToDoItem, todo.toMap(),
        where: "$colTdiId = ? ",
        whereArgs: [todo.id]); //why is id in an array??
    return result;
  }

  Future<int> deleteTodo(int id) async {
    int result;
    var db = await this.db;
    result =
        await db.rawDelete('DELETE FROM $tblToDoItem WHERE $colTdiId = $id');
    return result;
  }
}
