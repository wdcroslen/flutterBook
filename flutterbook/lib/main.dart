import 'package:flutter/material.dart';
import 'package:flutterbook/grids/grid.dart';
import 'package:flutterbook/notes/notes.dart';
import 'package:flutterbook/tasks/tasks.dart';
import 'package:flutterbook/contacts/contacts.dart';
import 'package:flutterbook/grids/charts.dart';
import 'package:flutterbook/grids/grid_entry.dart';
import 'package:flutterbook/appointments/appointments.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'contacts/avatar.dart';

void main() async {
  // startMeUp() async {
    //WidgetsFlutterBinding.ensureInitialized();
    //Avatar.docsDir = await getApplicationDocumentsDirectory();
    runApp(FlutterBook());
  // }
  // startMeUp();
  // runApp(FlutterBook());
}

class FlutterBook extends StatelessWidget {
  final List _TABS = [
    {'icon': Icons.date_range, 'name': 'Appointments'},
    {'icon': Icons.contacts, 'name': 'Contacts'},
    {'icon': Icons.note, 'name': 'Notes'},
    {'icon': Icons.assignment_turned_in, 'name': 'Tasks'},
    {'icon': Icons.shopping_cart, 'name': 'Shopping'},
  ];

  List<IconData> icon_list = [
    Icons.date_range,
    Icons.contacts,
    Icons.note,
    Icons.assignment_turned_in,
    Icons.shopping_cart,
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
                      Appointments(),
                      //_Dummy('Appointments'),
                      Contacts(),
                      // _Dummy('Contacts'),
//                      _Dummy('notes'),
                      Notes(),
                      Tasks(),
                    // Sliders()
                    GridPage()
                    ]
//                      _Dummy('Tasks')]
                )
            )
        )
    );
  }
}

