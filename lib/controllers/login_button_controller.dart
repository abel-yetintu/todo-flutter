import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/core/utils/helper_functions.dart';
import 'package:todo/services/auth_service.dart';

final loginButtonControllerProvider = AutoDisposeAsyncNotifierProvider(() => LoginButtonController());

class LoginButtonController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> login({required String email, required String password}) async {
    try {
      state = const AsyncLoading();
      await getIt<AuthService>().signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        HelperFunctions.showErrorSnackBar(message: 'No internet connection. Please check your network settings and try again.');
      } else {
        HelperFunctions.showErrorSnackBar(message: "Authentication error. Please double-check your details.");
      }
    } finally {
      state = const AsyncData(null);
    }
  }
}
