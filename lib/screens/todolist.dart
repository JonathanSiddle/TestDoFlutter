import 'package:flutter/material.dart';
import 'package:testdo/model/todoItem.dart';
import 'package:testdo/util/dbhelper.dart';

class ToDoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ToDoListState();
}

class ToDoListState extends State {
  DbHelper helper = DbHelper();
  List<ToDoItem> todos;
  int count;

  @override
  Widget build(BuildContext context) {
    if (todos == null) {
      todos = List<ToDoItem>();
      getData();
    }
    return Scaffold(
      body: todos.length == 0
          ? Center(child: Text('Add some ToDo Items!'))
          : todoListItems(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("Hit action button!! Woop woop!");
            helper.initializeDb();

            ToDoItem td1 = new ToDoItem("Buy stuff", 1, false);
            ToDoItem td2 = new ToDoItem("Sell other stuff", 1, false);

            var result = helper.insertTodoItem(td1);
            var result2 = helper.insertTodoItem(td2);
            // print("Results $result, $result2");
            getData();
          },
          tooltip: "Add new ToDO",
          child: Icon(Icons.add)),
    );
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

  void getData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final todosFuture = helper.getToDos();
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
