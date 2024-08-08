import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'session_provider.dart';

class UpdatePage extends StatefulWidget {
  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final TextEditingController _productIdController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _active = false;
  bool _dataLoaded = false;
  String _response = '';

  Future<void> _fetchProductData() async {
    final productId = _productIdController.text;

    if (productId.isEmpty) {
      setState(() {
        _response = 'Please enter the Product ID';
      });
      return;
    }

    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
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
      final responseData = jsonDecode(response.body);
      final productData = responseData['data'];

      setState(() {
        _productNameController.text = productData['product_name'] ?? '';
        _typeController.text = productData['type'] ?? '';
        _priceController.text = (productData['price'] ?? 0.0).toString();
        _descriptionController.text = productData['description'] ?? '';
        _active = productData['active'] == 1;
        _dataLoaded = true;
        _response = 'Data loaded successfully';
      });
    } else {
      setState(() {
        _response = 'Error: ${response.statusCode} ${response.reasonPhrase}\n${response.body}';
      });
      print('Response body: ${response.body}');
    }
  }

  Future<void> _updateProduct() async {
    final productId = _productIdController.text;
    final productName = _productNameController.text;
    final type = _typeController.text;
    final price = _priceController.text;
    final description = _descriptionController.text;

    if (productId.isEmpty || productName.isEmpty || type.isEmpty || price.isEmpty) {
      setState(() {
        _response = 'Please enter all required fields: Product ID, Product Name, Type, and Price';
      });
      return;
    }

    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final url = Uri.parse('http://lsa.local:8016/api/resource/Product/$productId');

    // Encode the credentials to Base64 for Basic Authentication
    final encodedCredentials = base64Encode(utf8.encode(sessionProvider.apiToken));

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Basic $encodedCredentials',
      },
      body: jsonEncode({
        'product_name': productName,
        'type': type,
        'price': double.tryParse(price) ?? 0.0,
        'description': description,
        'active': _active ? 1 : 0,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final encoder = JsonEncoder.withIndent('  '); // Add indentation
      setState(() {
        _response = 'Product updated successfully:\n${encoder.convert(data)}';
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
        title: Text('Update Product Data'),
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
              child: Text('Fetch Product Data'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _productNameController,
              decoration: InputDecoration(labelText: 'Product Name'),
              keyboardType: TextInputType.text,
              enabled: _dataLoaded, // Disable until data is loaded
            ),
            TextField(
              controller: _typeController,
              decoration: InputDecoration(labelText: 'Type'),
              keyboardType: TextInputType.text,
              enabled: _dataLoaded,
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              enabled: _dataLoaded,
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              keyboardType: TextInputType.text,
              enabled: _dataLoaded,
            ),
            CheckboxListTile(
              title: Text('Active'),
              value: _active,
              onChanged: _dataLoaded ? (bool? value) {
                setState(() {
                  _active = value ?? false;
                });
              } : null,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _dataLoaded ? _updateProduct : null, // Enable only if data is loaded
              child: Text('Update Product'),
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
