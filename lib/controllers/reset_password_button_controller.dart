import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/core/utils/helper_functions.dart';
import 'package:todo/services/auth_service.dart';

final resetPasswordButtonControllerProvider = AutoDisposeAsyncNotifierProvider(() => ResetPasswordButtonController());

class ResetPasswordButtonController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> resetPassword({required String email}) async {
    try {
      state = const AsyncLoading();
      await getIt<AuthService>().resetPassword(email: email);
      HelperFunctions.showSnackBar(message: "Password reset link sent! Check you email.");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        HelperFunctions.showErrorSnackBar(message: 'No internet connection. Please check your network settings and try again.');
      } else {
        HelperFunctions.showErrorSnackBar(message: "Oops! Something went wrong.");
      }
    } finally {
      state = const AsyncData(null);
    }
  }
}
