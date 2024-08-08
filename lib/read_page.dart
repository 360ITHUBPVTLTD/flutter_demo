import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'session_provider.dart';

class ReadPage extends StatefulWidget {
  @override
  _ReadPageState createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  final TextEditingController _productIdController = TextEditingController();
  String _response = '';

  Future<void> _fetchProductData() async {
    final productId = _productIdController.text;
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);

    if (productId.isEmpty) {
      setState(() {
        _response = 'Please enter a Product ID';
      });
      return;
    }

    final url = Uri.parse('http://lsa.local:8016/api/resource/Product/$productId');

    // Encode the credentials to Base64 for Basic Authentication
    final encodedCredentials = base64Encode(utf8.encode(sessionProvider.apiToken));

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Basic $encodedCredentials',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final encoder = JsonEncoder.withIndent('  '); // Add indentation
      setState(() {
        _response = 'Product Fetched successfully:\n${encoder.convert(data)}';
      });
    } else {
      setState(() {
        _response = 'Error: ${response.statusCode} ${response.reasonPhrase}\n${response.body}';
      });
      print('Response body: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(
        appBar: AppBar(
          title: Text('Read Product Data'),
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
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _productIdController,
                decoration: InputDecoration(labelText: 'Product ID'),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchProductData,
                child: Text('Fetch Data'),
              ),
              SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(_response),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
