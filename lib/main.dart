import 'package:flutter/material.dart';
import 'package:tarkeez/core/app/app.dart';
import 'package:tarkeez/core/app/bootstrap.dart';

Future<void> main() async {
  final initialTheme = await bootstrap();
  runApp(App(initialTheme: initialTheme));
}
