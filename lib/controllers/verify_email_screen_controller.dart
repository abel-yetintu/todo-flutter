import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/core/utils/helper_functions.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/services/auth_service.dart';

final verifyEmailScreenControllerProvider = AutoDisposeNotifierProvider<VerifyEmailScreenController, bool>(() {
  return VerifyEmailScreenController();
});

class VerifyEmailScreenController extends AutoDisposeNotifier<bool> {
  Timer? _resendEmail;
  Timer? _emailVerificationChecker;

  @override
  bool build() {
    ref.onDispose(() {
      _resendEmail?.cancel();
      _emailVerificationChecker?.cancel();
    });
    return false;
  }

  Future<void> sendEmailVerification() async {
    final auth = getIt<AuthService>();
    try {
      _resendEmail = Timer(const Duration(minutes: 1), () => state = true);
      await auth.sendVerificationEmail();
      HelperFunctions.showSnackBar(message: 'Check your inbox!');
      _emailVerificationChecker = Timer.periodic(const Duration(seconds: 5), (timer) async => _checkEmailVerified());
    } on FirebaseAuthException catch (e) {
      _resendEmail?.cancel();
      _emailVerificationChecker?.cancel();
      state = true;
      if (e.code == 'network-request-failed') {
        HelperFunctions.showErrorSnackBar(message: 'No internet connection. Please check your network settings and try again.');
      } else {
        HelperFunctions.showErrorSnackBar(message: "Oops! Something went wrong. Please try again.");
      }
    }
  }

  Future<void> _checkEmailVerified() async {
    final auth = getIt<AuthService>();
    await auth.reloadUser();
    if (auth.currentUser!.emailVerified) {
      _emailVerificationChecker?.cancel();
      ref.invalidate(authStateChangesProvider);
    }
  }

  Future<void> cancel() async {
    try {
      getIt<AuthService>().signOut();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        HelperFunctions.showErrorSnackBar(message: 'No internet connection. Please check your network settings and try again.');
      } else {
        HelperFunctions.showErrorSnackBar(message: "Oops! Something went wrong. Please try again.");
      }
    }
  }
}
