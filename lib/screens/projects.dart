import 'package:flutter/material.dart';
import 'package:testdo/model/project.dart';
import 'package:testdo/screens/projectToDoLists.dart';
import 'package:testdo/util/dbhelper.dart';

class ProjectList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProjectListState();
}

class ProjectListState extends State {
  DbHelper helper = DbHelper();
  TextEditingController _c = new TextEditingController();
  List<Project> projects;
  int count;

  @override
  Widget build(BuildContext context) {
    if (projects == null) {
      setState(() {
        projects = List<Project>();
      });
      getData();
    }
    return Scaffold(
      body: projects.length == 0
          ? Center(child: Text('Add a project'))
          : projectList(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            print('Clicked add project!');
            showDialog(
                context: context,
                builder: (_) => SimpleDialog(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: TextField(
                            controller: _c,
                            decoration: InputDecoration(
                                labelText: 'Project Name',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                          ),
                        ),
                        RaisedButton(
                          color: Theme.of(context).primaryColor,
                          child: Text('Add Project'),
                          onPressed: () {
                            print('Hit add project button!');
                            createProject(new Project(_c.text));
                            Navigator.pop(context);
                            setState(() {
                              _c.text = ''; //reset state
                            });
                          },
                        )
                      ],
                    ));
          },
          tooltip: 'Add new Project',
          child: Icon(Icons.add)),
    );
  }

  ListView projectList() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: Text(this.projects[position].name),
              onTap: () {
                print('Hit Project $position');
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return new Scaffold(
                    appBar: AppBar(
                      title: new Text(this.projects[position].name)
                    ),
                    body: ProjectToDoLists(proj: this.projects[position])
                  );
                }));
              },
            )
        );
      },
    );
  }

  void createProject(Project proj) {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final projectFuture = helper.insertProject(proj);
      projectFuture.then((p) {
        getData();
      });
    });
  }

  void getData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final projectsFuture = helper.getProjects();
      projectsFuture.then((proj) {
        List<Project> projList = List<Project>();
        int iCount = proj.length;
        for (var p in proj) {
          projList.add(Project.fromObject(p));
        }
        setState(() {
          projects = projList;
          count = iCount;
        });
      });
    });
  }
}
