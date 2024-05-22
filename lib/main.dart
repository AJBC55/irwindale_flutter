import 'package:flutter/material.dart';
import 'maps.dart';
import 'login.dart';
import 'events.dart';
import 'register.dart';

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
        length: 2, // Number of tabs
        child: Scaffold(
          body: TabBarView(
            children: [
              EventsScreen(),
              MapView(),
            ],
          ),
          bottomNavigationBar: Material(
            child: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.list), text: 'Events'),
                Tab(icon: Icon(Icons.map_outlined), text: 'Map'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        Widget page = LoginView(); // Default page
        if (settings.name == '/register') {
          page = RegisterView();
        }
        return MaterialPageRoute(builder: (_) => page);
      },
    );
  }
}
