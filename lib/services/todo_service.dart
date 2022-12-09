import 'package:flutter/material.dart';
import 'package:myfuture/modules/todo.dart';
import 'package:myfuture/repositories/repository.dart';

class ToDoService {
  late Repository _repository;

  ToDoService() {
    _repository = Repository();
  }

  saveToDo(ToDo todo) async {
    return await _repository.insertData('todos', todo.todoMap());
  }

  readToDo() async {
    return await _repository.readData('todos');
  }

  deleteToDo(todoId) async {
    return await _repository.deleteData('todos', todoId);
  }

  changeColor(todoCategory) {
    if (todoCategory == 'Long Term') {
      return Colors.blue;
    } else if (todoCategory == 'Mid Term') {
      return Colors.orange;
    } else if (todoCategory == 'Short Term') {
      return Colors.purple;
    }
  }
}
