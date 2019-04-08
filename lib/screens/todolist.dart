import 'package:flutter/material.dart';
import 'package:testdo/model/todoItem.dart';
import 'package:testdo/model/todolist.dart';
import 'package:testdo/util/dbhelper.dart';

class ToDoItems extends StatefulWidget {
  final ToDoList tdl;

  ToDoItems({Key key, @required this.tdl}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ToDoItemState(tdl);
}

class ToDoItemState extends State {
  final ToDoList tdl;
  DbHelper helper = DbHelper();
  TextEditingController _c = new TextEditingController();
  List<ToDoItem> todos;
  int count;

  ToDoItemState(this.tdl);

  @override
  Widget build(BuildContext context) {
    if (todos == null) {
      todos = List<ToDoItem>();
      getData();
    }
    return Scaffold(body: getBody()
        //getBody(),
        // floatingActionButton: FloatingActionButton(
        //     onPressed: () {
        //       print("Hit action button!! Woop woop!");
        //       helper.initializeDb();

        //       ToDoItem td1 = new ToDoItem("Buy stuff", 1, false);
        //       ToDoItem td2 = new ToDoItem("Sell other stuff", 1, false);

        //       var result = helper.insertTodoItem(td1);
        //       var result2 = helper.insertTodoItem(td2);
        //       // print("Results $result, $result2");
        //       getData();
        //     },
        //     tooltip: "Add new ToDO",
        //     child: Icon(Icons.add)),
        );
  }

  Widget getBody() {
    return Column(children: <Widget>[
      topComponent(),
      todos.length == 0
          ? Center(child: Text('Add some ToDo Items!'))
          : Expanded(child: todoListItems())
    ]);
  }

  Widget topComponent() {
    return Row(children: <Widget>[
      Expanded(
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: TextField(
            controller: _c,
            decoration: InputDecoration(
                labelText: 'ToDo Item',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0))),
          ),
        ),
      ),
      Container(width: 5.0 * 5),
      Expanded(
          child: Padding(
              padding: EdgeInsets.all(5.0),
              child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text('Add'),
                  onPressed: () {
                    print('Clicked Add button');
                    //do more validation here
                    createToDoItem(ToDoItem(_c.text, tdl.id, false));
                  })))
    ]);
  }

  ListView todoListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red,
              child: Text(this.todos[position].id.toString()),
            ),
            title: Text(this.todos[position].title),
            onTap: () {
              debugPrint("Tapped on $position");
            },
          ),
        );
      },
    );
  }

  void createToDoItem(ToDoItem tdi) {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final tdiFuture = helper.insertTodoItem(tdi);
      tdiFuture.then((tdl) {
        getData();
      });
    });
  }

  void getData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final todosFuture = helper.getToDos(tdl.id);
      todosFuture.then((todosResult) {
        List<ToDoItem> todoList = List<ToDoItem>();
        int itemsCount = todosResult.length;
        for (var td in todosResult) {
          todoList.add(ToDoItem.fromObject(td));
        }
        setState(() {
          todos = todoList;
          count = itemsCount;
        });
      });
    });
  }
}
