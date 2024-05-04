package com.huijing.huijing_ads_plugin;

import android.app.Activity;
import android.text.TextUtils;


import com.huijing.huijing_ads_plugin.utils.ResourceUtil;
import com.hzhj.openads.constant.HJConstants;
import com.hzhj.openads.req.HJAd;
import com.hzhj.openads.req.HJAdRequest;
import com.hzhj.openads.req.HJBannerAdRequest;
import com.hzhj.openads.req.HJRewardAdRequest;
import com.hzhj.openads.req.HJInterstitialAdRequest;
import com.hzhj.openads.req.HJSplashAdRequest;
import com.windmill.sdk.WMConstants;
import com.windmill.sdk.banner.WMBannerAdRequest;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodChannel;

public class HuijingAd <T>{
    public enum AdType {
        Reward,
        Splash,
        Interstitial,
        Banner
    }
    private Map<String, HuijingBaseAd> map = new HashMap<String, HuijingBaseAd>();

    public HuijingBaseAd getAdInstance(String uniqId) {
        if (map.containsKey(uniqId)) {
            return map.get(uniqId);
        }
        return null;
    }

    public T createAdInstance(Class<? extends T> cls, Map<String, Object> arguments,
                              FlutterPlugin.FlutterPluginBinding binding, HuijingAd.AdType adType, Activity activity) {

        try {
            Map<String, Object> options = new HashMap<String, Object>();

            String uniqId = (String) arguments.get("uniqId");
            Map<String, Object> requestMap = (Map<String, Object>) arguments.get("request");
            String placementId = (String) requestMap.get("placementId");
            String userId = (String) requestMap.get("userId");

            if (TextUtils.isEmpty(userId)) {
                userId = HJAd.getUserId();
            }

            if (requestMap.get("options") != null) {
                Map<String, String> options1 = (Map<String, String>) requestMap.get("options");
                if (options1 != null) {
                    options.putAll(options1);
                }
            }

            HJAdRequest adRequest = null;
            String channelName = null;
            switch (adType) {
                case Banner: {
                    channelName = "com.huijingads/banner." + uniqId;

                    if (arguments.containsKey("width")) {
                        Double width = (Double) arguments.get("width");

                        if (width.intValue() > 0) {
                            options.put(HJConstants.AD_WIDTH, width.intValue());// 针对于模版广告有效、单位dp
                            if (arguments.containsKey("height")) {
                                Double height = (Double) arguments.get("height");
                                options.put(HJConstants.AD_HEIGHT, height.intValue());// 自适应高度
                            } else {
                                options.put(HJConstants.AD_HEIGHT, WMConstants.AUTO_SIZE);// 自适应高度
                            }
                        }

                    }
                    adRequest = new HJBannerAdRequest(placementId, userId, options);
                }
                break;
                case Reward: {
                    adRequest = new HJRewardAdRequest(placementId, userId, options);

                    channelName = "com.huijingads/reward." + uniqId;
                }
                break;
                case Interstitial: {
                    adRequest = new HJInterstitialAdRequest(placementId, userId, options);

                    channelName = "com.huijingads/interstitial." + uniqId;
                }
                break;
                case Splash: {

                    String title = (String) arguments.get("title");
                    String desc = (String) arguments.get("desc");

                    if (!TextUtils.isEmpty(title)) {

                        int width = ResourceUtil.Instance().getWidth();
                        int height = ResourceUtil.Instance().getHeight() + ResourceUtil.Instance().getStatusBarHeight() - ResourceUtil.Instance().dip2Px(100);
                        options.put("ad_key_width", width);
                        options.put("ad_key_height", height);
                    }

                    adRequest = new HJSplashAdRequest(placementId, userId, options);
                    ((HJSplashAdRequest) adRequest).setAppTitle(title);
                    ((HJSplashAdRequest) adRequest).setAppDesc(desc);

                    channelName = "com.huijingads/splash." + uniqId;
                }
                break;
                default: {
                }
                break;

            }
            if (!TextUtils.isEmpty(channelName)) {
                MethodChannel channel = new MethodChannel(binding.getBinaryMessenger(), channelName);
                T t = cls.newInstance();
                HuijingBaseAd windmillBaseAd = (HuijingBaseAd) t;
                windmillBaseAd.setup(channel, adRequest, activity);
                map.put(uniqId, windmillBaseAd);
                return t;
            }

        } catch (Exception e) {
            // TODO: handle exception
        }
        return null;

    }
}
