import 'package:testdo/model/todoItem.dart';

class ToDoList {
  int _id;
  String _name;
  int _projectId;

  ToDoList(this._name, this._projectId);
  ToDoList.withId(this._id, this._name, this._projectId);

  //getters
  int get id => this._id;
  String get name => this._name;
  int get projectId => this._projectId;

  //setters
  set name(String n) {
    _name = n;
  }

  //override map and fromObject
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["name"] = _name;
    map["projectId"] = _projectId;
    if (_id != null) {
      map["id"] = _id;
    }

    return map;
  }

  ToDoList.fromObject(dynamic o) {
    this._id = o["id"];
    this._name = o["name"];
    this._projectId = o["projectId"];
  }
}
