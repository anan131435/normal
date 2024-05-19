// 广告事件
class AdEvent {
  String? eventType = EventType.unknown;
  String? msg = '';
  String? adType = '';

  AdEvent({
    this.eventType,
    this.msg,
    this.adType,
  });

  factory AdEvent.fromJson(Map<dynamic, dynamic> json) {
    return AdEvent(
        eventType: json['eventType'], msg: json['msg'], adType: json['adType']);
  }
}

/// 事件类型
class EventType {
  // 未知
  static const String unknown = 'unknown';
  // 广告加载完毕
  static const String onAdLoaded = 'onAdLoaded';
  // 广告错误
  static const String onAdError = 'onAdError';
  // 广告展示
  static const String onAdExposure = 'onAdExposure';
  // 广告关闭
  static const String onAdClosed = 'onAdClosed';
  // 广告点击
  static const String onAdClicked = 'onAdClicked';
  // 获得奖励
  static const String onReward = 'onReward';
  // 跳过广告
  static const String onAdSkip = "onAdSkip";
  // 超过广告时间
  static const String onAdTimeOver = "onAdTimeOver";
}

/// 事件类型
class AdType {
  // 未知
  static const String unknown = 'unknown';
  // 激励广告
  static const String rewardVideo = 'rewardVideo';
  // banner
  static const String banner = 'banner';
  // 全屏视频
  static const String fullscreenVideo = 'fullscreenVideo';
  // 开屏
  static const String splash = 'splash';
  // 插屏
  static const String interstitial = 'interstitial';
}
