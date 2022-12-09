import 'package:flutter/material.dart';
import 'package:myfuture/modules/category.dart';
import 'package:myfuture/screens/home_screens.dart';
import 'package:myfuture/services/category_service.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var _categoryNameController = TextEditingController();
  var _categoryDescriptionController = TextEditingController();
  var _category = Category();
  var _categoryService = CategoryService();

  var _editCategoryNameController = TextEditingController();
  var _editCategoryDescriptionController = TextEditingController();

  List<Category> _categoryList = <Category>[];

  var category;

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getAllCategories() async {
    _categoryList = <Category>[];
    var categories = await _categoryService.readCategory();
    categories.forEach((category) {
      setState(() {
        var categoryModel = Category();
        categoryModel.name = category['name'];
        categoryModel.description = category['description'];
        categoryModel.id = category['id'];
        _categoryList.add(categoryModel);
      });
    });
  }

  _editCategory(BuildContext context, categoryId) async {
    category = await _categoryService.readCategoryById(categoryId);
    setState(() {
      _editCategoryNameController.text = category[0]['name'] ?? 'No Name';
      _editCategoryDescriptionController.text =
          category[0]['description'] ?? 'No Description';
    });
    _editFormData(context);
  }

  _showFormDialog(BuildContext context) {
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
                  _category.name = _categoryNameController.text;
                  _category.description = _categoryDescriptionController.text;
                  var result = await _categoryService.saveCategory(_category);
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllCategories();
                  }
                },
                child: Text('Save'),
              )
            ],
            title: Text("Categories Form"),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                        hintText: 'Write a category', labelText: 'Category'),
                    controller: _categoryNameController,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: 'Write a description',
                        labelText: 'Description'),
                    controller: _categoryDescriptionController,
                  )
                ],
              ),
            ),
          );
        },
        barrierDismissible: true);
  }

  _editFormData(BuildContext context) {
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
                  _category.id = category[0]['id'];
                  _category.name = _editCategoryNameController.text;
                  _category.description =
                      _editCategoryDescriptionController.text;
                  var result = await _categoryService.updateCategory(_category);
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllCategories();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Updated')));
                  }
                },
                child: Text('Update'),
              )
            ],
            title: Text("Edit Categories Form"),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                        hintText: 'Write a category', labelText: 'Category'),
                    controller: _editCategoryNameController,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: 'Write a description',
                        labelText: 'Description'),
                    controller: _editCategoryDescriptionController,
                  )
                ],
              ),
            ),
          );
        },
        barrierDismissible: true);
  }

  _deleteFormData(BuildContext context, categoryId) {
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
                  var result =
                      await _categoryService.deleteCategory(categoryId);
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllCategories();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Deleted')));
                  }
                },
                child: Text('Delete'),
              )
            ],
            title: Text("Do you want to delete this category?"),
          );
        },
        barrierDismissible: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: ElevatedButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: ((context) => HomeScreen()))),
          child: Icon(Icons.arrow_back),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber, elevation: 0.0),
        ),
        title: Text('Categories'),
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Colors.grey[900],
      body: ListView.builder(
          itemCount: _categoryList.length,
          itemBuilder: ((context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
              child: Card(
                  elevation: 8.0,
                  child: ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.edit),
                      color: Colors.white,
                      onPressed: () {
                        _editCategory(context, _categoryList[index].id);
                      },
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(_categoryList[index].name),
                        IconButton(
                          onPressed: () {
                            _deleteFormData(context, _categoryList[index].id);
                          },
                          icon: Icon(Icons.delete),
                          color: Colors.white,
                        ),
                      ],
                    ),
                    subtitle: Text(_categoryList[index].description),
                    tileColor:
                        _categoryService.changeColor(_categoryList[index].name),
                    textColor: Colors.white,
                  )),
            );
          })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.amber,
      ),
    );
  }
}
