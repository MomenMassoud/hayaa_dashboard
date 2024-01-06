import 'package:flutter/material.dart';

class CustomSnackbar {
  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info),
            const SizedBox(width: 8.0),
            Text(message),
          ],
        ),
      ),
    );
  }
}
