import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_planner/screens/home.dart';
import 'package:my_planner/utils/local_storage_service.dart';

late Box userBox;
void main() async {
  await Hive.initFlutter();
  userBox = await LocalStorageService.openBox('userBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const initialScreenValue = HomeScreen.routeName;
    return MaterialApp(
      title: 'My Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      initialRoute: initialScreenValue,
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
      },
      home: const HomeScreen(),
    );
  }
}
