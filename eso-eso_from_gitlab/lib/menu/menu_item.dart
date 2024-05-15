import 'package:flutter/material.dart';

class MenuItemEso<T> {
  final T? value;
  final String? text;
  final IconData? icon;
  final Color? color;
  final Color? textColor;

  const MenuItemEso({
     this.value,
     this.text,
     this.icon,
     this.color,
     this.textColor,
  });
}
