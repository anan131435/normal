import 'dart:async';
import 'dart:io';

import 'package:eso/page/home/model/splash_ad_listener.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:huijing_ads_plugin/huijing_ads_plugin.dart';
import 'package:intl/intl.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

import '../../global.dart';
import '../home/model/reward_listener.dart';
class LaunchAdPage extends StatefulWidget {
  const LaunchAdPage({Key key});

  @override
  State<LaunchAdPage> createState() => _LaunchAdPageState();
}

class _LaunchAdPageState extends State<LaunchAdPage> {
  HjRewardAd rewardAd;
  int _count = 0;
  EsoRewardListener _rewardListener;
  Timer _timer;
  var box = Hive.box(Global.rewardAdShowCountKey);
  @override
  void initState() {
    _onListenAdCallback();
    // _rewardListener = SplashListener(loadSuccess: () {
    //   print("SplashListener loadSuccess");
    //   _startRequestAd();
    // });
    _startRequestAd();
    super.initState();

  }

  void _fireTimer() {
    int showCount = box.get(_fetchCurrentDate());
    if (showCount == null || showCount < 3 ) {
      cancelTimer();
      _timer = Timer.periodic(const Duration(seconds: 60), (timer) async {
        _count ++;
        print(_count);
        _startRequestAd();
      });
    } else {
      cancelTimer();
      print("达到3次了");
    }
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
    if (rewardAd == null) {
      HjAdRequest request = HjAdRequest(placementId: "3283392768998526");
      rewardAd = HjRewardAd(
          request: request,
          listener: _rewardListener);
      rewardAd.loadAdData();
    } else {
      _showRewardAd();
    }
  }

  void _showRewardAd() async {
    bool isReady = await rewardAd.isReady();
    print("xiuxiu isReady $isReady");
    if (isReady) {
      rewardAd.showAd();
    } else {
      rewardAd.loadAdData();
    }
  }

  void _requestAndroidRewardAd() async {
    if (rewardAd == null) {
      HjAdRequest request = HjAdRequest(placementId: "8727293799263656");
      rewardAd = HjRewardAd(
          request: request,
          listener: _rewardListener);
      rewardAd.loadAdData();
    } else {
      _showRewardAd();
    }
  }
  //监听广告SDK回调
  void _onListenAdCallback() {
    eventBus.on<String>().listen((event) async{
      String dateStr = _fetchCurrentDate();
      int showCount = box.get(dateStr);
      print("xiuxiu回调了$event");
      if (event == "onAdReward") {
        UmengCommonSdk.onEvent("getReward", {"date":dateStr,"platForm":Platform.isIOS ? "iOS" : "Android"});
      } else if (event == "onAdClose") {

        print("xiuxiu${dateStr}关闭广告了");
        if (showCount == null || showCount < 3) {
          _startRequestAd();
        }
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.red,
      ),
    );
  }
}
