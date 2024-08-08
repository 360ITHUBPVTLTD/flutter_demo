import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'session_provider.dart';

class DeletePage extends StatefulWidget {
  @override
  _DeletePageState createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
  final TextEditingController _productIdController = TextEditingController();
  String _response = '';

  Future<void> _deleteProduct() async {
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

    try {
      final response = await http.delete(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Basic $encodedCredentials',
        },
      );

      if (response.statusCode == 202) { // Assuming 202 is the success status code for deletion
        setState(() {
          _response = 'Product deleted successfully:\n${response.body}';
        });
      } else {
        setState(() {
          _response = 'Error: ${response.statusCode} ${response.reasonPhrase}\n${response.body}';
        });
        print('Response body: ${response.body}');
      }
    } catch (e) {
      setState(() {
        _response = 'Exception: $e';
      });
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Product Data'),
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
              onPressed: _deleteProduct,
              child: Text('Delete Product'),
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
