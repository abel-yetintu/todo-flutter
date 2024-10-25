import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:todo/services/auth_service.dart';
import 'package:todo/services/database_service.dart';
import 'package:todo/services/image_picker_service.dart';
import 'package:todo/services/navigation_service.dart';
import 'package:todo/services/storage_service.dart';

final getIt = GetIt.instance;

void diInit() {
  // navigator key
  getIt.registerSingleton(GlobalKey<NavigatorState>());

  getIt.registerSingleton(NavigationService(navigatorKey: getIt<GlobalKey<NavigatorState>>()));

  getIt.registerSingleton(AuthService());

  getIt.registerSingleton(DatabaseService());

  getIt.registerSingleton(ImagePickerService());

  getIt.registerSingleton(StorageService());
}
