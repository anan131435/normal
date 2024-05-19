package com.sskj.flutter_plugin_ad.entity;

/// 事件类型
public class EventType {
    // 未知
    public static final String unknown = "unknown";
    // 广告加载完毕
    public static final String onAdLoaded = "onAdLoaded";
    // 广告错误
    public static final String onAdError = "onAdError";
    // 广告展示
    public static final String onAdExposure = "onAdExposure";
    // 广告关闭
    public static final String onAdClosed = "onAdClosed";
    // 广告点击
    public static final String onAdClicked = "onAdClicked";
    // 获得奖励
    public static final String onReward = "onReward";
    // 跳过广告
    public static final String onAdSkip = "onAdSkip";
    // 超过广告时间
    public static final String onAdTimeOver = "onAdTimeOver";
}
