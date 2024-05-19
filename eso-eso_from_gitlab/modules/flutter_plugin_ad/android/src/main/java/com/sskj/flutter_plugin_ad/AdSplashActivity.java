package com.sskj.flutter_plugin_ad;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.widget.FrameLayout;

import androidx.fragment.app.FragmentActivity;

import com.kc.openset.OSETListener;
import com.kc.openset.OSETSplash;
import com.sskj.flutter_plugin_ad.entity.AdEvent;
import com.sskj.flutter_plugin_ad.entity.AdType;
import com.sskj.flutter_plugin_ad.entity.EventType;

public class AdSplashActivity extends FragmentActivity {

    private static final String TAG = "ADSET";

    private FrameLayout fl;
    private Activity activity;

    public static final String AD_ID = "adId";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_adsplash);

        activity = this;

        // 解析广告 id
        String adId = getIntent().getStringExtra(AD_ID);

        fl = findViewById(R.id.fl);
        OSETSplash.getInstance().show(AdSplashActivity.this, fl, adId, new OSETListener() {
            @Override
            public void onShow() {
//                Toast.makeText(activity, "onShow", Toast.LENGTH_SHORT).show();
            }

            @Override
            public void onError(String s, String s1) {
                Log.e(TAG, "code:" + s + "----message:" + s1);
//                Toast.makeText(activity, "onError", Toast.LENGTH_SHORT).show();
                PluginAdSetDelegate.getInstance().addEvent(new AdEvent(EventType.onAdError, "", AdType.SPLASH));
                finish();
            }

            @Override
            public void onClick() {
//                Toast.makeText(activity, "onClick", Toast.LENGTH_SHORT).show();
            }

            @Override
            public void onClose() {
                PluginAdSetDelegate.getInstance().addEvent(new AdEvent(EventType.onAdClosed, "", AdType.SPLASH));
                finish();
            }
        });
    }

    @Override
    protected void onResume() {
        super.onResume();
        Log.e(TAG, "onResume");
    }

    @Override
    protected void onPause() {
        super.onPause();
        Log.e(TAG, "onPause");
    }
}