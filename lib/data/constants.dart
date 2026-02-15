import 'package:flutter/material.dart';

// Tekstityylejä
class KTextStyle {
  static const TextStyle titleText = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle infoText = TextStyle(
    fontSize: 20,
  );

  static const TextStyle descriptionText = TextStyle(
    fontSize: 16,
  );

  static const TextStyle watcherOnText = TextStyle(
    fontSize: 20,
    color: Colors.green,
  );

  static const TextStyle watcherOffText = TextStyle(
    fontSize: 20,
    color: Colors.red,
  );

  static const TextStyle linkText = TextStyle(
    fontSize: 14,
    color: Colors.blue,
    decoration: TextDecoration.underline,
  );
}
