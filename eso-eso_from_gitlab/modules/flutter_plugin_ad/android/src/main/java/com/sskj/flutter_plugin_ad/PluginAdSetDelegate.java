package com.sskj.flutter_plugin_ad;

import android.Manifest;
import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import com.jiagu.sdk.OSETSDKProtected;
import com.kc.openset.OSETListener;
import com.kc.openset.OSETNews;
import com.kc.openset.OSETNewsListener;
import com.kc.openset.OSETOneiromancy;
import com.kc.openset.OSETSDK;
import com.kc.openset.OSETSplash;
import com.kc.openset.OSETStudy;
import com.kc.openset.OSETVideoContent;
import com.kc.openset.OSETVideoContentListener;
import com.kc.openset.OSETVideoListener;
import com.kc.openset.VideoContentConfig;
import com.kc.openset.ad.OSETInsertCache;
import com.kc.openset.OSETFullVideo;
import com.kc.openset.ad.OSETRewardVideoCache;
import com.kc.openset.listener.OSETInitListener;
import com.sskj.flutter_plugin_ad.callback.ClickItem;
import com.sskj.flutter_plugin_ad.entity.AdEvent;
import com.sskj.flutter_plugin_ad.entity.AdType;
import com.sskj.flutter_plugin_ad.entity.EventType;

import java.util.ArrayList;
import java.util.List;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;


public class PluginAdSetDelegate implements PluginRegistry.ActivityResultListener, EventChannel.StreamHandler, PluginRegistry.RequestPermissionsResultListener {

    private final String TAG = PluginAdSetDelegate.class.getSimpleName();
    public FlutterPlugin.FlutterPluginBinding bind;
    public Activity activity;

    private MethodChannel.Result pendingResult;
    private EventChannel.EventSink eventSink;
    // 请求权限 code
    private static final int PERMISSIONS_REQUEST_CODE = 1024;
    // 开屏广告 code
    private static final int SHOW_SPLASH_AD_REQUEST_CODE = 1025;
    // 广告参数
    public static final String AD_ID = "adId";
    public static final String USER_ID = "userId";
    private static PluginAdSetDelegate _instance;

    public static PluginAdSetDelegate getInstance() {
        return _instance;
    }

    public PluginAdSetDelegate(Activity activity, FlutterPlugin.FlutterPluginBinding bind) {
        this.bind = bind;
        this.activity = activity;
        _instance = this;
    }

    /**
     * 初始化
     *
     * @param call   MethodCall
     * @param result Result
     */
    public void initAd(MethodCall call, MethodChannel.Result result) {
        // 一定要在 Application 中初始化 sdk，第一个参数需要填入 Application，否则无 法正常使用 sdk
        String appKey = call.argument("appKey");
        if (TextUtils.isEmpty(appKey)) {
            result.error("-200", "参数错误，appKey 不能为空", new Exception("参数错误，appKey 不能为空"));
            return;
        }
        boolean isDebug = call.argument("isDebug");

        try {
            OSETSDKProtected.install(activity.getApplication());
            OSETSDK.getInstance().init(activity.getApplication(), appKey, new OSETInitListener() {
                @Override
                public void onError(String s) {

                }

                @Override
                public void onSuccess() {

                }
            });
            OSETSDK.getInstance().setIsDebug(isDebug);

            result.success(true);
            Log.d(TAG, "初始化完成");
        } catch (Exception e) {
            Log.d(TAG, "初始化失败 error:" + e.getMessage());
            result.error("-100", "初始化失败", e);
        }
    }

    public static boolean sFirst = true;

