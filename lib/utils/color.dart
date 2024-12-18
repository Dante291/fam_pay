import 'package:flutter/material.dart';

extension HexColor on String {
  Color toColor() {
    return Color(int.parse('FF${replaceFirst('#', '')}', radix: 16));
  }
}
