package com.sskj.flutter_plugin_ad;

import android.app.Activity;
import android.content.Context;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.kc.openset.OSETBanner;
import com.kc.openset.OSETListener;
import com.sskj.flutter_plugin_ad.entity.AdEvent;
import com.sskj.flutter_plugin_ad.entity.AdType;
import com.sskj.flutter_plugin_ad.entity.EventType;

import java.util.Map;

import io.flutter.plugin.platform.PlatformView;

/**
 * Banner View
 */
@SuppressWarnings("unchecked")
class AdBannerView implements PlatformView {
    @NonNull
    private final FrameLayout frameLayout;
    private final PluginAdSetDelegate pluginDelegate;

    public static final String AD_ID = "adId";


    AdBannerView(@NonNull Context context, int id, @Nullable Map<String, Object> creationParams, PluginAdSetDelegate pluginDelegate) {
        this.pluginDelegate = pluginDelegate;
        frameLayout = (FrameLayout) LayoutInflater.from(context).inflate(R.layout.view_adbanner, null);
        String posId = (String) creationParams.get(AD_ID);
        if(TextUtils.isEmpty(posId)){
            this.pluginDelegate.addEvent(new AdEvent(EventType.onAdError,"参数错误，posId 不能为空"));
            return;
        }
        loadBannerAd(this.pluginDelegate.activity,posId);
    }

    @NonNull
    @Override
    public View getView() {
        return frameLayout;
    }

    @Override
    public void dispose() {

    }


    public void loadBannerAd(Activity activity,String adId) {

        OSETBanner.getInstance().setWHScale(0.15625);//只对穿山甲起作用
        OSETBanner.getInstance().show(activity, adId, frameLayout, new OSETListener() {
            @Override
            public void onShow() {
//                Toast.makeText(activity, "onShow", Toast.LENGTH_SHORT).show();
                pluginDelegate.addEvent(new AdEvent(EventType.onAdExposure, "", AdType.BANNER));
            }

            @Override
            public void onError(String s, String s1) {
//                Toast.makeText(activity, "onError", Toast.LENGTH_SHORT).show();
                Log.e("openseterror", "code:" + s + "----message:" + s1);
                pluginDelegate.addEvent(new AdEvent(EventType.onAdError, "", AdType.BANNER));
            }


            @Override
            public void onClick() {
                pluginDelegate.addEvent(new AdEvent(EventType.onAdClicked,"", AdType.BANNER));
//                Toast.makeText(activity, "onClick", Toast.LENGTH_SHORT).show();
            }

            @Override
            public void onClose() {
                Toast.makeText(activity, "onClose", Toast.LENGTH_SHORT).show();
            }
        });
    }
}