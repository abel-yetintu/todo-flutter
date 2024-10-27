import 'package:flutter/material.dart';

enum TodoColor {
  tangerine,
  forestGreen,
  brightCoral,
  goldenRod,
  turquoiseBlue;

  Color get colorValue {
    switch (this) {
      case TodoColor.tangerine:
        return const Color.fromARGB(255, 255, 128, 0);
      case TodoColor.forestGreen:
        return const Color.fromARGB(255, 34, 139, 34);
      case TodoColor.brightCoral:
        return const Color.fromARGB(255, 255, 87, 51);
      case TodoColor.goldenRod:
        return const Color.fromARGB(255, 218, 165, 32);
      case TodoColor.turquoiseBlue:
        return const Color.fromARGB(255, 0, 184, 212);
    }
  }
}
