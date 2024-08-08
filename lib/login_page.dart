import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'session_provider.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _userIdController = TextEditingController(text: "Shriramu.ms@lsaoffice.com");
  final TextEditingController _passwordController = TextEditingController(text: "India@123#");
  String _responseMessage = '';
  String _apiToken = '';

  late Dio _dio;

  @override
  void initState() {
    super.initState();
    _dio = Dio();
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final String userId = _userIdController.text.trim();
    final String password = _passwordController.text.trim();

    try {
      final response = await _dio.post(
        'http://lsa.local:8016/api/method/lsa.api_authentication.authentication_api',
        data: {
          'usr': userId,
          'pwd': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          extra: {
            'withCredentials': true,
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final message = responseData['message'];
        if (message != null) {
          final successKey = message['success_key'];
          if (successKey == 1) {
            _apiToken = message['token'] ?? '';
            // Save the token to the provider
            final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
            sessionProvider.setToken(_apiToken);

            Navigator.pushReplacementNamed(context, '/home');
          } else {
            setState(() {
              _responseMessage = 'Authentication failed: ${message['message']}';
            });
          }
        } else {
          setState(() {
            _responseMessage = 'Unexpected response format';
          });
        }
      } else {
        setState(() {
          _responseMessage = 'Login failed with status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _responseMessage = 'An error occurred: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _userIdController,
              decoration: InputDecoration(labelText: 'User ID'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            Text(
              'Response Message: $_responseMessage',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
