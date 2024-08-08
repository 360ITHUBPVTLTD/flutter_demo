import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'session_provider.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'read_page.dart';
import 'create_page.dart';
import 'update_page.dart';
import 'delete_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SessionProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/read': (context) => ReadPage(),
        '/create': (context) => CreatePage(),
        '/update': (context) => UpdatePage(),
        '/delete': (context) => DeletePage(),
      },
    );
  }
}
