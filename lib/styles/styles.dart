import 'package:flutter/material.dart';

InputDecoration underlineTextDecoration([String? hintText]) {
  return InputDecoration(
    hintText: hintText,
    filled: false,
    border: const UnderlineInputBorder(),
    focusedBorder: const UnderlineInputBorder(),
    enabledBorder: const UnderlineInputBorder(),
    errorStyle: const TextStyle(color: Colors.red)
  );
}