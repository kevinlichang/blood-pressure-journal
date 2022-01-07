import 'package:flutter/material.dart';
import 'package:blood_pressure_journal/app.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DrawerHeader(
          child: Text('Settings'),
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        ),
        DarkModeSwitch()
      ],
    );
  }
}

class DarkModeSwitch extends StatefulWidget {
  const DarkModeSwitch({Key? key}) : super(key: key);

  @override
  _DarkModeSwitchState createState() => _DarkModeSwitchState();
}

class _DarkModeSwitchState extends State<DarkModeSwitch> {
  late bool dark;

  @override
  Widget build(BuildContext context) {
    AppState? appState = context.findAncestorStateOfType<AppState>();

    if (appState!.getTheme() == ThemeData.light()) {
      dark = false;
    } else {
      dark = true;
    }

    return SwitchListTile(
      value: dark,
      title: const Text('Dark Mode'),
      onChanged: (bool value) {
        setState(() {
          dark = value;
          appState.updateTheme(dark);
        });
      },
      secondary: const Icon(Icons.nightlight_outlined),
    );
  }
}
