import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:my_planner/screens/landing.dart';
import 'package:my_planner/utils/local_storage_service.dart';

class HomeScreen extends StatefulWidget {
  static String id = "Home_screen";
  static const routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // late Box userBox;

  // initState() {
  //   super.initState();
  //   createOpenBox();
  // }

  // void createOpenBox() async {
  //   userBox = await LocalStorageService.openBox('userBox');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LandingScreen());
  }
}
