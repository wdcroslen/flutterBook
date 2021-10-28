import 'package:flutter/material.dart';
import 'package:flutterbook/notes/notes.dart';

void main() {
  runApp(FlutterBook());
}

class _Dummy extends StatelessWidget {
  final _title;

  _Dummy(this._title);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(_title));
  }
}

class FlutterBook extends StatelessWidget {
  final List _TABS = [
    {'icon': Icons.date_range, 'name': 'William'},
    {'icon': Icons.contacts, 'name': 'Croslen'},
    {'icon': Icons.note, 'name': 'Utep'},
    {'icon': Icons.assignment_turned_in, 'name': 'Student'},
  ];

  List<IconData> icon_list = [
    Icons.date_range,
    Icons.contacts,
    Icons.note,
    Icons.assignment_turned_in
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue),
        home: DefaultTabController(
            length: _TABS.length, // 4
            child: Scaffold(
                appBar: AppBar(
                    title: Text('FlutterBook'),
                    bottom: TabBar(tabs: _TABS.map((tab) =>
                        Tab(icon: Icon(tab['icon']),
                            text: tab['name'].toString())).toList())
                ),
//                body: TabBarView(
//                  children: _TABS.map((tab) => _Dummy(tab['name'])).toList(),
//                )
                body: TabBarView(
                    children: [
                      _Dummy('Appointments'),
                      _Dummy('Contacts'),
                      _Dummy('notes'),
//                      Notes(),
                      _Dummy('Tasks')]
                )
            )
        )
    );
  }
}

