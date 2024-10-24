import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/services/auth_service.dart';

final authStateChangesProvider = StreamProvider.autoDispose((ref) {
  return getIt<AuthService>().authStateChanges;
});
