package com.sskj.flutter_plugin_ad;

import androidx.fragment.app.FragmentManager;

import android.os.Bundle;
import android.util.Log;
import android.widget.FrameLayout;

import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;
import androidx.annotation.NonNull;

import com.google.android.material.bottomnavigation.BottomNavigationView;
import com.google.android.material.bottomnavigation.LabelVisibilityMode;
import com.kc.openset.OSETVideoContent;
import com.kc.openset.VideoContentConfig;
import com.kc.openset.listener.OSETVideoContentFragmentListener;

import android.view.KeyEvent;
import android.view.MenuItem;

import com.sskj.flutter_plugin_ad.callback.ClickItem;
import com.sskj.flutter_plugin_ad.entity.EventType;

public class KsAdActivity extends FragmentActivity implements BottomNavigationView.OnNavigationItemSelectedListener {

    private static final String TAG = "ADSET";

    private static ClickItem mClickItem;

    private String adId;

    public static final String AD_ID = "adId";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_adks);

        // 解析广告 id
        adId = getIntent().getStringExtra(AD_ID);

        BottomNavigationView navigation = findViewById(R.id.navigation);
        BottomNavigationView bottomNavigationView = findViewById(R.id.navigation);
        navigation.setOnNavigationItemSelectedListener(this);
        bottomNavigationView.setLabelVisibilityMode(LabelVisibilityMode.LABEL_VISIBILITY_LABELED);
//        FragmentManager.enableNewStateManager(false);
        getShortVideo();


    }

    @Override
    public boolean onNavigationItemSelected(@NonNull MenuItem item) {
        int itemId = item.getItemId();
        if (itemId == R.id.navigation_home) {
            getShortVideo();
            return true;
        } else if (itemId == R.id.navigation_dashboard) {
            if (mClickItem != null) {
                mClickItem.selectItem(1);
                mClickItem = null;
            }
            finish();
            this.overridePendingTransition(0, 0);
            return true;
        } else if (itemId == R.id.navigation_notifications) {
            if (mClickItem != null) {
                mClickItem.selectItem(2);
                mClickItem = null;
            }
            finish();
            this.overridePendingTransition(0, 0);
            return true;
        } else if (itemId == R.id.navigation_my) {
            if (mClickItem != null) {
                mClickItem.selectItem(3);
                mClickItem = null;
            }
            finish();
            this.overridePendingTransition(0, 0);
            return true;
        }
        return false;

    }

    public static void onClickItem(ClickItem clickItem) {
        mClickItem = clickItem;
    }

    private void getShortVideo() {
        VideoContentConfig videoContentConfig = new VideoContentConfig.Builder().setPosIdRecommend(adId).build();
        OSETVideoContent.getInstance().showVideoContentForFragment(KsAdActivity.this, videoContentConfig, new OSETVideoContentFragmentListener() {
            @Override
            public void onError(String s, String s1) {

            }

            @Override
            public void loadSuccess(Fragment fragment) {
                getSupportFragmentManager().beginTransaction()
                        .replace(R.id.short_content, fragment)
                        .commitAllowingStateLoss();
            }

            @Override
            public void startVideo(int i, boolean isAd, String adId) {
                Log.e("videocontent", "startVideo--开始播放视频第" + i + "个");
            }

            @Override
            public void pauseVideo(int i, boolean isAd, String adId) {
                Log.e("videocontent", "pauseVideo--暂停播放视频第" + i + "个");
            }

            @Override
            public void resumeVideo(int i, boolean isAd, String adId) {
                Log.e("videocontent", "resumeVideo--继续播放视频第" + i + "个");
            }

            @Override
            public void endVideo(int i, boolean isAd, String adId) {
                Log.e("videocontent", "endVideo--完成播放视频第" + i + "个");
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

    @Override
    protected void onDestroy() {
        mClickItem = null;
        super.onDestroy();
    }

    @Override
    public boolean onKeyUp(int keyCode, KeyEvent event) {
        setResult(999, getIntent());
        return super.onKeyUp(keyCode, event);
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (mClickItem != null && keyCode == KeyEvent.KEYCODE_BACK) {
            mClickItem.selectItem(999);
            finish();
        }
        return false;
    }
}