import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:blood_pressure_journal/widgets/journal_scaffold.dart';
import 'package:blood_pressure_journal/models/journal.dart';
import 'package:blood_pressure_journal/models/journal_entry_fields.dart';
import 'package:blood_pressure_journal/widgets/welcome.dart';
import 'package:blood_pressure_journal/widgets/layout_widgets.dart';

class JournalEntriesListScreen extends StatefulWidget {
  const JournalEntriesListScreen({Key? key}) : super(key: key);

  @override
  JournalEntriesListScreenState createState() =>
      JournalEntriesListScreenState();
}

class JournalEntriesListScreenState extends State<JournalEntriesListScreen> {
  Journal journal = Journal(entries: []);
  JournalEntryFields currentEntry = JournalEntryFields();

  @override
  void initState() {
    super.initState();
    loadJournal();
  }

  void loadJournal() async {
    // await deleteDatabase(
    // join(await getDatabasesPath(), 'bp_journal.sqlit3.db'));

    String schema = await rootBundle.loadString('assets/schema_1.sql.txt');

    final database = await openDatabase(
      join(await getDatabasesPath(), 'bp_journal.sqlit3.db'),
      onCreate: (db, version) {
        return db.execute(schema);
      },
      version: 1,
    );

    List<Map> journalRecords = await database
        .rawQuery('SELECT * FROM journal_entries ORDER BY date DESC');

    final journalEntries = journalRecords.map((record) {
      return JournalEntryFields(
          id: record['id'],
          date: DateTime.parse(record['date']),
          systolicBP: record['systolicBP'],
          diastolicBP: record['diastolicBP'],
          pulse: record['pulse'],
          comments: record['comments']);
    }).toList();

    setState(() {
      journal = Journal(entries: journalEntries);
      currentEntry = journal.entries[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return JournalScaffold(
      title: journal.isEmpty() ? 'Hello' : 'BP Journal',
      child: journal.isEmpty()
          ? welcome(context)
          : LayoutDecider(
              leftScreen: journalList(context, journal),
              rightScreen: horizontalDetails(context, currentEntry)),
    );
  }

  Widget journalList(BuildContext context, Journal journal) {
    return ListView.separated(
      itemCount: journal.entries.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
              '${journal.entries[index].systolicBP} / ${journal.entries[index].diastolicBP}'),
          subtitle: Text(
              '${DateFormat.yMMMMEEEEd().add_jm().format(journal.entries[index].date)}'),
          onTap: () {
            if (MediaQuery.of(context).orientation == Orientation.landscape) {
              setState(() {
                currentEntry = journal.entries[index];
              });
            } else {
              Navigator.pushNamed(context, '/details',
                  arguments: journal.entries[index]);
            }
          },
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          color: Colors.grey,
          indent: 10,
          endIndent: 10,
        );
      },
    );
  }

  Widget horizontalDetails(BuildContext context, JournalEntryFields entry) {
    return Column(
      children: [
        Row(children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Text('${entry.systolicBP}',
                  style: Theme.of(context).textTheme.headline4),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Text('Systolic',
                  style: Theme.of(context).textTheme.headline4),
            ),
          ),
        ]),
        Row(children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Text('${entry.diastolicBP}',
                  style: Theme.of(context).textTheme.headline4),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Text('Diastolic',
                  style: Theme.of(context).textTheme.headline4),
            ),
          ),
        ]),
        Row(children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                '${entry.pulse}',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                'Pulse',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          )
        ]),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.all(5),
              child: Text('${entry.comments}'),
            )
          ],
        )
      ],
    );
  }
}
