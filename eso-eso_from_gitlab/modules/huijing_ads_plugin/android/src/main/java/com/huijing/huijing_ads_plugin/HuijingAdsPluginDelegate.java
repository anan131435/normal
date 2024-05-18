package com.huijing.huijing_ads_plugin;

import androidx.annotation.NonNull;
import android.app.Activity;
import android.app.Application;

import com.huijing.huijing_ads_plugin.banner.BannerAd;
import com.huijing.huijing_ads_plugin.reward.RewardVideoAd;
import com.huijing.huijing_ads_plugin.interstitial.InterstitialAd;
import com.huijing.huijing_ads_plugin.splash.SplashAd;
import com.hzhj.openads.HJAdsSdk;
import com.hzhj.openads.utils.HJLog;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformViewRegistry;

public class HuijingAdsPluginDelegate implements MethodChannel.MethodCallHandler{
    private final String TAG = "HuijingAdsPluginDelegate";
    private Activity activity;
    private RewardVideoAd rewardVideoAd;
    private InterstitialAd interstitialAd;
    private SplashAd splashAd;
    private BannerAd bannerAd;


    private FlutterPlugin.FlutterPluginBinding flutterPluginBinding;

    public HuijingAdsPluginDelegate(FlutterPlugin.FlutterPluginBinding flutterPluginBinding, Activity activity) {
        this.activity = activity;
        this.flutterPluginBinding = flutterPluginBinding;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall methodCall, @NonNull MethodChannel.Result result) {
        if (methodCall.method.equals("init")) {
            String appId = methodCall.argument("appId");
            String rewardId = methodCall.argument("rewardId");
            String interstitialId = methodCall.argument("interstitialId");
            String fullScreenId = methodCall.argument("fullScreenId");

            HJAdsSdk ads = HJAdsSdk.sharedAds();
            ads.setAdult(true);//是否成年（可选参数，默认是成年用户）
            ads.setPersonalizedAdvertisingOn(true);//是否开启个性化推荐接口（可选参数，建议开启）
            ads.setDebugEnable(true);//true开启、false关闭（默认开启）
            ads.startWithAppId((Application) this.activity.getApplicationContext(), appId);
            HJLog.d("###############rewardId: " + rewardId);
            HJLog.d("###############interstitialId: " + interstitialId);
            HJLog.d("###############fullScreenId: " + fullScreenId);
            HuijingAdPreviously huijingAdPreviously = HuijingAdPreviously.instance();
            huijingAdPreviously.startAdPreviously(rewardId, interstitialId, fullScreenId, this.activity);
			result.success(null);
        } else {
            result.notImplemented();
        }
    }

    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        rewardVideoAd = new RewardVideoAd(this.activity, this.flutterPluginBinding);
        rewardVideoAd.onAttachedToEngine();
        interstitialAd = new InterstitialAd(this.activity, this.flutterPluginBinding);
        interstitialAd.onAttachedToEngine();
        splashAd = new SplashAd(activity, flutterPluginBinding);
        splashAd.onAttachedToEngine();
        bannerAd = new BannerAd(activity, flutterPluginBinding);
        bannerAd.onAttachedToEngine();
        PlatformViewRegistry platformViewRegistry = this.flutterPluginBinding.getPlatformViewRegistry();
        platformViewRegistry.registerViewFactory(HuijingAdsPlugin.kHjBannerAdViewId,
                new HuijingNativeAdViewFactory(HuijingAdsPlugin.kHjBannerAdViewId, this.bannerAd, this.activity));

    }

    public void onDetachedFromActivity() {
        rewardVideoAd.onDetachedFromEngine();
        interstitialAd.onDetachedFromEngine();
        splashAd.onDetachedFromEngine();
        bannerAd.onDetachedFromEngine();
    }
}
