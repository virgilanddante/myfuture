import 'package:flutter/material.dart';
import 'package:myfuture/modules/category.dart';
import 'package:myfuture/repositories/repository.dart';

class CategoryService {
  late Repository _repository;

  CategoryService() {
    _repository = Repository();
  }
  saveCategory(Category category) async {
    return await _repository.insertData('categories', category.categoryMap());
  }

  readCategory() async {
    return await _repository.readData('categories');
  }

  readCategoryById(categoryId) async {
    return await _repository.readDataById('categories', categoryId);
  }

  updateCategory(Category category) async {
    return await _repository.updateData('categories', category.categoryMap());
  }

  deleteCategory(categoryId) async {
    return await _repository.deleteData('categories', categoryId);
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