    /**
     * 展示开屏广告
     *
     * @param call   MethodCall
     * @param result Result
     */
    public void showSplashAd(MethodCall call, MethodChannel.Result result) {
        String adId = call.argument(AD_ID);
        if (TextUtils.isEmpty(adId)) {
            result.error("-300", "参数错误，posId 不能为空", new Exception("参数错误，posId 不能为空"));
            return;
        }
        ViewGroup decorView = (ViewGroup) activity.getWindow().getDecorView();
        ViewGroup fl = decorView.findViewById(android.R.id.content);
        FrameLayout frameLayout = new FrameLayout(activity);
        FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT);
        frameLayout.setLayoutParams(params);
        fl.addView(frameLayout);
        OSETSplash.getInstance().show(activity, frameLayout, adId, new OSETListener() {
            @Override
            public void onShow() {
//                Toast.makeText(activity, "onShow", Toast.LENGTH_SHORT).show();
                PluginAdSetDelegate.getInstance().addEvent(new AdEvent("onAdShow", "", AdType.SPLASH));
            }

            @Override
            public void onError(String s, String s1) {
                android.util.Log.e(TAG, "code:" + s + "----message:" + s1);
//                Toast.makeText(activity, "onError", Toast.LENGTH_SHORT).show();
                PluginAdSetDelegate.getInstance().addEvent(new AdEvent(EventType.onAdError, "", AdType.SPLASH));
                fl.removeView(frameLayout);
            }

            @Override
            public void onClick() {
//                Toast.makeText(activity, "onClick", Toast.LENGTH_SHORT).show();
                PluginAdSetDelegate.getInstance().addEvent(new AdEvent(EventType.onAdClicked, "", AdType.SPLASH));
            }

            @Override
            public void onClose() {
                PluginAdSetDelegate.getInstance().addEvent(new AdEvent(EventType.onAdClosed, "", AdType.SPLASH));
                fl.removeView(frameLayout);
            }
        });
    }

    public void showInterstitialAd(MethodCall call, MethodChannel.Result result) {
        String adId = call.argument(AD_ID);
        if (TextUtils.isEmpty(adId)) {
            result.error("-300", "参数错误，posId 不能为空", new Exception("参数错误，posId 不能为空"));
            return;
        }
        //在首页中OnCreate调用以下代码可以开始加载广告并缓存
        OSETInsertCache.getInstance()
                .setContext(activity)
                .setPosId(adId)
                .setOSETListener(interstitialOSETListener)
                .showAd(activity);
        result.success(true);
    }

    private final OSETListener interstitialOSETListener = new OSETListener() {
        @Override
        public void onClick() {
            addEvent(new AdEvent(EventType.onAdClicked, "", AdType.INTERSTITIAL));
        }

        @Override
        public void onClose() {
            addEvent(new AdEvent(EventType.onAdClosed, "", AdType.INTERSTITIAL));
        }

        @Override
        public void onShow() {
            addEvent(new AdEvent(EventType.onAdExposure, "", AdType.INTERSTITIAL));
        }

        @Override
        public void onError(String s, String s1) {
            addEvent(new AdEvent(EventType.onAdError, "", AdType.INTERSTITIAL));
        }
    };

    public void showFullscreenVideoAd(MethodCall call, MethodChannel.Result result) {
        String adId = call.argument(AD_ID);
        if (TextUtils.isEmpty(adId)) {
            result.error("-300", "参数错误，posId 不能为空", new Exception("参数错误，posId 不能为空"));
            return;
        }
        //在首页中OnCreate调用以下代码可以开始加载广告并缓存
        OSETFullVideo.getInstance()
                .setContext(activity)
                .setPosId(adId)
                .setOSETVideoListener(fullVideoOSETVideoListener)
                .showAd(activity);
        result.success(true);
    }

    private final OSETVideoListener fullVideoOSETVideoListener = new OSETVideoListener() {
        @Override
        public void onClick() {
            addEvent(new AdEvent(EventType.onAdClicked, "", AdType.FULL_SCREEN_VIDEO));
        }

        @Override
        public void onClose(String s) {
            //关闭回调
            //key（后台验证需要传过去）
            // 验证地址 http://open-set-api.shenshiads.com/reward/check/<key>（返回数据: {"code": 0}，code为0表示验证成
            android.util.Log.e("RewardVideo", "onClose---key:" + s);
            addEvent(new AdEvent(EventType.onAdClosed, "", AdType.FULL_SCREEN_VIDEO));
        }

        @Override
        public void onLoad() {

        }

        @Override
        public void onReward(String s, int i) {
            //奖励回调
            // 验证地址 http://open-set-api.shenshiads.com/reward/check/<key>（返回数据: {"code": 0}，code为0表示验证成
            Log.e("RewardVideo", "onReward---key:" + s);

            // 获得奖励后回调
            addEvent(new AdEvent(EventType.onReward, "", AdType.FULL_SCREEN_VIDEO));
        }

        @Override
        public void onServiceResponse(int i) {

        }

        @Override
        public void onShow(String s) {
            addEvent(new AdEvent(EventType.onAdExposure, "", AdType.FULL_SCREEN_VIDEO));
        }

        @Override
        public void onVideoEnd(String s) {
        }

        @Override
        public void onVideoStart() {
        }

        @Override
        public void onError(String s, String s1) {
            Log.e(TAG, "code:" + s + "----message:" + s1);
            // 出错了
            addEvent(new AdEvent(EventType.onAdError, "", AdType.FULL_SCREEN_VIDEO));
        }
    };


    public void showRewardVideo(MethodCall call, MethodChannel.Result result) {

        String adId = call.argument(AD_ID);
        String userId = call.argument(USER_ID);
        if (TextUtils.isEmpty(adId)) {
            result.error("-300", "参数错误，posId 不能为空", new Exception("参数错误，posId 不能为空"));
            return;
        }
        //这一步建议在首页进行初始化并开启缓存,减少第一次展示广告的时间。并且在首页onDestroy里面调用destroy()方法释放资源
        OSETRewardVideoCache.getInstance()
                .setContext(activity)
                .setPosId(adId)
                .setUserId(userId)
                .setOSETVideoListener(rewardOSETVideoListener)
                .showAd(activity);
        result.success(true);
    }

    private final OSETVideoListener rewardOSETVideoListener = new OSETVideoListener() {
        @Override
        public void onClick() {
            addEvent(new AdEvent(EventType.onAdClicked, "", AdType.REWARD_VIDEO));
        }

        @Override
        public void onClose(String s) {
            //关闭回调
            //key（后台验证需要传过去）
            // 验证地址 http://open-set-api.shenshiads.com/reward/check/<key>（返回数据: {"code": 0}，code为0表示验证成
            android.util.Log.e("RewardVideo", "onClose---key:" + s);
            addEvent(new AdEvent(EventType.onAdClosed, "", AdType.REWARD_VIDEO));
        }

        @Override
        public void onLoad() {

        }

        @Override
        public void onReward(String s, int i) {
            //奖励回调
            // 验证地址 http://open-set-api.shenshiads.com/reward/check/<key>（返回数据: {"code": 0}，code为0表示验证成
            Log.e("RewardVideo", "onReward---key:" + s);

            // 获得奖励后回调
            addEvent(new AdEvent(EventType.onReward, "", AdType.REWARD_VIDEO));
        }

        @Override
        public void onServiceResponse(int i) {

        }

        @Override
        public void onShow(String s) {
            Log.e("RewardVideo", "onShow---key:" + s);
            addEvent(new AdEvent(EventType.onAdExposure, "", AdType.REWARD_VIDEO));
        }

        @Override
        public void onVideoEnd(String s) {
        }

        @Override
        public void onVideoStart() {
        }

        @Override
        public void onError(String s, String s1) {
            Log.e(TAG, "code:" + s + "----message:" + s1);
            // 出错了
            addEvent(new AdEvent(EventType.onAdError, "", AdType.REWARD_VIDEO));
        }
    };

    public void showVideoPage(MethodCall call, MethodChannel.Result result) {
        String adId = call.argument(AD_ID);
        int rewardCount = call.argument("rewardCount");
        int rewardDownTime = call.argument("rewardDownTime");
        if (TextUtils.isEmpty(adId)) {
            result.error("-300", "参数错误，posId 不能为空", new Exception("参数错误，posId 不能为空"));
            return;
        }

        VideoContentConfig videoContentConfig = new VideoContentConfig.Builder().setPosIdRecommend(adId).setRewardCount(rewardCount).setRewardDownTime(rewardDownTime).build();
        OSETVideoContent.getInstance().showVideoContentForActivity(activity, videoContentConfig, new OSETVideoContentListener() {
            @Override
            public void onError(String code, String e) {
                Log.e(TAG, "code:" + code + "----message:" + e);
                // 出错了
                addEvent(new AdEvent(EventType.onAdError, "code: " + code + ", msg: " + e, AdType.VIDEO_CONTENT));
            }

            @Override
            public void onTimeOver() {
                super.onTimeOver();
                //key用做校验
                // 验证地址 http://open-set-api.shenshiads.com/reward/check/<key>（返回数据: {"code": 0}，code为0表示验证成
                addEvent(new AdEvent(EventType.onAdTimeOver, "", AdType.VIDEO_CONTENT));
            }

            @Override
            public void onClose() {
                super.onClose();
                //关闭回调
                addEvent(new AdEvent(EventType.onAdClosed, "", AdType.VIDEO_CONTENT));
            }

            @Override
            public void endVideo(int i, boolean isAd, String adId) {
                super.endVideo(i, isAd, adId);
                //视频结束播放
                android.util.Log.e(TAG, "视频结束播放:" + i);
            }

            @Override
            public void pauseVideo(int i, boolean isAd, String adId) {
                super.pauseVideo(i, isAd, adId);
                //视频暂停播放
                android.util.Log.e(TAG, "视频暂停播放:" + i);
            }

            @Override
            public void resumeVideo(int i, boolean isAd, String adId) {
                super.resumeVideo(i, isAd, adId);
                //视频重新播放
                android.util.Log.e(TAG, "视频重新播放:" + i);
            }

            @Override
            public void startVideo(int i, boolean isAd, String adId) {
                super.startVideo(i, isAd, adId);
                //视频开始播放
                android.util.Log.e(TAG, "视频开始播放:" + i);
            }
        });
        result.success(true);
    }

    public void showKsVideoFragment(MethodCall call, MethodChannel.Result result) {

        String adId = call.argument(AD_ID);
        if (TextUtils.isEmpty(adId)) {
            result.error("-300", "参数错误，posId 不能为空", new Exception("参数错误，posId 不能为空"));
            return;
        }

        Intent intent = new Intent(activity, KsAdActivity.class);
        intent.putExtra(AD_ID, adId);
        activity.startActivity(intent);
        activity.overridePendingTransition(0, 0);
        KsAdActivity.onClickItem(new ClickItem() {
            @Override
            public void selectItem(int index) {
                Log.e(TAG, "index: " + index);
                result.success(index);
                AdEvent adEvent = new AdEvent("KsVideoFragment", index + "");
                addEvent(adEvent);
            }
        });
    }


    private int answerCount = 5;

    public void showStudy(MethodCall call, MethodChannel.Result result) {

        String adRewardId = call.argument("adRewardId");
        String adInsertId = call.argument("adInsertId");
        String adBannerId = call.argument("adBannerId");
        String adAnswerCount = call.argument("adAnswerCount");
        if (TextUtils.isEmpty(adAnswerCount)) {
            answerCount = Integer.parseInt(adAnswerCount);
        }

        if (TextUtils.isEmpty(adRewardId) || TextUtils.isEmpty(adInsertId) || TextUtils.isEmpty(adBannerId) || TextUtils.isEmpty(adAnswerCount)) {
            result.error("-300", "参数错误，posId 不能为空", new Exception("参数错误，posId 不能为空"));
            return;
        }
        new OSETStudy().showStudy(activity, adRewardId, adInsertId, adBannerId, answerCount,
                new OSETVideoListener() {
                    @Override
                    public void onShow(String key) {

                    }

                    @Override
                    public void onError(String s, String s1) {

                    }

                    @Override
                    public void onClick() {

                    }

                    @Override
                    public void onClose(String s) {

                    }

                    @Override
                    public void onVideoEnd(String s) {

                    }

                    @Override
                    public void onLoad() {

                    }

                    @Override
                    public void onVideoStart() {

                    }

                    @Override
                    public void onReward(String s, int arg) {
//                        Log.e("aaaaaaaaaaaaaa", "答题一次");
                        answerCount--;
                    }

                    @Override
                    public void onServiceResponse(int i) {

                    }
                });
        result.success(true);
    }


    public void showNews(MethodCall call, MethodChannel.Result result) {

        String adNewsId = call.argument("adNewsId");
        String adInsertId = call.argument("adInsertId");
        String adBannerId = call.argument("adBannerId");

        if (TextUtils.isEmpty(adNewsId) || TextUtils.isEmpty(adInsertId) || TextUtils.isEmpty(adBannerId)) {
            result.error("-300", "参数错误，posId 不能为空", new Exception("参数错误，posId 不能为空"));
            return;
        }

        OSETNews.getInstance().setInsertId(adInsertId);
        OSETNews.getInstance().setBannerId(adBannerId);

        OSETNews.getInstance().showNews(activity, adNewsId, 0, 6, new OSETNewsListener() {
            @Override
            public void onTimeOver() {
                //倒计时结束回调
                //key用作校验
                // 验证地址 http://open-set-api.shenshiads.com/reward/check/<key>（返回数据: {"code": 0}，code为0表示验证成

            }

            @Override
            public void onClose() {
                //界面关闭回调
            }
        });
        result.success(true);
    }

    public void showOneiromancy(MethodCall call, MethodChannel.Result result) {

        String adRewardId = call.argument("adRewardId");
        String adBannerId = call.argument("adBannerId");

        if (TextUtils.isEmpty(adRewardId) || TextUtils.isEmpty(adBannerId)) {
            result.error("-300", "参数错误，posId 不能为空", new Exception("参数错误，posId 不能为空"));
            return;
        }

        OSETOneiromancy.getInstance().showOneiromancy(activity, adRewardId, adBannerId, new OSETVideoListener() {
            @Override
            public void onShow(String key) {

            }

            @Override
            public void onError(String code, String e) {

            }

            @Override
            public void onClick() {

            }

            @Override
            public void onClose(String key) {

            }

            @Override
            public void onVideoEnd(String key) {

            }

            @Override
            public void onLoad() {

            }

            @Override
            public void onReward(String s, int i) {

            }

            @Override
            public void onServiceResponse(int i) {

            }

            @Override
            public void onVideoStart() {

            }
        });
        result.success(true);
    }


    /**
     * 展示 Banner 广告
     */
    public void registerBannerView() {
        bind.getPlatformViewRegistry()
                .registerViewFactory("flutter_plugin_ad_banner", new AdNativeViewFactory("flutter_plugin_ad_banner", this));
    }


    /**
     * demo
     *
     * @param call   MethodCall
     * @param result Result
     */
    public void getPlatformVersion(MethodCall call, MethodChannel.Result result) {
        result.success("Android " + android.os.Build.VERSION.RELEASE);
    }

    /**
     * 检查并请求权限
     *
     * @param call   MethodCall
     * @param result Result
     */
    public void checkAndReqPermission(MethodCall call, MethodChannel.Result result) {
        // 如果targetSDKVersion >= 23，就要申请好权限。如果您的App没有适配到Android6.0（即targetSDKVersion < 23），那么只需要在这里直接调用fetchSplashAD接口。
        if (Build.VERSION.SDK_INT >= 23) {
            checkAndRequestPermission();
        }
        result.success(true);
    }

    /**
     * ----------非常重要----------
     * <p>
     * Android6.0以上的权限适配简单示例：
     * <p>
     * 如果targetSDKVersion >= 23，那么必须要申请到所需要的权限，再调用SDK，否则SDK不会工作。
     * <p>
     * Demo代码里是一个基本的权限申请示例，请开发者根据自己的场景合理地编写这部分代码来实现权限申请。
     * 注意：下面的`checkSelfPermission`和`requestPermissions`方法都是在Android6.0的SDK中增加的API，如果您的App还没有适配到Android6.0以上，则不需要调用这些方法，直接调用广点通SDK即可。
     */
    @TargetApi(Build.VERSION_CODES.M)
    private void checkAndRequestPermission() {
        List<String> lackedPermission = new ArrayList<>();
        if (!(activity.checkSelfPermission(android.Manifest.permission.READ_PHONE_STATE) == PackageManager.PERMISSION_GRANTED)) {
            lackedPermission.add(android.Manifest.permission.READ_PHONE_STATE);
        }

        if (!(activity.checkSelfPermission(android.Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED)) {
            lackedPermission.add(android.Manifest.permission.WRITE_EXTERNAL_STORAGE);
        }

        if (!(activity.checkSelfPermission(android.Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED)) {
            lackedPermission.add(android.Manifest.permission.ACCESS_FINE_LOCATION);
        }
        if (!(activity.checkSelfPermission(android.Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED)) {
            lackedPermission.add(Manifest.permission.ACCESS_COARSE_LOCATION);//申请经纬度坐标权限
        }

        if (lackedPermission.size() != 0) {
            // 请求所缺少的权限，在onRequestPermissionsResult中再看是否获得权限，如果获得权限就可以调用SDK，否则不要调用SDK。
            String[] requestPermissions = new String[lackedPermission.size()];
            lackedPermission.toArray(requestPermissions);
            activity.requestPermissions(requestPermissions, 1024);
        }
    }


    /**
     * 添加事件
     *
     * @param eventType
     */
    public void addEvent(String eventType) {
        Log.d(TAG, "addEvent eventType:" + eventType);
        if (eventType != null) {
            addEvent(new AdEvent(eventType));
        }
    }

    /**
     * 添加事件
     *
     * @param adEvent
     */
    public void addEvent(AdEvent adEvent) {
        if (eventSink != null && adEvent != null) {
            Log.d(TAG, "addEvent adEvent:" + adEvent.toMap());
            eventSink.success(adEvent.toMap());
        }
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        eventSink = events;
    }

    @Override
    public void onCancel(Object arguments) {
        eventSink = null;
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        return false;
    }

    @Override
    public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        return false;
    }
}
