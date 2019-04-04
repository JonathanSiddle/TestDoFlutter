import 'package:flutter/material.dart';
import 'package:testdo/screens/projects.dart';
import 'package:testdo/screens/todolist.dart';
import 'package:testdo/util/dbhelper.dart';
import 'package:testdo/model/todoItem.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TestDo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.lightGreen,
      ),
      home: MyHomePage(title: 'TestDo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text(widget.title),
      ),
      body: ProjectList(),
    );
  }
}

//  int _counter = 0;
//  List<ToDoItem> todos = new List<ToDoItem>();

//  void _incrementCounter() {
//    setState(() {
//      // This call to setState tells the Flutter framework that something has
//      // changed in this State, which causes it to rerun the build method below
//      // so that the display can reflect the updated values. If we changed
//      // _counter without calling setState(), then the build method would not be
//      // called again, and so nothing would appear to happen.
////      DbHelper helper = DbHelper();
//////      helper.initializeDb();
////      helper.initializeDb().then((result) => helper.getToDos().then((r) {
////        print("Got list of todos!");
////        print(r);
////        for (var todo in r) {
////          var todoI = ToDoItem.fromObject(todo);
////          print("Rebuild ToDoItem: $todoI");
////          todos.add(todoI);
////        }
////      }));
//
////      DateTime today = DateTime.now();
////      ToDoItem td1 = new ToDoItem("Buy stuff", false);
////      ToDoItem td2 = new ToDoItem("Sell other stuff", false);
////
////      var result = helper.insertTodoItem(td1);
////      var result2 = helper.insertTodoItem(td2);
////      print("Results $result, $result2");
//      _counter++;
//    });
//  }