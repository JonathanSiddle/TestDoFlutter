import 'package:testdo/model/todolist.dart';

class Project {
  int _id;
  String _name;
  // List<ToDoList> _toDoLists;

  Project(this._name);
  Project.withId(this._id, this._name);

  //getters
  int get id => this._id;
  String get name => this._name;
  // List<ToDoList> get toDoLists => this._toDoLists;

  //setters
  set name(String n) {
    _name = n;
  }

  // set toDoLists(List<ToDoList> toDoLists) {
  //   _toDoLists = toDoLists;
  // }

  //override map and fromObject
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["name"] = _name;
    // map["toDoLists"] = _toDoLists;
    if (_id != null) {
      map["id"] = _id;
    }

    return map;
  }

  Project.fromObject(dynamic o) {
    this._id = o["id"];
    this._name = o["name"];
    // this._toDoLists = o["toDoLists"];
  }
}
