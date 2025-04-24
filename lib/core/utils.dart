import 'package:flutter/material.dart';
import 'package:reddit_clone/main.dart'; // Import to access the global key

// Original function - keep for backward compatibility
void showSnackBar(BuildContext context, String text) {
  // Use the global key instead of the context
  rootScaffoldMessengerKey.currentState
    ?..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
}

// New function without context - you can gradually migrate to using this
void showSnackBarGlobal(String text) {
  rootScaffoldMessengerKey.currentState
    ?..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
}