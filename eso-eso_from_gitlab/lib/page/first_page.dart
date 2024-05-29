import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:eso/eso_theme.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:huijing_ads_plugin/huijing_ads_plugin.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

import '../database/rule.dart';
import '../global.dart';
import '../menu/menu_edit_source.dart';
import '../model/edit_source_provider.dart';
import '../utils/auto_decode_cli.dart';
import 'home/entity/data_base_entity.dart';
import 'home/model/reward_listener.dart';
import 'home/model/splash_ad_listener.dart';
import 'package:http/http.dart' as http;

class FirstPage extends StatefulWidget {
  const FirstPage({Key key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  HjSplashAd splashAd;
  SplashListener _rewardListener;
  Timer _timer;
  ValueNotifier<Size> sizeNotifier = ValueNotifier(Size.zero);
  @override
  void initState() {
    _onListenAdCallback();
    _rewardListener = SplashListener(loadSuccess: () {
      print("SplashListener loadSuccess");
      _startRequestAd();
    }, loadFailed: () {
      print("SplashListener loadFailed");
    });
    _startRequestAd();
    Future.delayed(const Duration(seconds: 2))
        .then((value) => _startRequestAd());
    super.initState();
  }

  String _fetchCurrentDate() {
    DateTime now = DateTime.now();
    String dateStr = DateFormat.yMd().format(now);
    return dateStr;
  }

  void cancelTimer() {
    if (_timer != null) {
      print("timer销毁");
      _timer.cancel();
    }
  }

  void _startRequestAd() {
    if (Platform.isIOS) {
      _requestRewardAd();
    } else {
      _requestAndroidRewardAd();
    }
  }

  void _requestRewardAd() async {
    if (splashAd == null) {
      HjAdRequest request = HjAdRequest(placementId: "5633128364662103");
      splashAd = HjSplashAd(
        sizeNotifier,
        request: request,
        width: 300,
        height: 300,
        listener: _rewardListener,
      );
      splashAd.loadAd();
    } else {
      _showRewardAd();
    }
  }

  void _showRewardAd() async {
    bool isReady = await splashAd.isReady();
    print("xiuxiu isReady $isReady");
    if (isReady) {
      splashAd.showAd();
    } else {
      splashAd.loadAd();
    }
  }

  void _requestAndroidRewardAd() async {
    if (splashAd == null) {
      HjAdRequest request = HjAdRequest(placementId: "9437884285841233");
      splashAd = HjSplashAd(
        sizeNotifier,
        request: request,
        width: 300,
        height: 300,
        listener: _rewardListener,
      );
      splashAd.loadAd();
    } else {
      _showRewardAd();
    }
  }

  //监听广告SDK回调
  void _onListenAdCallback() {
    eventBus.on<String>().listen((event) async {
      String dateStr = _fetchCurrentDate();
      print("xiuxiu回调了$event");
      if (event == "onAdReward") {
        UmengCommonSdk.onEvent("getReward",
            {"date": dateStr, "platForm": Platform.isIOS ? "iOS" : "Android"});
      } else if (event == "onAdClose") {
        print("xiuxiu${dateStr}关闭广告了");
      }
    });
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
    } catch (e) {
      print("格式不对$e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 150,
            width: double.infinity,
          ),
          Image.asset("assets/bg/heart-123.gif"
          ),
          SizedBox(
            height: 20,
          ),

          Text(
            '亦搜',
            style: TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontFamily: ESOTheme.staticFontFamily,
              letterSpacing: 6,
              color: Color.fromARGB(255, 40, 185, 130),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Spacer(),
        ],
      ),
    );
  }
}
