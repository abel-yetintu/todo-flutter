import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/auth_wrapper.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/core/utils/extensions.dart';
import 'package:todo/core/utils/helper_widgets.dart';
import 'package:todo/services/navigation_service.dart';
import 'package:todo/ui/screens/auth/forgot_password_screen.dart';
import 'package:todo/ui/screens/auth/sign_up_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const AuthWrapper());
      case '/signUp':
        return MaterialPageRoute(builder: (context) => const SignUpScreen());
      case '/forgotPassword':
        return MaterialPageRoute(builder: (context) => const ForgotPasswordScreen());
      default:
        return _errorRoute(settings);
    }
  }

  static Route _errorRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) {
        return Scaffold(
          backgroundColor: context.colorScheme.error,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                context.screenWidth * 0.05,
                context.screenHeight * 0.025,
                context.screenWidth * 0.05,
                0,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${settings.name} Not Found.',
                      style: context.textTheme.headlineSmall?.copyWith(
                        color: context.colorScheme.onError,
                      ),
                    ),
                    addVerticalSpace(context.screenHeight * .01),
                    Consumer(
                      builder: (context, ref, child) {
                        return FilledButton(
                          onPressed: () {
                            getIt<NavigationService>().goBack();
                          },
                          child: const Text("Go Back"),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
