import 'dart:async';
import 'package:flutter/services.dart';
import 'entity/ad_event.dart';

export 'view/banner_ad_widget.dart';

class FlutterPluginAd {
  // 方法渠道
  static const MethodChannel _channel =
      const MethodChannel('flutter_plugin_ad');

  ///事件渠道
  static const EventChannel _eventChannel =
      const EventChannel('flutter_plugin_ad_event');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// 初始化广告
  /// [appKey] 广告配置 appKey
  /// [isDebug] 是否为测试模式
  static Future<bool> initAd(String appKey, {bool isDebug = false}) async {
    final bool result = await _channel.invokeMethod(
      'initAd',
      {'appKey': appKey, 'isDebug': isDebug},
    );
    return result;
  }

  /// 请求权限
  /// 仅 Android
  static Future<bool> checkAndReqPermission() async {
    final bool result = await _channel.invokeMethod('checkAndReqPermission');
    return result;
  }

  /// 展示开屏广告
  /// [adId] 广告配置 adId
  static Future<bool> showSplashAd(String adId) async {
    final bool result = await _channel.invokeMethod(
      'showSplashAd',
      {'adId': adId},
    );
    return result;
  }

  /// 展示插屏广告
  /// [adId] 广告配置 adId
  static Future<bool> showInterstitialAd(String adId) async {
    final bool result = await _channel.invokeMethod(
      'showInterstitialAd',
      {'adId': adId},
    );
    return result;
  }

  /// 展示全屏视频广告
  /// [adId] 广告配置 adId
  static Future<bool> showFullscreenVideoAd(String adId) async {
    final bool result = await _channel.invokeMethod(
      'showFullscreenVideoAd',
      {'adId': adId},
    );
    return result;
  }

  /// 展示激励视频广告
  /// [adId] 广告配置 adId
  static Future<bool> showRewardVideoAd(String adId, String userId) async {
    final bool result = await _channel.invokeMethod(
      'showRewardVideoAd',
      {'adId': adId, 'userId': userId},
    );
    return result;
  }

  /// 初始化广告
  /// [appKey] 广告配置 appKey
  /// [isDebug] 是否为测试模式
  static Future<bool> showRewardVideoAdFromRootViewController(
      String adId) async {
    final bool result = await _channel.invokeMethod(
      'showRewardVideoAdFromRootViewController',
      {'adId': ""},
    );
    return result;
  }

  /// 展示短视频内容太广告
  /// [adId]            广告配置 adId
  /// [rewardCount]     奖励次数
  /// [rewardDownTime]  单次奖励需要观看的时长
  static Future<bool> showVideoPage(String adId, int rewardCount, int rewardDownTime) async {
    final bool result = await _channel.invokeMethod(
      'showVideoPage',
      {
        'adId': adId,
        'rewardCount': rewardCount,
        'rewardDownTime': rewardDownTime,
      },
    );
    return result;
  }

  /// 展示学习天地
  /// [adId] 广告配置 adId
  static Future<bool> showStudy(String adRewardId, String adInsertId,
      String adBannerId, String adAnswerCount) async {
    final bool result = await _channel.invokeMethod(
      'showStudy',
      {
        'adRewardId': adRewardId,
        'adInsertId': adInsertId,
        'adBannerId': adBannerId,
        'adAnswerCount': adAnswerCount
      },
    );
    return result;
  }

  /// 展示资讯内容
  /// [adId] 广告配置 adId
  static Future<bool> showNews(
      String adNewsId, String adInsertId, String adBannerId) async {
    final bool result = await _channel.invokeMethod(
      'showNews',
      {
        'adNewsId': adNewsId,
        'adInsertId': adInsertId,
        'adBannerId': adBannerId
      },
    );
    return result;
  }

  /// 展示资讯内容
  /// [adId] 广告配置 adId
  static Future<bool> showOneiromancy(
      String adRewardId, String adBannerId) async {
    final bool result = await _channel.invokeMethod(
      'showOneiromancy',
      {'adRewardId': adRewardId, 'adBannerId': adBannerId},
    );
    return result;
  }

  /// 展示短视频内容首页
  /// [adId] 广告配置 adId
  static Future<bool> showKsVideoFragment(String adId) async {
    return await _channel.invokeMethod(
      'showKsVideoFragment',
      {'adId': adId},
    );
  }

  /// 展示原生信息流
  /// [adId] 广告配置 adId
  static Future<bool> showInformation(String adId) async {
    return await _channel.invokeMethod(
      'showInformation',
      {'adId': adId},
    );
  }

  ///事件回调
  ///@params onData 事件回调
  static Future<void> onEventListener(void onData(AdEvent event)) async {
    _eventChannel.receiveBroadcastStream().listen((data) {
      if (data != null) {
        AdEvent result = AdEvent.fromJson(data);
        onData(result);
      }
    });
  }
}
