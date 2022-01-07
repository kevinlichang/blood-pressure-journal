import 'package:flutter/material.dart';
import '../widgets/drawer_listview.dart';

class JournalScaffold extends StatelessWidget{
  final String title;
  final Widget child;
  JournalScaffold({Key? key, required this.title, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      endDrawer: Drawer(child: DrawerView()),
      body: child,
      floatingActionButton: floatingAddButton(context),
    );
  }
}

Widget floatingAddButton(BuildContext context) {
  return FloatingActionButton(
    onPressed: () => Navigator.pushNamed(context, '/addNew'),
    child: const Icon(Icons.add),
  );
}
