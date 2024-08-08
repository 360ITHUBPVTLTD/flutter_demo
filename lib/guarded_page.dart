import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'session_provider.dart';

class GuardedPage extends StatelessWidget {
  final Widget child;

  GuardedPage({required this.child});

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);

    // Check if the token is set; if not, redirect to login
    if (sessionProvider.apiToken.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return SizedBox.shrink(); // Return an empty widget while redirecting
    }

    return child;
  }
}
