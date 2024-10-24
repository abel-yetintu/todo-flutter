import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/core/utils/extensions.dart';
import 'package:todo/core/utils/helper_widgets.dart';
import 'package:todo/navigation_menu.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/services/auth_service.dart';
import 'package:todo/ui/screens/auth/login_screen.dart';
import 'package:todo/ui/screens/auth/verify_email_screen.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider);
    return user.when(
      loading: () => _loadingUI(context),
      error: (error, stackTrace) => _errorUI(context, error, ref),
      data: (user) {
        if (user == null) {
          return const LoginScreen();
        } else {
          if (getIt<AuthService>().currentUser!.emailVerified) {
            return const NavigationMenu();
          } else {
            return const VerifyEmailScreen();
          }
        }
      },
    );
  }

  _loadingUI(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.05, vertical: 0),
          child: Center(
            child: SpinKitThreeBounce(
              color: context.theme.colorScheme.secondary,
            ),
          ),
        ),
      ),
    );
  }

  _errorUI(BuildContext context, Object error, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.05, vertical: 0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("An error occured. Please try again."),
                addVerticalSpace(context.screenHeight * 0.01),
                FilledButton(
                  onPressed: () {
                    ref.invalidate(authStateChangesProvider);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
