import 'package:flutter/material.dart';
import 'package:myfuture/screens/home_screens.dart';
import 'package:myfuture/screens/categories_screen.dart';

class DrawerNavigation extends StatefulWidget {
  const DrawerNavigation({super.key});

  @override
  State<DrawerNavigation> createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        backgroundColor: Colors.grey[800],
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.white,
              ),
              title: Text('Home'),
              textColor: Colors.white,
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomeScreen())),
            ),
            ListTile(
              leading: Icon(
                Icons.list_alt,
                color: Colors.white,
              ),
              title: Text('Categories'),
              textColor: Colors.white,
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CategoriesScreen())),
            ),
          ],
        ),
      ),
    );
  }
}
