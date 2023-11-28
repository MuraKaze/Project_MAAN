import 'package:flutter/material.dart';
import 'dashboard_logic.dart';

class DashboardScreen extends StatelessWidget {
  final String username;
  final String email;
  final String password;

  const DashboardScreen({
    super.key,
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome $username!'),
        actions: [
          IconButton(
            onPressed: () {
              DashboardLogic.handleLogout(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: DashboardLogic.buildBody(context),
    );
  }
}
