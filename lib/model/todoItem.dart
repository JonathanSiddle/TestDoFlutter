class ToDoItem {
  int _id;
  String _name;
  int _toDoListId;
  bool _complete;

  ToDoItem(this._name, this._toDoListId, this._complete);
  ToDoItem.withId(this._id, this._name, this._toDoListId, [this._complete]);

  int get id => this._id;
  String get title => this._name;
  int get toDoListId => this._toDoListId;
  bool get complete => this._complete;

  set title(String newName) {
    if (newName.length <= 255) {
      _name = newName;
    }
  }

  set complete(bool done) {
    _complete = done;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["name"] = _name;
    map["toDoListId"] = toDoListId;
    map["complete"] = _complete;
    if (_id != null) {
      map["id"] = _id;
    }

    return map;
  }

  ToDoItem.fromObject(dynamic o) {
    this._id = o["id"];
    this._toDoListId = o["toDoListId"];
    this._name = o["name"];
    if (o["complete"] is int) {
      if (o["complete"] == 1) {
        this._complete = true;
      } else {
        this._complete = false;
      }
    } else {
      this._complete = o["complete"]; //will be stored as in in db...
    }
  }
}
