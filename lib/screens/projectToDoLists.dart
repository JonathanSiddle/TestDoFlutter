import 'package:flutter/material.dart';
import 'package:testdo/model/project.dart';
import 'package:testdo/model/todolist.dart';
import 'package:testdo/screens/todolist.dart';
import 'package:testdo/util/dbhelper.dart';

class ProjectToDoLists extends StatefulWidget {
  final Project proj;

  ProjectToDoLists({Key key, @required this.proj}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ProjectToDoListsState(proj);
}

class ProjectToDoListsState extends State {
  final Project proj;
  DbHelper helper = DbHelper();
  TextEditingController _c = new TextEditingController();
  List<ToDoList> toDoLists;
  int count;

  ProjectToDoListsState(this.proj);

  @override
  Widget build(BuildContext context) {
    print(proj);
    if (toDoLists == null) {
      setState(() {
        toDoLists = List<ToDoList>();
      });
      getData();
    }
    return Scaffold(
      body: toDoLists.length == 0
          ? Center(child: Text('Add a ToDo List'))
          : toDoListList(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add a new ToDo List',
        child: Icon(Icons.add),
        onPressed: () {
          showCreateTdlDialog();
        },
      ),
    );
  }

  ListView toDoListList() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            title: Text(this.toDoLists[position].name),
            onTap: () {
              print('Hit ToDo List $position');
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return new Scaffold(
                    appBar: AppBar(
                      title: Text(this.toDoLists[position].name),
                    ),
                    body: ToDoItems(tdl: this.toDoLists[position]));
              }));
            },
          ),
        );
      },
    );
  }

  void createToDoList(ToDoList tdl) {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      print('inserting tdl');
      final tdlFuture = helper.insertToDoList(tdl);
      tdlFuture.then((tdl) {
        print('Getting data after adding tdl');
        getData();
      });
    });
  }

  void getData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final toDoListFuture = helper.getToDoLists(proj.id);
      toDoListFuture.then((tdlList) {
        List<ToDoList> tdls = List<ToDoList>();
        int iCount = tdlList.length;
        for (var tdl in tdlList) {
          tdls.add(ToDoList.fromObject(tdl));
        }
        setState(() {
          toDoLists = tdls;
          count = iCount;
        });
      });
    });
  }

  showCreateTdlDialog() {
    print('Showing Create TDL dialog');
    showDialog(
        context: context,
        builder: (_) => SimpleDialog(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: TextField(
                    controller: _c,
                    decoration: InputDecoration(
                        labelText: 'ToDo List Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text('Add ToDoList'),
                  onPressed: () {
                    print('Hit add tdl button!');
                    createToDoList(ToDoList(_c.text, proj.id));
                    Navigator.pop(context);
                    setState(() {
                      _c.text = ''; //reset state
                    });
                  },
                )
              ],
            ));
  }
}
