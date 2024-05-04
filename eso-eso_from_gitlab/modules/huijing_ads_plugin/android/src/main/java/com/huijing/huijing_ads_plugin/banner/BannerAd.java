package com.huijing.huijing_ads_plugin.banner;

import static android.view.ViewGroup.LayoutParams.MATCH_PARENT;

import static com.huijing.huijing_ads_plugin.HuijingAdsPlugin.HuijingEventAdAutoRefreshFail;
import static com.huijing.huijing_ads_plugin.HuijingAdsPlugin.HuijingEventAdAutoRefreshed;
import static com.huijing.huijing_ads_plugin.HuijingAdsPlugin.HuijingEventAdClicked;
import static com.huijing.huijing_ads_plugin.HuijingAdsPlugin.HuijingEventAdClose;
import static com.huijing.huijing_ads_plugin.HuijingAdsPlugin.HuijingEventAdExposure;
import static com.huijing.huijing_ads_plugin.HuijingAdsPlugin.HuijingEventAdFailed;
import static com.huijing.huijing_ads_plugin.HuijingAdsPlugin.HuijingEventAdSucceed;

import android.app.Activity;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import com.huijing.huijing_ads_plugin.HuijingAd;
import com.huijing.huijing_ads_plugin.HuijingBaseAd;
import com.hzhj.openads.HJAdsSdkBanner;
import com.hzhj.openads.domain.HJAdError;
import com.hzhj.openads.listener.HJOnAdsSdkBannerListener;
import com.hzhj.openads.req.HJAdRequest;
import com.hzhj.openads.req.HJBannerAdRequest;
import com.windmill.sdk.models.AdInfo;
import java.util.HashMap;
import java.util.Map;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class BannerAd extends HuijingBaseAd implements MethodChannel.MethodCallHandler {
    private MethodChannel channel;
    private Activity activity;
    private FlutterPlugin.FlutterPluginBinding flutterPluginBinding;
    private HJBannerAdRequest bannerAdRequest;
    private Map<String, Object> params;
    private MethodChannel adChannel;

    protected HJAdsSdkBanner hjAdsSdkBanner;
    private HuijingAd<HuijingBaseAd> ad;
    protected AdInfo adInfo;

    public BannerAd() {
    }

    public BannerAd(Activity activity, FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        this.activity = activity;
        this.flutterPluginBinding = flutterPluginBinding;
        ad = new HuijingAd<>();
    }

    @Override
    public HuijingBaseAd getAdInstance(String uniqId) {
        if (ad != null) {
            return this.ad.getAdInstance(uniqId);
        }
        return null;
    }

    @Override
    public void setup(MethodChannel channel, HJAdRequest adRequest, Activity activity) {
        super.setup(channel, adRequest, activity);
        this.bannerAdRequest = (HJBannerAdRequest) adRequest;
        this.adChannel = channel;
        this.activity = activity;
        this.hjAdsSdkBanner = new HJAdsSdkBanner(activity, new IHJOnAdsSdkBannerListener(channel, this));
    }

    public void onAttachedToEngine() {
        Log.d("HJ-log", "onAttachedToEngine");
        this.channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "com.huijingads/banner");
        channel.setMethodCallHandler(this);
    }

    public void onDetachedFromEngine() {
        Log.d("HJ-log", "onDetachedFromEngine");

        if (channel != null) {
            channel.setMethodCallHandler(null);
        }

    }

    public void showAd(ViewGroup adContainer) {
        if (adContainer != null) {
            this.hjAdsSdkBanner.showAd(adContainer, new FrameLayout.LayoutParams(MATCH_PARENT, MATCH_PARENT));
        }
    }

    @Override
    public void onMethodCall(final MethodCall call, final MethodChannel.Result result) {
        Log.d("HJ-log", "-- onMethodCall: " + call.method + ", arguments: " + call.arguments);
        String uniqId = call.argument("uniqId");
        HuijingBaseAd bannerAd = this.ad.getAdInstance(uniqId);

        if (bannerAd == null) {

            bannerAd = this.ad.createAdInstance(BannerAd.class, getArguments(call.arguments), flutterPluginBinding, HuijingAd.AdType.Banner, activity);
        }
        bannerAd.excuted(call, result);
    }

    public Object load(MethodCall call) {

        this.adInfo = null;
        this.hjAdsSdkBanner.loadAd(bannerAdRequest);
        return null;
    }

    public Object getAdInfo(MethodCall call) {
        if (this.adInfo != null) {
            return this.adInfo.toString();
        }
        return null;
    }

    public Object isReady(MethodCall call) {
        return this.hjAdsSdkBanner.isReady();
    }

    public Object destroy(MethodCall call) {
        this.hjAdsSdkBanner.destroy();
        if (this.adChannel != null) {
            this.adChannel.setMethodCallHandler(null);
        }
        return null;
    }

}

class IHJOnAdsSdkBannerListener implements HJOnAdsSdkBannerListener {

    private static final String TAG = IHJOnAdsSdkBannerListener.class.getSimpleName();
    private final BannerAd bannerAd;
    private MethodChannel channel;

    public IHJOnAdsSdkBannerListener(MethodChannel channel, BannerAd bannerAd) {
        this.channel = channel;
        this.bannerAd = bannerAd;
    }

    @Override
    public void onAdLoadSuccess(String placementId) {
        Log.d(TAG, "onAdLoadSuccess: ");
        Map<String, Object> args = new HashMap<String, Object>();
        args.put("width", bannerAd.hjAdsSdkBanner.getWidth() * 1.0f);
        args.put("height", bannerAd.hjAdsSdkBanner.getHeight() * 1.0f);
        channel.invokeMethod(HuijingEventAdSucceed, args);
    }

    @Override
    public void onAdLoadError(HJAdError hjAdError, String s) {
        Log.d(TAG, "onAdLoadError: ");
        Map<String, Object> args = new HashMap<String, Object>();
        args.put("code", hjAdError.code);
        args.put("message", hjAdError.msg);
        channel.invokeMethod(HuijingEventAdFailed, args);
    }

    @Override
    public void onAdShown() {
        Log.d(TAG, "onAdShown: ");
        Map<String, Object> args = new HashMap<String, Object>();
        args.put("width", bannerAd.hjAdsSdkBanner.getWidth() * 1.0f);
        args.put("height", bannerAd.hjAdsSdkBanner.getHeight() * 1.0f);
        channel.invokeMethod(HuijingEventAdExposure, args);
    }

    @Override
    public void onAdClicked() {
        channel.invokeMethod(HuijingEventAdClicked, null);
    }

    @Override
    public void onAdClosed() {
        channel.invokeMethod(HuijingEventAdClose, null);
    }

    @Override
    public void onAdAutoRefreshed() {
        Log.d(TAG, "onAdAutoRefreshed: ");
        Map<String, Object> args = new HashMap<String, Object>();
        args.put("width", bannerAd.hjAdsSdkBanner.getWidth() * 1.0f);
        args.put("height", bannerAd.hjAdsSdkBanner.getHeight() * 1.0f);
        channel.invokeMethod(HuijingEventAdAutoRefreshed, args);
    }

    @Override
    public void onAdAutoRefreshFail(HJAdError hjAdError, String s) {
        Log.d(TAG, "onAdAutoRefreshFail: ");
        Map<String, Object> args = new HashMap<String, Object>();
        args.put("code", hjAdError.code);
        args.put("message", hjAdError.msg);
        channel.invokeMethod(HuijingEventAdAutoRefreshFail, args);
    }
}
