import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:blood_pressure_journal/screens/add_new_screen.dart';
import 'package:blood_pressure_journal/screens/journal_entry_listview.dart';
import 'package:blood_pressure_journal/screens/entry_details.dart';

class App extends StatefulWidget {
  static final routes = {
    '/': (context) => JournalEntriesListScreen(),
    '/addNew': (context) => AddNewScreen(),
    '/details': (context) => DetailsScreen()
  };

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  var themeChoice;

  @override
  void initState() {
    super.initState();
    initTheme();
  }

  void initTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? darkModeBool = prefs.getBool('dark_mode');
    setState(() {
      if (darkModeBool == null) {
        themeChoice = ThemeData.light();
      } else {
        setTheme(darkModeBool);
      }
    });
  }

  //update Theme choice
  Future<void> updateTheme(bool darkModeBool) async {
    setState(() {
      setTheme(darkModeBool);
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('dark_mode', darkModeBool);
  }

  ThemeData getTheme() => themeChoice;

  void setTheme(bool darkModeBool) {
    if (darkModeBool == true) {
      themeChoice = ThemeData.dark();
    } else {
      themeChoice = ThemeData.light();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Pressure Journal',
      theme: themeChoice,
      routes: App.routes,
    );
  }
}
