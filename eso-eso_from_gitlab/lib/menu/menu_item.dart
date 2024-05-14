import 'package:flutter/material.dart';

class MenuItemEso<T> {
  final T value;
  final String text;
  final IconData icon;
  final Color color;
  final Color textColor;

  const MenuItemEso({
    required this.value,
    required this.text,
    required this.icon,
    required this.color,
    required this.textColor,
  });
}
