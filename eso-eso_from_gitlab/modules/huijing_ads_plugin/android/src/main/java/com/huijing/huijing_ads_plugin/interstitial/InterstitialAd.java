package com.huijing.huijing_ads_plugin.interstitial;

import static com.huijing.huijing_ads_plugin.HuijingAdsPlugin.HuijingEventAdClicked;
import static com.huijing.huijing_ads_plugin.HuijingAdsPlugin.HuijingEventAdClose;
import static com.huijing.huijing_ads_plugin.HuijingAdsPlugin.HuijingEventAdExposure;
import static com.huijing.huijing_ads_plugin.HuijingAdsPlugin.HuijingEventAdFailed;
import static com.huijing.huijing_ads_plugin.HuijingAdsPlugin.HuijingEventAdSucceed;
import static com.huijing.huijing_ads_plugin.HuijingAdsPlugin.HuijingEventAdVideoComplete;

import android.app.Activity;


import com.huijing.huijing_ads_plugin.HuijingAd;
import com.huijing.huijing_ads_plugin.HuijingAdPreviously;
import com.huijing.huijing_ads_plugin.HuijingBaseAd;
import com.hzhj.openads.HJAdsSdkInterstitial;
import com.hzhj.openads.domain.HJAdError;
import com.hzhj.openads.listener.HJOnAdsSdkInterstitialListener;
import com.hzhj.openads.req.HJAdRequest;
import com.hzhj.openads.req.HJInterstitialAdRequest;
import com.hzhj.openads.utils.HJLog;

import java.util.HashMap;
import java.util.Map;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class InterstitialAd extends HuijingBaseAd implements MethodChannel.MethodCallHandler{
    private MethodChannel channel;
    private MethodChannel adChannel;
    private Activity activity;
    private FlutterPlugin.FlutterPluginBinding flutterPluginBinding;
    private HJAdsSdkInterstitial interstitialAd;
    private HuijingAd<HuijingBaseAd> ad;

    public InterstitialAd() {
    }

    public InterstitialAd(Activity activity, FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        this.activity = activity;
        this.flutterPluginBinding = flutterPluginBinding;
        ad = new HuijingAd<>();
    }

    @Override
    public void setup(MethodChannel channel, HJAdRequest adRequest, Activity activity) {
        super.setup(channel, adRequest, activity);
        this.adChannel = channel;
        this.activity = activity;
        this.interstitialAd = null;
        HuijingAdPreviously huijingAdPreviously = HuijingAdPreviously.instance();
        if (adRequest.getPlacementId().equals(huijingAdPreviously.getInterstitialId())) {
            Log.d("HJ-log", "##########interstitial setup");
            this.interstitialAd = huijingAdPreviously.getPrevInterstitialAd();
        } else if (adRequest.getPlacementId().equals(huijingAdPreviously.getFullScreenId())){
            Log.d("HJ-log", "##########fullScreen setup");
            this.interstitialAd = huijingAdPreviously.getPrevFullScreenAd();
        }
        Log.d("HJ-log", "##########interstitial setup 1111");
        if (this.interstitialAd == null || !this.interstitialAd.isReady()) {
            this.interstitialAd = new HJAdsSdkInterstitial(activity, new HJInterstitialAdRequest(adRequest.getPlacementId(), adRequest.getUserId(), adRequest.getOptions()),
                    new IHJOnAdsSdkInterstitialListener(this, channel));
        } else {
            this.interstitialAd.setInterstitialAdListener(new IHJOnAdsSdkInterstitialListener(this, channel));
        }
    }

    public void onAttachedToEngine() {
        Log.d("HJ-log", "onAttachedToEngine");
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "com.huijingads/interstitial");
        channel.setMethodCallHandler(this);
    }

    public void onDetachedFromEngine() {
        Log.d("HJ-log", "onDetachedFromEngine");
        if (channel != null) {
            channel.setMethodCallHandler(null);
        }
    }


    public HuijingBaseAd getAdInstance(String uniqId) {
        return this.ad.getAdInstance(uniqId);
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        Log.d("HJ-log", "-- onMethodCall: " + call.method + ", arguments: " + call.arguments);
        String uniqId = call.argument("uniqId");

        HuijingBaseAd interstitialAd = this.ad.getAdInstance(uniqId);
        if (interstitialAd == null) {
            interstitialAd = this.ad.createAdInstance(InterstitialAd.class, getArguments(call.arguments), flutterPluginBinding, HuijingAd.AdType.Interstitial, activity);
        }
        if (interstitialAd != null) {
            interstitialAd.excuted(call, result);
        }
    }

    public Object isReady(MethodCall call) {
        return this.interstitialAd.isReady();
    }

    public Object load(MethodCall call) {
        if (!this.interstitialAd.isReady()) {
            HJLog.d("############### interstitialAd load 2222");
            this.interstitialAd.loadAd();
        } else {
            adChannel.invokeMethod(HuijingEventAdSucceed, null);
        }
        return null;
    }

    private Object showAd(MethodCall call) {
        HashMap<String, String> options = call.argument("options");
        this.interstitialAd.show(options);
        return null;
    }

    private Object destroy(MethodCall call) {

        if (this.interstitialAd != null) {
            this.interstitialAd.destroy();
        }

        if (this.adChannel != null) {
            this.adChannel.setMethodCallHandler(null);
        }
        return null;
    }
}

class IHJOnAdsSdkInterstitialListener implements HJOnAdsSdkInterstitialListener {
    private MethodChannel channel;
    private InterstitialAd interstitialAd;

    public IHJOnAdsSdkInterstitialListener(InterstitialAd interstitialAd, MethodChannel channel) {
        this.channel = channel;
        this.interstitialAd = interstitialAd;
    }
    @Override
    public void onInterstitialAdLoadSuccess(String s) {
        channel.invokeMethod(HuijingEventAdSucceed, null);
    }

    @Override
    public void onInterstitialAdPlayStart() {
        channel.invokeMethod(HuijingEventAdExposure, null);
    }

    @Override
    public void onInterstitialAdPlayEnd() {
        channel.invokeMethod(HuijingEventAdVideoComplete, null);
    }

    @Override
    public void onInterstitialAdClicked() {
        channel.invokeMethod(HuijingEventAdClicked, null);
    }

    @Override
    public void onInterstitialAdClosed() {
        channel.invokeMethod(HuijingEventAdClose, null);
    }

    @Override
    public void onInterstitialAdLoadError(HJAdError hjAdError, String s) {
        Map<String, Object> args = new HashMap<String, Object>();
        args.put("code", hjAdError.code);
        args.put("message", hjAdError.msg);

        channel.invokeMethod(HuijingEventAdFailed, args);
    }

    @Override
    public void onInterstitialAdPlayError(HJAdError hjAdError, String s) {
        Map<String, Object> args = new HashMap<String, Object>();
        args.put("code", hjAdError.code);
        args.put("message", hjAdError.msg);

        channel.invokeMethod(HuijingEventAdFailed, args);
    }
}
