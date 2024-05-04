package com.huijing.huijing_ads_plugin;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodChannel;

/** HuijingAdsPlugin */
public class HuijingAdsPlugin implements FlutterPlugin, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  public static final String kHjBannerAdViewId = "flutter_hj_ads_banner";

  public static final String HuijingEventAdSucceed = "onAdSucceed";
  public static final String HuijingEventAdExposure = "onAdExposure";
  public static final String HuijingEventAdAutoRefreshed = "onAdAutoRefreshed";
  public static final String HuijingEventAdAutoRefreshFail = "onAdAutoRefreshFail";
  public static final String HuijingEventAdClicked = "onAdClicked";
  public static final String HuijingEventAdClose = "onAdClose";
  public static final String HuijingEventAdFailed = "onAdFailed";
  public static final String HuijingEventAdVideoComplete = "onVideoComplete";
  public static final String HuijingEventAdReward = "onAdReward";

  private MethodChannel channel;
  private HuijingAdsPluginDelegate delegate;//MethodCallHandler

  private FlutterPluginBinding flutterPluginBinding;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    this.flutterPluginBinding = flutterPluginBinding;
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "com.huijingads.ad");
  }


  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    if (channel != null) {
      channel.setMethodCallHandler(null);
    }
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    this.delegate = new HuijingAdsPluginDelegate(this.flutterPluginBinding, binding.getActivity());
    channel.setMethodCallHandler(this.delegate);
    this.delegate.onAttachedToActivity(binding);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity();
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    onAttachedToActivity(binding);
  }

  @Override
  public void onDetachedFromActivity() {
    this.delegate.onDetachedFromActivity();
    this.delegate = null;
  }
}
