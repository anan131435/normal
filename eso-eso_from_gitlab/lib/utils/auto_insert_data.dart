import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eso/page/home/entity/data_base_entity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../database/rule.dart';
import '../global.dart';
import 'auto_decode_cli.dart';
class DataManager extends ChangeNotifier{

   void addUrlDecode() async {

    final requestUri = Uri.tryParse("https://eso.hanpeki.online/index.json");
    if (requestUri == null) {
      print("接口返回错误");
    } else {
      final response = await http.get(requestUri);
      print("接口返回 ${response.body}");
      Map<String,dynamic> json = jsonDecode(response.body);
      DataBaseEntity entity = DataBaseEntity.fromJson(json);
      print(entity.url);
      final uri = Uri.tryParse(entity.url);
      // "https://cdn.jsdelivr.net/gh/nanchengling/eso-repo@1.0.1/manifest"
      // final uri = Uri.tryParse("https://cdn.jsdelivr.net/gh/nanchengling/eso-repo@1.0.1/manifest");
      if (uri == null) {
        print("地址格式错误");
      } else {
        print("开始请求");
        final res = await http.get(uri);
        // final res = await http.get(uri, headers: {
        //   'User-Agent':
        //   'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.113 Safari/537.36'
        // });
        print("请求结束");
        insertOrUpdateRuleInMain(autoReadBytes(res.bodyBytes));
      }
    }
  }

   void insertOrUpdateRuleInMain(String s, [List l]) async {
    try {
      dynamic json;
      if (l != null) {
        json = l;
      } else {
        json = jsonDecode(s.trim());
      }
      if (json is Map) {
        final id = await Global.ruleDao.insertOrUpdateRule(Rule.fromJson(json));
        if (id != null) {
          print("成功 1 条规则");

        }
      } else if (json is List) {
        final okrules = json
            .map((rule) => Rule.fromJson(rule))
            .where((rule) => rule.name.isNotEmpty && rule.host.isNotEmpty)
            .toList();
        final ids = await Global.ruleDao.insertOrUpdateRules(okrules);
        if (ids.length > 0) {
          print("成功 ${okrules.length} 条规则");
        } else {
          print("失败，未导入规则！");
        }
      }
      print("要发送监听");
      notifyListeners();
    } catch (e) {
      print("格式不对$e");
    }
  }

}