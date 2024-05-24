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

  void addUrlDecode({EditSourceProvider provider}) async {
    final requestUri = Uri.tryParse("https://eso.hanpeki.online/index.json");
    if (requestUri == null) {
      print("接口返回错误");
    } else {
      final response = await http.get(requestUri);
      print("接口返回 ${response.body}");
      Map<String, dynamic> json = jsonDecode(response.body);
      DataBaseEntity entity = DataBaseEntity.fromJson(json);
      entity.contentVersion = "1.0.1";
      var box = Hive.box(Global.contentVersionKey);
      if (entity.contentVersion == box.get(Global.contentVersionKey)) {
        //版本号一致不更新数据库内容
        print("不更新数据库内容");
      } else {
        if (box.get(Global.contentVersionKey) == null) {
          box.put(Global.contentVersionKey, entity.contentVersion);
          final uri = Uri.tryParse(entity.url);
          print("开始请求");
          final res = await http.get(uri, headers: {
            'User-Agent':
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.113 Safari/537.36'
          });
          print("请求结束");
          insertOrUpdateRuleInMain(autoReadBytes(res.bodyBytes));
        } else {
          //删除老的
          final rules = provider.rules
              .where((element) => provider.checkSelectMap[element.id] == true)
              .toList();
          print("查询到老的数据源是${rules.length}");
          await provider.handleSelect(rules, MenuEditSource.delete);
          //插入新的
          box.put(Global.contentVersionKey, entity.contentVersion);
          final uri = Uri.tryParse(entity.url);
          print("开始请求");
          final res = await http.get(uri, headers: {
            'User-Agent':
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.113 Safari/537.36'
          });
          print("请求结束");
          insertOrUpdateRuleInMain(autoReadBytes(res.bodyBytes));
        }
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
    } catch (e) {
      print("格式不对$e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditSourceProvider>(
      create: (context) => EditSourceProvider(type: 2),
      builder: (context, child) {
        // final provider = Provider.of<EditSourceProvider>(context, listen: true);
        // addUrlDecode(provider: provider);
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
      },
    );
  }
}
