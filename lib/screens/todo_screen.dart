import 'package:flutter/material.dart';
import 'package:myfuture/modules/todo.dart';
import 'package:myfuture/screens/home_screens.dart';
import 'package:myfuture/services/category_service.dart';
import 'package:myfuture/services/todo_service.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  var todoTitleController = TextEditingController();
  var todoDescriptionController = TextEditingController();
  var _selectedValue;
  var _categories = <DropdownMenuItem>[];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  _loadCategories() async {
    var _categoryService = CategoryService();
    var categories = await _categoryService.readCategory();
    categories.forEach((category) {
      setState(() {
        _categories.add(DropdownMenuItem(
          child: Text(category['name']),
          value: category['name'],
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Todo'),
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              style: TextStyle(color: Colors.white),
              controller: todoTitleController,
              decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: "Enter Title",
                  labelStyle: TextStyle(color: Colors.white),
                  hintStyle: TextStyle(color: Colors.white)),
            ),
            TextField(
              style: TextStyle(color: Colors.white),
              controller: todoDescriptionController,
              decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: "Enter Description",
                  labelStyle: TextStyle(color: Colors.white),
                  hintStyle: TextStyle(color: Colors.white)),
            ),
            DropdownButtonFormField(
                items: _categories,
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value;
                  });
                },
                value: _selectedValue,
                hint: Text(style: TextStyle(color: Colors.white), "Category")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                var todoObject = ToDo();
                todoObject.title = todoTitleController.text;
                todoObject.description = todoDescriptionController.text;
                todoObject.isFinished = 0;
                todoObject.category = _selectedValue.toString();

                var _todoService = ToDoService();
                var result = await _todoService.saveToDo(todoObject);
                if (result > 0) {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: ((context) => HomeScreen())));
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Created')));
                }
              },
              child: Text('Save'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            )
          ],
        ),
      ),
    );
  }
}
