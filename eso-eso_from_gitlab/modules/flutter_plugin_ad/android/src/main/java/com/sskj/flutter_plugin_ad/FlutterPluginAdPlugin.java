package com.sskj.flutter_plugin_ad;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterPluginAdPlugin
 */
@SuppressWarnings("unchecked")
public class FlutterPluginAdPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private EventChannel eventChannel;

    private FlutterPluginBinding bind;

    private PluginAdSetDelegate delegate;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        bind = flutterPluginBinding;
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_plugin_ad");
        channel.setMethodCallHandler(this);

        eventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_plugin_ad_event");
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("getPlatformVersion")) {
            delegate.getPlatformVersion(call, result);
        } else if (call.method.equals("initAd")) {
            delegate.initAd(call, result);
        } else if (call.method.equals("checkAndReqPermission")) {
            delegate.checkAndReqPermission(call, result);
        } else if (call.method.equals("showSplashAd")) {
            delegate.showSplashAd(call, result);
        } else if (call.method.equals("showInterstitialAd")) {
            delegate.showInterstitialAd(call, result);
        } else if (call.method.equals("showFullscreenVideoAd")) {
            delegate.showFullscreenVideoAd(call, result);
        } else if (call.method.equals("showRewardVideoAd")) {
            delegate.showRewardVideo(call, result);
        } else if (call.method.equals("showVideoPage")) {
            delegate.showVideoPage(call, result);
        } else if (call.method.equals("showKsVideoFragment")) {
            delegate.showKsVideoFragment(call, result);
        } else if (call.method.equals("showStudy")) {
            delegate.showStudy(call, result);
        } else if (call.method.equals("showNews")) {
            delegate.showNews(call, result);
        } else if (call.method.equals("showOneiromancy")) {
            delegate.showOneiromancy(call, result);
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        eventChannel.setStreamHandler(null);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {

        this.delegate = new PluginAdSetDelegate(binding.getActivity(), bind);
        binding.addActivityResultListener(delegate);
        binding.addRequestPermissionsResultListener(delegate);
        eventChannel.setStreamHandler(delegate);
        this.delegate.registerBannerView();
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
        this.delegate = null;
    }
}
