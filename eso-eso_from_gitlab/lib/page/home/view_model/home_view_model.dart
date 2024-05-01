import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  final List<String> tabTitles = [
    "推荐",
    "阅读",
    "音频",
    "图片",
    "视频",
    "短视频",
  ];
}
