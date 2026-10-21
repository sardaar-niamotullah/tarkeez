import 'package:flutter/material.dart';

Color colorFromHexCode(String hex) {
  final value = hex.replaceFirst('#', '');
  return Color(int.parse('FF$value', radix: 16));
}
