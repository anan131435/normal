package com.huijing.huijing_ads_plugin.reward;

import static com.huijing.huijing_ads_plugin.HuijingAdsPlugin.HuijingEventAdClicked;
import static com.huijing.huijing_ads_plugin.HuijingAdsPlugin.HuijingEventAdClose;
import static com.huijing.huijing_ads_plugin.HuijingAdsPlugin.HuijingEventAdExposure;
import static com.huijing.huijing_ads_plugin.HuijingAdsPlugin.HuijingEventAdFailed;
import static com.huijing.huijing_ads_plugin.HuijingAdsPlugin.HuijingEventAdReward;
import static com.huijing.huijing_ads_plugin.HuijingAdsPlugin.HuijingEventAdSucceed;
import static com.huijing.huijing_ads_plugin.HuijingAdsPlugin.HuijingEventAdVideoComplete;

import android.app.Activity;

import androidx.annotation.NonNull;

import com.huijing.huijing_ads_plugin.HuijingAd;
import com.huijing.huijing_ads_plugin.HuijingAdPreviously;
import com.huijing.huijing_ads_plugin.HuijingBaseAd;
import com.hzhj.openads.HJAdsSdkReward;
import com.hzhj.openads.domain.HJAdError;
import com.hzhj.openads.listener.HJOnAdsSdkRewardListener;
import com.hzhj.openads.req.HJAdRequest;
import com.hzhj.openads.req.HJRewardAdRequest;
import com.hzhj.openads.utils.HJLog;

import java.util.HashMap;
import java.util.Map;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class RewardVideoAd extends HuijingBaseAd implements MethodChannel.MethodCallHandler{
    private MethodChannel channel;
    private MethodChannel adChannel;

    private Activity activity;
    private FlutterPlugin.FlutterPluginBinding flutterPluginBinding;
    private HJAdsSdkReward rewardAd;
    private HuijingAd<HuijingBaseAd> ad;

    public RewardVideoAd() {
    }

    public RewardVideoAd(Activity activity, FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        this.activity = activity;
        this.flutterPluginBinding = flutterPluginBinding;
        ad = new HuijingAd<>();

    }

    @Override
    public void setup(MethodChannel channel, HJAdRequest adRequest, Activity activity) {
        super.setup(channel, adRequest, activity);
        this.adChannel = channel;
        this.activity = activity;
        this.rewardAd = HuijingAdPreviously.instance().getPrevRewardAd();
        if (this.rewardAd == null || !this.rewardAd.isReady()) {
            Log.d("HJ-log", "########## reward setup 2222");
            this.rewardAd = new HJAdsSdkReward(activity, new HJRewardAdRequest(adRequest.getPlacementId(), adRequest.getUserId(), adRequest.getOptions()), new IHJOnAdsSdkRewardListener(this, channel));
        } else {
            this.rewardAd.setRewardedAdListener(new IHJOnAdsSdkRewardListener(this, channel));
        }
    }

    public void onAttachedToEngine() {
        Log.d("HJ-log", "onAttachedToEngine");
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "com.huijingads/reward");
        channel.setMethodCallHandler(this);
    }

    public void onDetachedFromEngine() {
        Log.d("HJ-log", "onDetachedFromEngine");
        if (channel != null) {
            channel.setMethodCallHandler(null);
        }
    }

    @Override
    public void onMethodCall(@NonNull MethodCall methodCall, @NonNull MethodChannel.Result result) {
        Log.d("HJ-log", "-- onMethodCall: " + methodCall.method + ", arguments: " + methodCall.arguments);
        String uniqId = methodCall.argument("uniqId");

        HuijingBaseAd rewardVideoAd = this.ad.getAdInstance(uniqId);
        if (rewardVideoAd == null) {
            rewardVideoAd = this.ad.createAdInstance(RewardVideoAd.class, getArguments(methodCall.arguments), flutterPluginBinding, HuijingAd.AdType.Reward, activity);
        }
        if (rewardVideoAd != null) {
            rewardVideoAd.excuted(methodCall, result);
        }
    }
    public Object isReady(MethodCall call) {
        return this.rewardAd.isReady();
    }

    public Object load(MethodCall call) {
        if (!this.rewardAd.isReady()) {
            HJLog.d("############### rewardAd load 2222");
            this.rewardAd.loadAd();
        } else {
            adChannel.invokeMethod(HuijingEventAdSucceed, null);
        }
        return null;
    }


    private Object showAd(MethodCall call) {
        HashMap<String, String> options = call.argument("options");
        this.rewardAd.show(options);
        return null;
    }

    private Object destroy(MethodCall call) {
        if (this.rewardAd != null) {
            this.rewardAd.destroy();
        }
        if (this.adChannel != null) {
            this.adChannel.setMethodCallHandler(null);
        }
        return null;
    }
}
class IHJOnAdsSdkRewardListener implements HJOnAdsSdkRewardListener {

    private MethodChannel channel;
    private RewardVideoAd rewardVideoAd;

    public IHJOnAdsSdkRewardListener(final RewardVideoAd rewardVideoAd, final MethodChannel channel) {
        this.channel = channel;
        this.rewardVideoAd = rewardVideoAd;
    }


    @Override
    public void onVideoAdLoadSuccess(String s) {
        channel.invokeMethod(HuijingEventAdSucceed, null);
    }

    @Override
    public void onVideoAdPlayEnd() {
        channel.invokeMethod(HuijingEventAdVideoComplete, null);
    }

    @Override
    public void onVideoAdPlayStart() {
        channel.invokeMethod(HuijingEventAdExposure, null);
    }

    @Override
    public void onVideoAdClicked() {
        channel.invokeMethod(HuijingEventAdClicked, null);
    }

    @Override
    public void onVideoRewarded(String s) {
        Map<String, Object> args = new HashMap<String, Object>();
        args.put("trans_id", s);
        channel.invokeMethod(HuijingEventAdReward, args);
    }

    @Override
    public void onVideoAdClosed() {
        channel.invokeMethod(HuijingEventAdClose, null);
    }

    @Override
    public void onVideoAdLoadError(HJAdError hjAdError, String s) {
        Map<String, Object> args = new HashMap<String, Object>();
        args.put("code", hjAdError.code);
        args.put("message", hjAdError.msg);

        channel.invokeMethod(HuijingEventAdFailed, args);
    }

    @Override
    public void onVideoAdPlayError(HJAdError hjAdError, String s) {
        Map<String, Object> args = new HashMap<String, Object>();
        args.put("code", hjAdError.code);
        args.put("message", hjAdError.msg);

        channel.invokeMethod(HuijingEventAdFailed, args);
    }
}
