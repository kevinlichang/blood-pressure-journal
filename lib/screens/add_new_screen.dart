import 'package:flutter/material.dart';
import '../widgets/drawer_listview.dart';
import 'package:blood_pressure_journal/widgets/journal_entry_form.dart';

class AddNewScreen extends StatelessWidget {
  const AddNewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
        title: const Text('Add New Journal Entry'),
        centerTitle: true,
      ),
      endDrawer: Drawer(child: DrawerView()),
      body: JournalEntryForm(),
    );
  }
}
