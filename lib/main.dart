import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'session_provider.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'read_page.dart';
import 'create_page.dart';
import 'update_page.dart';
import 'delete_page.dart';
import 'guarded_page.dart';

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
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => GuardedPage(child: HomePage()),
        '/read': (context) => GuardedPage(child: ReadPage()),
        '/create': (context) => GuardedPage(child: CreatePage()),
        '/update': (context) => GuardedPage(child: UpdatePage()),
        '/delete': (context) => GuardedPage(child: DeletePage()),
      },
    );
  }
}
