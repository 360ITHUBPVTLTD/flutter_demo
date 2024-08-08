import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Ensure this import is correct
import 'session_provider.dart';
import 'guarded_page.dart'; // Import the GuardedPage if needed

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Clear the _apiToken in SessionProvider
              Provider.of<SessionProvider>(context, listen: false).logout();
              // Navigate back to the login page
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/read'),
              child: Text('Read'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/create'),
              child: Text('Create'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/update'),
              child: Text('Update'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/delete'),
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
