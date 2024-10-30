import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/auth_wrapper.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/core/utils/extensions.dart';
import 'package:todo/core/utils/helper_widgets.dart';
import 'package:todo/data/models/todo.dart';
import 'package:todo/data/models/todo_user.dart';
import 'package:todo/services/navigation_service.dart';
import 'package:todo/ui/screens/add_collaborator_screen.dart';
import 'package:todo/ui/screens/auth/forgot_password_screen.dart';
import 'package:todo/ui/screens/auth/sign_up_screen.dart';
import 'package:todo/ui/screens/conversation_screen.dart';
import 'package:todo/ui/screens/todo_detail_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const AuthWrapper());
      case '/signUp':
        return MaterialPageRoute(builder: (context) => const SignUpScreen());
      case '/forgotPassword':
        return MaterialPageRoute(builder: (context) => const ForgotPasswordScreen());
      case '/todoDetail':
        if (args is String) {
          return MaterialPageRoute(
            builder: (context) => TodoDetailScreen(
              id: args,
            ),
          );
        } else {
          return _errorRoute(settings);
        }
      case '/addCollaborator':
        if (args is Todo) {
          return MaterialPageRoute(
            builder: (context) => AddCollaboratorScreen(
              todo: args,
            ),
          );
        } else {
          return _errorRoute(settings);
        }
      case '/conversation':
        if (args is TodoUser) {
          return MaterialPageRoute(
            builder: (context) => ConversationScreen(
              otherUser: args,
            ),
          );
        } else {
          return _errorRoute(settings);
        }
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
