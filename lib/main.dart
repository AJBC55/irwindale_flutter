import 'package:flutter/material.dart';
import 'package:irwindale_flutter/about.dart';
import 'maps.dart';
import 'login.dart';
import 'events.dart';
import 'register.dart';
import 'loading_screen.dart'; // Import the LoadingScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => LoadingScreen(), // Initial route
        '/home': (context) => HomeScreen(), // Home route
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        body: TabBarView(
          children: [
            EventsScreen(),
            MapView(),
            AboutView()
          ],
        ),
        bottomNavigationBar: Material(
          child: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.list), text: 'Events'),
              Tab(icon: Icon(Icons.map_outlined), text: 'Map'),
              Tab(icon: Icon(Icons.bookmark_border_outlined), text: "About")
            ],
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
