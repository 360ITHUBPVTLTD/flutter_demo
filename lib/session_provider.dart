import 'package:flutter/material.dart';

class SessionProvider with ChangeNotifier {
  String _apiToken = '';

  String get apiToken => _apiToken;

  void setToken(String token) {
    _apiToken = token;
    notifyListeners();
  }

  void logout() {
    _apiToken = '';
    notifyListeners();
  }
}
