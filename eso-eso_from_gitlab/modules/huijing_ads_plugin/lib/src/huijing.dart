// import 'dart:convert';
// import 'dart:io';

import 'package:flutter/services.dart';
// import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';

class HjAd {
  static const _channel = MethodChannel('com.huijingads.ad');

  /// 初始化SDK
  static Future<void> init(String appId,
  {String rewardId, String interstitialId, String fullScreenId}) {
    return _channel.invokeMethod('init', {
      'appId': appId,
      'rewardId': rewardId,
      'interstitialId': interstitialId,
      'fullScreenId': fullScreenId
    });
  }
}
