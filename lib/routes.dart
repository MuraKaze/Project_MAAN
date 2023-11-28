import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'dashboard_screen.dart';

class Routes {
  static const String initialRoute = '/login';
  static const String login = '/login';
  static const String dashboard = '/dashboard';

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initialRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case dashboard:
        if (settings.arguments != null) {
          final Map<String, dynamic> args =
              settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => DashboardScreen(
              username: args['username'],
              email: args['email'],
              password: args['password'],
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Missing arguments for DashboardScreen'),
            ),
          ),
        );
      default:
        // Handle unknown routes here
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
