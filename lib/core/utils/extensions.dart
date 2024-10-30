import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  ColorScheme get colorScheme => theme.colorScheme;

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  double get screenHeight => MediaQuery.of(this).size.height;

  double get screenWidth => MediaQuery.of(this).size.width;
}

extension Validators on String {
  bool get isValidEmail {
    final RegExp regExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return regExp.hasMatch(trim());
  }

  bool get isValidPassword {
    return length >= 6;
  }

  bool get isValidName {
    return this != "";
  }

  bool get isValidUserName {
    return this != "";
  }
}

extension DateTimeExtension on DateTime {
  String getMonthDay() {
    return DateFormat.MMMd().format(this);
  }

  String getTime() {
    final dateFormat = DateFormat.jm();
    return dateFormat.format(this).toLowerCase();
  }

  bool get isToday {
    final now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.day == day && yesterday.month == month && yesterday.year == year;
  }

  String getFormattedConversationTime() {
    if (isToday) {
      return DateFormat.jm().format(this).toLowerCase();
    }
    final now = DateTime.now();
    if (year != now.year) {
      final dateFormat = DateFormat.yMMMd();
      return dateFormat.format(this);
    }
    final dateFormat = DateFormat.MMMd();
    return dateFormat.format(this);
  }

  String getFormattedDate() {
    if (isToday) {
      return 'Today';
    }
    if (isYesterday) {
      return 'Yesterday';
    }
    final now = DateTime.now();
    if (year != now.year) {
      final dateFormat = DateFormat.yMMMd();
      return dateFormat.format(this);
    }
    final dateFormat = DateFormat.MMMd();
    return dateFormat.format(this);
  }
}
