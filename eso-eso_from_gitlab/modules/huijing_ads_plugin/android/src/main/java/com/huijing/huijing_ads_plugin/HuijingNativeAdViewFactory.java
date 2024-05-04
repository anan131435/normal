package com.huijing.huijing_ads_plugin;

import android.app.Activity;
import android.content.Context;

import com.huijing.huijing_ads_plugin.banner.BannerAdView;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class HuijingNativeAdViewFactory extends PlatformViewFactory {
    private String viewName;
    private Activity activity;
    private FlutterPlugin.FlutterPluginBinding flutterPluginBinding;

    private HuijingBaseAd huijingBaseAd;

    public HuijingNativeAdViewFactory(String viewName, HuijingBaseAd huijingBaseAd, Activity activity) {
        super(StandardMessageCodec.INSTANCE);
        this.viewName = viewName;
        this.activity = activity;
        this.huijingBaseAd = huijingBaseAd;
    }


    @Override
    public PlatformView create(Context context, int viewId, Object args) {

        String uniqId = HuijingBaseAd.getArgument(args, "uniqId");
        HuijingBaseAd baseAd = huijingBaseAd.getAdInstance(uniqId);

        if (this.viewName.equals(HuijingAdsPlugin.kHjBannerAdViewId)) {
            return new BannerAdView(this.activity, baseAd);

        }
        return null;
    }
}
