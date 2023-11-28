import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: LoginBody(),
      ),
    );
  }
}

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleLogin(BuildContext context) {
    Map<String, dynamic> credentials = {
      "users": {
        "b97a3e15f05da8ea82d146739b5a2d1d": {
          "username": "Mars",
          "password": "081199",
          "email": "mairaaltaf64@gmail.com"
        },
        "a82d1d14673b97a3e15f05da8ea2d1d5": {
          "username": "Naan",
          "password": "191099",
          "email": "ahmalik99@gmail.com"
        },
        "5da8ea82d1d146739b5a2d1d1d1d146": {
          "username": "Test",
          "password": "1234",
          "email": "test@gmail.com"
        }
      }
    };

    String username = _usernameController.text.trim();
    String password = _passwordController.text;

    final Map<String, dynamic> users =
        Map<String, dynamic>.from(credentials['users']);

    final findUser = users.values.firstWhere(
      (user) => user['username'] == username && user['password'] == password,
      orElse: () => null,
    );

    if (findUser != null) {
      _usernameController.clear();
      _passwordController.clear();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(
            username: findUser['username'],
            email: findUser['email'],
            password: findUser['password'],
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Invalid Credentials'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              hintText: 'Username',
              contentPadding: EdgeInsets.all(10.0),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              hintText: 'Password',
              contentPadding: EdgeInsets.all(10.0),
            ),
            obscureText: true,
          ),
        ),
        ElevatedButton(
          onPressed: () => _handleLogin(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          child: const Text(
            'Login',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
