import 'dart:async';
import 'dart:io';

import 'package:eso/eso_theme.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:huijing_ads_plugin/huijing_ads_plugin.dart';
import 'package:intl/intl.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

import '../global.dart';
import 'home/model/reward_listener.dart';
import 'home/model/splash_ad_listener.dart';

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
    },loadFailed: () {
      print("SplashListener loadFailed");
    });
    _startRequestAd();
    Future.delayed(const Duration(seconds: 2)).then((value) => _startRequestAd());
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
    eventBus.on<String>().listen((event) async{
      String dateStr = _fetchCurrentDate();
      print("xiuxiu回调了$event");
      if (event == "onAdReward") {
        UmengCommonSdk.onEvent("getReward", {"date":dateStr,"platForm":Platform.isIOS ? "iOS" : "Android"});
      } else if (event == "onAdClose") {
        print("xiuxiu${dateStr}关闭广告了");

      }

    });
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
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                height: 80.0,
                width: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF18D191),
                ),
                child: new Icon(
                  Icons.library_books,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 90.0, top: 80.0),
                height: 80.0,
                width: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF45E0EC),
                ),
                child: Icon(
                  Icons.photo_library,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10.0, top: 90.0),
                height: 80.0,
                width: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFFCE56),
                ),
                child: Icon(
                  Icons.library_music,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 100.0, top: 70.0),
                height: 80.0,
                width: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFC6A7F),
                ),
                child: Icon(
                  Icons.video_library,
                  color: Colors.white,
                  size: 32,
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          // Container(
          //   height: 100,
          //   width: 100,
          //   child: Image.asset(
          //     Global.logoPath,
          //     fit: BoxFit.fill,
          //   ),
          // ),
          Text(
            'ESO',
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
          Text(
            'my custom reader & player in one app',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
