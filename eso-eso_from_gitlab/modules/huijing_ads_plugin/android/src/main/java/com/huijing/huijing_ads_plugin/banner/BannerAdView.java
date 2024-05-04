package com.huijing.huijing_ads_plugin.banner;

import static android.view.ViewGroup.LayoutParams.MATCH_PARENT;

import android.app.Activity;
import android.view.View;
import android.widget.FrameLayout;


import com.huijing.huijing_ads_plugin.HuijingBaseAd;

import io.flutter.plugin.platform.PlatformView;

public class BannerAdView implements PlatformView {
    private FrameLayout contentView;

    public BannerAdView() {
    }

    public BannerAdView(Activity activity, HuijingBaseAd bannerAd) {

        contentView = new FrameLayout(activity);
        contentView.setLayoutParams(new FrameLayout.LayoutParams(MATCH_PARENT, MATCH_PARENT));

        if (bannerAd != null) {
            ((BannerAd) bannerAd).showAd(contentView);
        }
    }

    @Override
    public View getView() {
        return this.contentView;
    }

    @Override
    public void dispose() {
        this.contentView.removeAllViews();
    }
}
