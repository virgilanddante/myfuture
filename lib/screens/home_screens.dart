import 'package:flutter/material.dart';
import 'package:myfuture/modules/todo.dart';
import 'package:myfuture/screens/todo_screen.dart';
import 'package:myfuture/services/todo_service.dart';
import 'package:myfuture/helpers/drawer_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ToDoService _toDoService;
  List<ToDo> _todoList = <ToDo>[];

  getAllToDos() async {
    _toDoService = ToDoService();
    _todoList = <ToDo>[];

    var todos = await _toDoService.readToDo();
    todos.forEach((todo) {
      setState(() {
        var model = ToDo();

        model.id = todo['id'];
        model.title = todo['title'];
        model.description = todo['description'];
        model.category = todo['category'];
        model.isFinished = todo['isFinished'];

        _todoList.add(model);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getAllToDos();
  }

  _deleteFormData(BuildContext context, todoId) {
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  var result = await _toDoService.deleteToDo(todoId);
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllToDos();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Deleted')));
                  }
                },
                child: Text('Delete'),
              )
            ],
            title: Text("Do you want to delete this item?"),
          );
        },
        barrierDismissible: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Future'),
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Colors.grey[900],
      body: ListView.builder(
        itemCount: _todoList.length,
        itemBuilder: ((context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(_todoList[index].title),
                    Text(_todoList[index].description),
                    IconButton(
                        color: Colors.white,
                        onPressed: (() {
                          _deleteFormData(context, _todoList[index].id);
                        }),
                        icon: Icon(Icons.delete)),
                  ],
                ),
                subtitle: Text(_todoList[index].category),
                tileColor: _toDoService.changeColor(_todoList[index].category),
                textColor: Colors.white,
              ),
            ),
          );
        }),
      ),
      drawer: DrawerNavigation(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ToDoScreen())),
        child: Icon(Icons.add),
        backgroundColor: Colors.amber,
      ),
    );
  }
}
