package com.huijing.huijing_ads_plugin;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.text.TextUtils;
import android.widget.Toast;

import androidx.annotation.NonNull;
import com.hzhj.openads.HJAdsSdkInterstitial;
import com.hzhj.openads.HJAdsSdkReward;
import com.hzhj.openads.domain.HJAdError;
import com.hzhj.openads.listener.HJOnAdsSdkInterstitialListener;
import com.hzhj.openads.listener.HJOnAdsSdkRewardListener;
import com.hzhj.openads.req.HJInterstitialAdRequest;
import com.hzhj.openads.req.HJRewardAdRequest;
import com.hzhj.openads.utils.HJLog;

import java.util.Timer;
import java.util.TimerTask;

public class HuijingAdPreviously {
    private static HuijingAdPreviously mInstance;
    private Activity activity;
    private String rewardId;
    private String interstitialId;
    private String fullScreenId;
    private HJAdsSdkReward prevRewardAd;
    private HJAdsSdkInterstitial prevInterstitialAd;
    private HJAdsSdkInterstitial prevFullScreenAd;

    private final Timer timer = new Timer();
    private TimerTask task;

    public HJAdsSdkReward getPrevRewardAd() {
        return prevRewardAd;
    }
    public String getInterstitialId() {
        return this.interstitialId;
    }
    public String getFullScreenId() {
        return this.fullScreenId;
    }
    public HJAdsSdkInterstitial getPrevInterstitialAd() {
        return prevInterstitialAd;
    }

    public HJAdsSdkInterstitial getPrevFullScreenAd() {
        return prevFullScreenAd;
    }

    private void rewardAdPrevHandler(int times) {
        times--;
        int finalTimes = times;
        HJAdsSdkReward rewardAd = new HJAdsSdkReward(activity, new HJRewardAdRequest(rewardId, null, null), new HJOnAdsSdkRewardListener() {
            @Override
            public void onVideoAdLoadSuccess(String s) {
                HJLog.d("##########预加载 onVideoAdLoadSuccess");
                Toast.makeText(activity, "激励预处理完成", Toast.LENGTH_SHORT).show();
            }

            @Override
            public void onVideoAdPlayEnd() {

            }

            @Override
            public void onVideoAdPlayStart() {

            }

            @Override
            public void onVideoAdClicked() {

            }

            @Override
            public void onVideoRewarded(String s) {

            }

            @Override
            public void onVideoAdClosed() {

            }

            @Override
            public void onVideoAdLoadError(HJAdError hjAdError, String s) {
                HJLog.d("##########预加载 onVideoAdLoadError error： " + hjAdError.msg);
                if (finalTimes > 0) {
                    HJLog.d("##########失败重试：" + finalTimes);
                    try {
                        Thread.sleep(500);
                    } catch (InterruptedException e) {
                        HJLog.e("预加载等待异常");
                    }
                    rewardAdPrevHandler(finalTimes);
                }
            }

            @Override
            public void onVideoAdPlayError(HJAdError hjAdError, String s) {

            }
        });
        rewardAd.loadAd();
        prevRewardAd = rewardAd;
    }

    private void interstitialAdPrevHandler(int times) {
        times--;
        int finalTimes = times;
        HJAdsSdkInterstitial interstitialAd = new HJAdsSdkInterstitial(activity, new HJInterstitialAdRequest(interstitialId, null, null), new HJOnAdsSdkInterstitialListener() {
            @Override
            public void onInterstitialAdLoadSuccess(String s) {
                HJLog.d("##########预加载 onInterstitialAdLoadSuccess");
                Toast.makeText(activity, "插屏预处理完成", Toast.LENGTH_SHORT).show();
            }

            @Override
            public void onInterstitialAdPlayStart() {

            }

            @Override
            public void onInterstitialAdPlayEnd() {

            }

            @Override
            public void onInterstitialAdClicked() {

            }

            @Override
            public void onInterstitialAdClosed() {

            }

            @Override
            public void onInterstitialAdLoadError(HJAdError hjAdError, String s) {
                HJLog.d("##########预加载 onInterstitialAdLoadError error： " + hjAdError.msg);
                if (finalTimes > 0) {
                    HJLog.d("##########失败重试：" + finalTimes);
                    try {
                        Thread.sleep(500);
                    } catch (InterruptedException e) {
                        HJLog.e("预加载等待异常");
                    }
                    interstitialAdPrevHandler(finalTimes);
                }
            }

            @Override
            public void onInterstitialAdPlayError(HJAdError hjAdError, String s) {

            }
        });
        interstitialAd.loadAd();
        prevInterstitialAd = interstitialAd;
    }

