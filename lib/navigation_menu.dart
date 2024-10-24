import 'package:flutter/material.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/services/auth_service.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FilledButton(
          onPressed: () {
            getIt<AuthService>().signOut();
          },
          child: const Text('Sign Out'),
        ),
      ),
    );
  }
}
