import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'session_provider.dart';

class CreatePage extends StatefulWidget {
  @override
  CreatePageState createState() => CreatePageState();
}

class CreatePageState extends State<CreatePage> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productTypeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _activeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _response = '';

  Future<void> _createProduct() async {
    final productName = _productNameController.text;
    final productType = _productTypeController.text;
    final price = _priceController.text;
    final active = _activeController.text;
    final description = _descriptionController.text;

    if (productName.isEmpty || productType.isEmpty || price.isEmpty) {
      setState(() {
        _response = 'Please enter all required fields (Product Name, Type, and Price)';
      });
      return;
    }

    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final url = Uri.parse('http://lsa.local:8016/api/resource/Product');

    // Encode the credentials to Base64 for Basic Authentication
    final encodedCredentials = base64Encode(utf8.encode(sessionProvider.apiToken));

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Basic $encodedCredentials',
      },
      body: jsonEncode({
        'product_name': productName,
        'type': productType,
        'price': double.tryParse(price) ?? 0.0,
        'active': active.isNotEmpty ? int.parse(active) : 0,
        'description': description,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final encoder = JsonEncoder.withIndent('  '); // Add indentation
      setState(() {
        _response = 'Product created successfully:\n${encoder.convert(data)}';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Product Data'),
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
              controller: _productNameController,
              decoration: InputDecoration(labelText: 'Product Name'),
              keyboardType: TextInputType.text,
            ),
            TextField(
              controller: _productTypeController,
              decoration: InputDecoration(labelText: 'Type (Apparel, Gadgets, etc.)'),
              keyboardType: TextInputType.text,
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _activeController,
              decoration: InputDecoration(labelText: 'Active (0 or 1)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createProduct,
              child: Text('Create Product'),
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
