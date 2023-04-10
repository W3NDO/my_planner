import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:select_form_field/select_form_field.dart';

import '../utils/local_storage_service.dart';
import '../utils/date_time_helpers.dart';

class NewTaskScreen extends StatefulWidget {
  static String id = "Home_screen";
  static const routeName = '/home';
  const NewTaskScreen({Key? key}) : super(key: key);

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  late Box userBox;

  void doNothing() => {};

  @override
  void initState() {
    super.initState();
    createOpenBox();
  }

  void createOpenBox() async {
    userBox = await LocalStorageService.openBox('userBox');
  }

  final _formKey = GlobalKey<FormState>();
  final highDescriptionController = TextEditingController();
  final dayController = TextEditingController();
  List<TextEditingController> taskListControllers = [];
  final DateTime daySelected = DateTime.now();
  Map<dynamic, dynamic> dayTasks = {};

  void saveTask() {
    List subTasks = [];
    Map<dynamic, dynamic> task = {};
    taskListControllers.forEach((element) {
      subTasks.add(element.text);
    });

    task[highDescriptionController.text] = {
      "day": DateTimeHelpers.dayToInt[dayController.text],
      "subTasks": subTasks
    };

    String key = DateTimeHelpers.getWeekDates(
            byNum: true, num: DateTimeHelpers.dayToInt[dayController.text]!)
        .toString();

    List temp = userBox.get(key) ?? [];
    temp.add(task);
    userBox.put(key, temp);
    setState(() {});

    Navigator.pop(context);
  }

  //date time stuff
  DateTime today = DateTime.now();

  List<Map<String, dynamic>> dayPickerOptions = [
    {"value": "Monday", "icon": Icon(Icons.more_time_rounded)},
    {"value": "Tuesday", "icon": Icon(Icons.more_time_rounded)},
    {"value": "Wednesday", "icon": Icon(Icons.more_time_rounded)},
    {"value": "Thursday", "icon": Icon(Icons.more_time_rounded)},
    {"value": "Friday", "icon": Icon(Icons.more_time_rounded)},
    {"value": "Saturday", "icon": Icon(Icons.more_time_rounded)},
    {"value": "Sunday", "icon": Icon(Icons.more_time_rounded)},
  ];

  void _addController() {
    TextEditingController controller = TextEditingController();
    setState(() {
      taskListControllers.add(controller);
    });
  }

  void _removeController(int index) {
    setState(() {
      taskListControllers.removeAt(index);
    });
  }

  void _reorder(int oldIndex, int newIndex) {
    setState(() {
      TextEditingController controller = taskListControllers.removeAt(oldIndex);
      if (newIndex > oldIndex) newIndex -= 1;
      taskListControllers.insert(newIndex, controller);
    });
  }

  Widget taskListBuilder() {
    return Expanded(
        child: ListView(
      children: [
        ...taskListControllers.asMap().entries.map((entry) {
          int index = entry.key;
          TextEditingController controller = entry.value;
          return Row(
            children: [
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.all(5),
                      child: TextFormField(
                        autofocus: true,
                        controller: controller,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText:
                              'Add an action that would complete this task',
                        ),
                      ))),
              IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => _removeController(index)),
            ],
          );
        }),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("New Task")),
        body: Form(
            key: _formKey,
            child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: highDescriptionController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter a High level description of your task',
                      ),
                      autofocus: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please specify a High Level Description for your task';
                        }
                        return null;
                      },
                    ),
                    SelectFormField(
                        controller: dayController,
                        type: SelectFormFieldType.dropdown,
                        icon: Icon(Icons.more_time_rounded),
                        labelText: "Day of Week",
                        items: dayPickerOptions,
                        onChanged: (val) => {print(dayController.text)},
                        onSaved: (val) => {print(dayController.text)}),
                    taskListBuilder(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            child: Row(
                                children: [Icon(Icons.add), Text("SubTask")]),
                            onPressed: () => _addController()),
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () => saveTask(),
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save),
                            Text(
                              "Save Task",
                              style: TextStyle(fontSize: 18),
                            )
                          ],
                        )))
                  ],
                ))));
  }
}
