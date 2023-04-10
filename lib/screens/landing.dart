import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_planner/screens/new_task.dart';

import '../utils/local_storage_service.dart';
import '../utils/date_time_helpers.dart';

class LandingScreen extends StatefulWidget {
  static String id = "Landing_screen";
  static const routeName = '/Landing';
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  late Box userBox;
  List dates = DateTimeHelpers.allDatesForWeek();
  Map<dynamic, dynamic> tasksList = {};

  @override
  void initState() {
    super.initState();
    createOpenBox();
  }

  void reloadTasks() {
    setState(() {
      dates.forEach((element) =>
          {tasksList[element.toString()] = (userBox.get(element.toString()))});
    });
  }

  Future<void> reloadApp() async {
    reloadTasks();
  }

  void createOpenBox() async {
    userBox = await Hive.box('userBox');
    reloadTasks();
  }

  Widget taskListView(List value) {
    return ListView(children: []);
  }

  void doNothing() {}
  DateTime today = DateTime.now();

  List<Widget> dayList(Map<dynamic, dynamic> days) {
    List<Widget> tiles = [];
    days.forEach((key, value) => {
          if (value != null)
            {
              tiles.add(ListTile(
                  title: Text(
                      DateTimeHelpers.intToDay[DateTime.parse(key).weekday]!,
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)))),
              taskListView(value)
            }
        });
    reloadTasks();
    return tiles;
  }

  Widget TaskList({Map tasks = const {}}) {
    Widget list = (tasks.isEmpty || tasks == null)
        ? Center(
            child: Text("No Tasks planned yet", style: TextStyle(fontSize: 18)),
          )
        : ListView(
            children: dayList(tasksList),
          );
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('My Tasks')),
        floatingActionButton: ElevatedButton(
          child: Icon(Icons.add),
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => NewTaskScreen())),
        ),
        body: RefreshIndicator(
            onRefresh: reloadApp, child: TaskList(tasks: tasksList)));
  }
}