    private void fullScreenAdPrevHandler(int times) {
        times--;
        int finalTimes = times;
        HJAdsSdkInterstitial interstitialAd = new HJAdsSdkInterstitial(activity, new HJInterstitialAdRequest(fullScreenId, null, null), new HJOnAdsSdkInterstitialListener() {
            @Override
            public void onInterstitialAdLoadSuccess(String s) {
                HJLog.d("##########预加载 fullScreen onInterstitialAdLoadSuccess");
                Toast.makeText(activity, "全屏预处理完成", Toast.LENGTH_SHORT).show();
            }

            @Override
            public void onInterstitialAdPlayStart() {

            }

            @Override
            public void onInterstitialAdPlayEnd() {

            }

            @Override
            public void onInterstitialAdClicked() {

            }

            @Override
            public void onInterstitialAdClosed() {

            }

            @Override
            public void onInterstitialAdLoadError(HJAdError hjAdError, String s) {
                HJLog.d("##########预加载 fullScreen onInterstitialAdLoadError error： " + hjAdError.msg);
                if (finalTimes > 0) {
                    HJLog.d("##########失败重试：" + finalTimes);
                    try {
                        Thread.sleep(500);
                    } catch (InterruptedException e) {
                        HJLog.e("预加载等待异常");
                    }
                    fullScreenAdPrevHandler(finalTimes);
                }
            }

            @Override
            public void onInterstitialAdPlayError(HJAdError hjAdError, String s) {

            }
        });
        interstitialAd.loadAd();
        prevFullScreenAd = interstitialAd;
    }

    Handler handler = new Handler(Looper.getMainLooper()){
        @SuppressLint("HandlerLeak")
        @Override
        public void handleMessage(@NonNull Message msg) {
            switch(msg.what){
                case 1000:
                    if (!TextUtils.isEmpty(rewardId)) {
                        HJLog.d("##########预加载 reward 1111");
                        if (prevRewardAd == null || !prevRewardAd.isReady()) {
                            HJLog.d("##########预加载 reward 2222");
                            rewardAdPrevHandler(2);
                        }
                    }
                    if (!TextUtils.isEmpty(interstitialId)) {
                        HJLog.d("##########预加载 interstitial 1111");
                        if (prevInterstitialAd == null || !prevInterstitialAd.isReady()) {
                            HJLog.d("##########预加载 interstitial 2222");
                            interstitialAdPrevHandler(2);
                        }
                    }
                    if (!TextUtils.isEmpty(fullScreenId)) {
                        HJLog.d("##########预加载 fullScreen 1111");
                        if (prevFullScreenAd == null || !prevFullScreenAd.isReady()) {
                            HJLog.d("##########预加载 fullScreen 2222");
                            fullScreenAdPrevHandler(2);
                        }
                    }
                break;
            }
        }
    };
    private HuijingAdPreviously() {
    }
    public static HuijingAdPreviously instance() {
        if (mInstance == null) {
            synchronized (HuijingAdPreviously.class) {
                if (mInstance == null) {
                    mInstance = new HuijingAdPreviously();
                }
            }
        }
        return mInstance;
    }
    public void startAdPreviously(String rewardId, String interstitialId, String fullScreenId, Activity activity) {
        if (!TextUtils.isEmpty(interstitialId) || !TextUtils.isEmpty(rewardId) || !TextUtils.isEmpty(fullScreenId)) {
            this.rewardId = rewardId;
            this.interstitialId = interstitialId;
            this.fullScreenId = fullScreenId;
            this.activity = activity;
            task = new TimerTask() {
                @Override
                public void run() {
                    Message message = new Message();
                    message.what = 1000;
                    handler.sendMessage(message);
                }
            };
            timer.schedule(task, 1, 3600000);
        }
    }
}
