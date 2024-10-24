import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/core/utils/helper_functions.dart';
import 'package:todo/data/models/todo_user.dart';
import 'package:todo/services/auth_service.dart';
import 'package:todo/services/database_service.dart';
import 'package:todo/services/navigation_service.dart';

final signUpButtonControllerProvier = AutoDisposeAsyncNotifierProvider(() => SignUpButtonController());

class SignUpButtonController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> signUp({required String email, required String userName, required String password, required String fullName}) async {
    try {
      state = const AsyncLoading();

      // check if username is already taken
      bool usernameExists = await getIt<DatabaseService>().isUserNameTaken(userName: userName);
      if (usernameExists) {
        throw Exception('Username is already taken. Please choose another');
      }

      // create a user in firebaseAuth
      final userCredential = await getIt<AuthService>().signUpWithEmailAndPassword(email: email, password: password, displayName: fullName);
      final user = userCredential.user!;

      // create user document in users collection
      final todoUser = TodoUser(uid: user.uid, email: email, userName: userName, fullName: fullName, profilePicture: '');
      await getIt<DatabaseService>().createUserDocument(todoUser: todoUser);

      getIt<NavigationService>().goBack();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        HelperFunctions.showErrorSnackBar(message: 'No internet connection. Please check your network settings and try again.');
      } else {
        HelperFunctions.showErrorSnackBar(message: "Sign up error. Please check your information and try again.");
      }
    } catch (e) {
      HelperFunctions.showErrorSnackBar(message: e.toString());
      debugPrint(e.toString());
    } finally {
      state = const AsyncData(null);
    }
  }
}
