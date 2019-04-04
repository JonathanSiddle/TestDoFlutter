import 'package:testdo/model/todoItem.dart';

class ToDoList {
  int _id;
  String _name;
  int _projectId;
  List<ToDoItem> _items;

  //getters
  int get id => this._id;
  String get name => this._name;
  int get projectId => this._projectId;
  List<ToDoItem> get toDos => this._items;

  //setters
  set name(String n) {
    _name = n;
  }

  set items(List<ToDoItem> items) {
    _items = items;
  }

  //override map and fromObject
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["name"] = _name;
    map["projectId"] = _projectId;
    map["toDos"] = _items;
    if (_id != null) {
      map["id"] = _id;
    }

    return map;
  }

  ToDoList.fromObject(dynamic o) {
    this._id = o["id"];
    this._name = o["name"];
    this._projectId = o["projectId"];
    this._items = o["items"];
  }
}
