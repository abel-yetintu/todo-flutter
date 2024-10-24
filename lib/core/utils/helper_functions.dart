import 'package:flutter/material.dart';
import 'package:todo/core/dependecy_injection.dart';
import 'package:todo/core/utils/extensions.dart';

class HelperFunctions {
  static void showErrorSnackBar({required String message}) {
    BuildContext context = getIt<GlobalKey<NavigatorState>>().currentState!.context;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: context.colorScheme.error,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.onError),
        ),
      ),
    );
  }

  static void showSnackBar({required String message}) {
    BuildContext context = getIt<GlobalKey<NavigatorState>>().currentState!.context;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: context.colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.onPrimary),
        ),
      ),
    );
  }
}
