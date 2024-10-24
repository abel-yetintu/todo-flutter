import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/core/utils/helper_functions.dart';
import 'package:todo/services/auth_service.dart';
import 'package:todo/services/navigation_service.dart';

final signUpButtonControllerProvier = AutoDisposeAsyncNotifierProvider(() => SignUpButtonController());

class SignUpButtonController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> signUp({required String email, required String password, required String name}) async {
    try {
      state = const AsyncLoading();
      await getIt<AuthService>().signUpWithEmailAndPassword(email: email, password: password, displayName: name);
      getIt<NavigationService>().goBack();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        HelperFunctions.showErrorSnackBar(message: 'No internet connection. Please check your network settings and try again.');
      } else {
        HelperFunctions.showErrorSnackBar(message: "Sign up error. Please check your information and try again.");
      }
    } finally {
      state = const AsyncData(null);
    }
  }
}
