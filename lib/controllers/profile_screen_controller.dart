import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/core/utils/helper_functions.dart';
import 'package:todo/core/utils/helper_widgets.dart';
import 'package:todo/data/models/todo_user.dart';
import 'package:todo/services/auth_service.dart';
import 'package:todo/services/database_service.dart';
import 'package:todo/services/navigation_service.dart';

final profileScreenControllerProvider = AutoDisposeNotifierProvider<ProfileScreenController, void>(() => ProfileScreenController());

class ProfileScreenController extends AutoDisposeNotifier<void> {
  @override
  build() {}

  Future<void> signOut() async {
    try {
      showNonDismissibleLoadingDialog(getIt<GlobalKey<NavigatorState>>().currentContext!);
      await getIt<AuthService>().signOut();
      getIt<NavigationService>().goBack();
    } on FirebaseAuthException catch (e) {
      getIt<NavigationService>().goBack();
      if (e.code == 'network-request-failed') {
        HelperFunctions.showErrorSnackBar(message: 'No internet connection. Please check your network settings and try again');
      } else {
        HelperFunctions.showErrorSnackBar(message: "Sign out error. Please try again later");
      }
    }
  }

  Future<void> deleteAccount({required String password, required TodoUser todoUser}) async {
    final auth = getIt<AuthService>();
    try {
      showNonDismissibleLoadingDialog(getIt<GlobalKey<NavigatorState>>().currentContext!);
      await auth.reAuthenticateUser(password: password);
      await auth.deleteUser();
      await getIt<DatabaseService>().deleteUser(todoUser: todoUser);
      getIt<NavigationService>().goBack();
      HelperFunctions.showSnackBar(message: 'Your account has been deleted.');
    } on FirebaseException catch (e) {
      getIt<NavigationService>().goBack();
      if (e.code == 'network-request-failed') {
        HelperFunctions.showErrorSnackBar(message: 'No internet connection. Please check your network settings and try again');
      } else if (e.code == 'invalid-credential') {
        HelperFunctions.showErrorSnackBar(message: "Authentication error. Please check your credentials");
      } else {
        HelperFunctions.showErrorSnackBar(message: "Unkown error has occured");
      }
    }
  }
}
