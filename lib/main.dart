import 'dart:ffi';
import 'package:flutter/services.dart';
import 'components/activity_form.dart';
import 'package:flutter/material.dart';
import 'components/activity_list.dart';
import 'models/activity.dart';
import 'dart:math';

main() => runApp(const ExpensesApp());

class ExpensesApp extends StatelessWidget {
  const ExpensesApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
        home: const MyHomePage(),
        theme: ThemeData(
            primarySwatch: Colors.indigo,
            fontFamily: 'QuickSand',
            appBarTheme: const AppBarTheme(
                color: Colors.indigo,
                titleTextStyle: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            buttonTheme: const ButtonThemeData(buttonColor: Colors.white),
            colorScheme:
                ColorScheme.fromSwatch().copyWith(secondary: Colors.amber)));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Activity> _activities = [];

  List<Activity> get _recentActivities {
    return _activities.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        const Duration(days: 7),
      ));
    }).toList();
  }

  _addActivity(String title, bool active, DateTime date) {
    final newActivity = Activity(
      id: Random().nextDouble().toString(),
      title: title,
      active: active,
      date: date,
    );

    setState(() {
      _activities.add(newActivity);
    });

    Navigator.of(context).pop();
  }

  _openActivityFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ActivityForm(_addActivity);
      },
    );
  }

  _removeActivity(String id) {
    setState(() {
      _activities.removeWhere((tr) => tr.id == id);
    });
  }

  _alterActivityActive(String id) {
    Activity activityToUpdate = _activities.firstWhere((activity) => activity.id == id);

    if (activityToUpdate != null) {
      setState(() {
        activityToUpdate.active = !activityToUpdate.active;
      });
    }
  }

  _alterActivity(Activity activityUpdate) {
    Activity activityToUpdate = _activities.firstWhere((activity) => activity.id == activityUpdate.id);

    if (activityToUpdate != null) {
      setState(() {
        activityToUpdate.title = activityUpdate.title;
        activityToUpdate.active = activityUpdate.active;
        activityToUpdate.date = activityUpdate.date;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(
        'Lista de tarefas',
        style: TextStyle(fontSize: 20 * MediaQuery.of(context).textScaleFactor),
      ),
      actions: [
        IconButton(
            onPressed: () => _openActivityFormModal(context),
            icon: const Icon(Icons.add))
      ],
    );
    final availableHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: availableHeight * 0.7,
                child: ActivityList(_activities, _removeActivity, _alterActivityActive, _alterActivity),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () => _openActivityFormModal(context),
            child: const Icon(Icons.add)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
