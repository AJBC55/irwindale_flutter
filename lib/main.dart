import 'package:flutter/material.dart';
import 'maps.dart';
import 'login.dart';
import 'auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3, // Number of tabs
        child: Scaffold(
          body: TabBarView(
            children: [
              EventsScreen(),
              MapView(),
              LoginView(),
            ],
          ),
          bottomNavigationBar: Material(
            child: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.list), text: 'Events'),
                Tab(icon: Icon(Icons.map_outlined), text: 'Map'),
                Tab(icon: Icon(Icons.person_2), text: 'Settings'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
