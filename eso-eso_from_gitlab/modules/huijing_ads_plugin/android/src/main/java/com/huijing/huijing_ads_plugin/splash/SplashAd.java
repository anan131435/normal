package com.huijing.huijing_ads_plugin.splash;

import static com.huijing.huijing_ads_plugin.HuijingAdsPlugin.HuijingEventAdClicked;
import static com.huijing.huijing_ads_plugin.HuijingAdsPlugin.HuijingEventAdClose;
import static com.huijing.huijing_ads_plugin.HuijingAdsPlugin.HuijingEventAdExposure;
import static com.huijing.huijing_ads_plugin.HuijingAdsPlugin.HuijingEventAdFailed;
import static com.huijing.huijing_ads_plugin.HuijingAdsPlugin.HuijingEventAdSucceed;

import android.app.Activity;
import android.view.ViewGroup;
import android.view.WindowManager;


import com.huijing.huijing_ads_plugin.HuijingAd;
import com.huijing.huijing_ads_plugin.HuijingBaseAd;
import com.hzhj.openads.HJAdsSdkSplash;
import com.hzhj.openads.domain.HJAdError;
import com.hzhj.openads.listener.HJOnAdsSdkSplashListener;
import com.hzhj.openads.req.HJAdRequest;
import com.hzhj.openads.req.HJSplashAdRequest;

import android.os.Build;
import android.view.Window;

import java.util.HashMap;
import java.util.Map;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class SplashAd extends HuijingBaseAd implements MethodChannel.MethodCallHandler{
    private MethodChannel channel;
    private MethodChannel adChannel;

    private Activity activity;
    private FlutterPlugin.FlutterPluginBinding flutterPluginBinding;
    private HJSplashAdRequest splashAdRequest;
    private Map<String, Object> params;
    private HJAdsSdkSplash splashAdView;
    private HuijingAd<HuijingBaseAd> ad;

    private WindowManager.LayoutParams layoutParams;

    public SplashAd() {
    }

    public SplashAd(Activity activity, FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        this.activity = activity;
        this.flutterPluginBinding = flutterPluginBinding;
        ad = new HuijingAd<>();
    }

    public HuijingBaseAd getAdInstance(String uniqId) {
        if (ad != null) {
            return this.ad.getAdInstance(uniqId);
        }
        return null;
    }

    @Override
    public void setup(MethodChannel channel, HJAdRequest adRequest, Activity activity) {
        super.setup(channel, adRequest, activity);
        this.splashAdRequest = (HJSplashAdRequest) adRequest;
        this.adChannel = channel;
        this.activity = activity;
        this.splashAdView = new HJAdsSdkSplash(activity, this.splashAdRequest, new IHJOnAdsSdkSplashListener(this, channel));

    }

    public void onAttachedToEngine() {
        Log.d("HJ-log", "onAttachedToEngine");
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "com.huijingads/splash");
        channel.setMethodCallHandler(this);
    }

    public void onDetachedFromEngine() {
        Log.d("HJ-log", "onDetachedFromEngine");
        if (channel != null) {
            channel.setMethodCallHandler(null);
        }
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        Log.d("HJ-log", "-- onMethodCall: " + call.method + ", arguments: " + call.arguments);
        String uniqId = call.argument("uniqId");
        HuijingBaseAd splashAd = this.ad.getAdInstance(uniqId);

        if (splashAd == null) {

            splashAd = this.ad.createAdInstance(SplashAd.class, getArguments(call.arguments), flutterPluginBinding, HuijingAd.AdType.Splash, activity);
        }
        if (splashAd != null) {
            splashAd.excuted(call, result);
        }
    }


    void restoreNavigationBar() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            Window _window = this.activity.getWindow();
            if ((layoutParams.flags & WindowManager.LayoutParams.FLAG_FULLSCREEN) != WindowManager.LayoutParams.FLAG_FULLSCREEN) {
                _window.clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
            }
            _window.setAttributes(layoutParams);
        }
    }


    public Object load(MethodCall call) {
        this.splashAdView.loadAdOnly();
        return null;
    }

    public Object showAd(MethodCall call) {

        Window _window = this.activity.getWindow();
        layoutParams = new WindowManager.LayoutParams();
        layoutParams.copyFrom(_window.getAttributes());


        this.splashAdView.showAd((ViewGroup) this.activity.getWindow().getDecorView());
        return null;
    }

    public Object isReady(MethodCall call) {
        return this.splashAdView.isReady();
    }

    public Object destroy(MethodCall call) {
        if (this.adChannel != null) {
            this.adChannel.setMethodCallHandler(null);
        }
        return null;
    }
}

class IHJOnAdsSdkSplashListener implements HJOnAdsSdkSplashListener {
    private MethodChannel channel;
    private SplashAd splashAd;

    public IHJOnAdsSdkSplashListener(final SplashAd splashAd, final MethodChannel channel) {
        this.channel = channel;
        this.splashAd = splashAd;
    }
    @Override
    public void onSplashAdSuccessPresent() {
        channel.invokeMethod(HuijingEventAdExposure, null);
    }

    @Override
    public void onSplashAdSuccessLoad(String s) {
        channel.invokeMethod(HuijingEventAdSucceed, null);
    }

    @Override
    public void onSplashAdFailToLoad(HJAdError hjAdError, String s) {
        Map<String, Object> args = new HashMap<String, Object>();
        args.put("code", hjAdError.code);
        args.put("message", hjAdError.msg);

        channel.invokeMethod(HuijingEventAdFailed, args);
    }

    @Override
    public void onSplashAdClicked() {
        channel.invokeMethod(HuijingEventAdClicked, null);
    }

    @Override
    public void onSplashClosed() {
        channel.invokeMethod(HuijingEventAdClose, null);
        splashAd.restoreNavigationBar();
    }
}
