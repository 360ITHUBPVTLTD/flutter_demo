import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'session_provider.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String _selectedValue = 'Customer';

  void _navigateToPage(String page) {
    Navigator.pushNamed(
      context,
      page,
      arguments: _selectedValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);
    final sessionToken = sessionProvider.apiToken;

    // Print the session token
    print('Session Token: $sessionToken');

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateToPage('/read'),
              child: Text('Read'),
            ),
            ElevatedButton(
              onPressed: () => _navigateToPage('/create'),
              child: Text('Create'),
            ),
            ElevatedButton(
              onPressed: () => _navigateToPage('/update'),
              child: Text('Update'),
            ),
            ElevatedButton(
              onPressed: () => _navigateToPage('/delete'),
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
