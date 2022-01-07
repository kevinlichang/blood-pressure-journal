import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:blood_pressure_journal/models/journal_entry_fields.dart';

class JournalEntryForm extends StatefulWidget {
  const JournalEntryForm({Key? key}) : super(key: key);

  @override
  JournalEntryFormState createState() => JournalEntryFormState();
}

class JournalEntryFormState extends State<JournalEntryForm> {
  final _formKey = GlobalKey<FormState>();
  final journalEntryFields = JournalEntryFields();
  int selectedValue = 1;
  List<int> ratingList = [1, 2, 3, 4, 5];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a value';
                      }
                      return null;
                    },
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      journalEntryFields.systolicBP = int.parse(value!);
                    },
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Systolic',
                      border: OutlineInputBorder(),
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a value';
                      }
                      return null;
                    },
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      journalEntryFields.diastolicBP = int.parse(value!);
                    },
                    decoration: InputDecoration(
                      labelText: 'Diastolic',
                      border: OutlineInputBorder(),
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a value';
                      }
                      return null;
                    },
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      journalEntryFields.pulse = int.parse(value!);
                    },
                    decoration: InputDecoration(
                      labelText: 'Pulse',
                      border: OutlineInputBorder(),
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: TextFormField(
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please enter a value';
                    //   }
                    //   return null;
                    // },
                    onSaved: (value) {
                      journalEntryFields.comments = value!;
                    },
                    decoration: InputDecoration(
                      labelText: 'Comments (Optional)',
                      border: OutlineInputBorder(),
                    ),
                    minLines: 1,
                    maxLines: 7,
                  )),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    addDateTimeValue();

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Entry Added'),
                    ));

                    String schema =
                        await rootBundle.loadString('assets/schema_1.sql.txt');

                    final database = await openDatabase(
                      join(await getDatabasesPath(), 'bp_journal.sqlit3.db'),
                      onCreate: (db, version) {
                        return db.execute(schema);
                      },
                      version: 1,
                    );

                    await database.transaction((txn) async {
                      await txn.rawInsert(
                        'INSERT INTO journal_entries(date, systolicBP, diastolicBP, pulse, comments) VALUES(?,?,?,?,?)',
                        [
                          journalEntryFields.date.toString(),
                          journalEntryFields.systolicBP,
                          journalEntryFields.diastolicBP,
                          journalEntryFields.pulse,
                          journalEntryFields.comments
                        ],
                      );
                    });

                    await database.close();
                    Navigator.pushNamed(context, '/');
                  }
                },
                child: const Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void addDateTimeValue() {
    journalEntryFields.date = DateTime.now();
  }
}
