# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile
#-keep class com.bytedance.sdk.openadsdk.** { *; }
#-keep public interface com.bytedance.sdk.openadsdk.downloadnew.** {*;}
# 代码混淆压缩比，在0~7之间，默认为5，一般不做修改
#-optimizationpasses 5

# 混合时不使用大小写混合，混合后的类名为小写
#-dontusemixedcaseclassnames
-ignorewarnings
-keep class com.test.**{*;}
#open_ad_sdk
-keep class com.bytedance.sdk.openadsdk.** { *; }
-keep public interface com.bytedance.sdk.openadsdk.downloadnew.** {*;}
-keep class com.ss.**{*;}
-dontwarn com.ss.**

#推送广告  start
-keep class com.mob.**{*;}
-dontwarn com.mob.**
#推送广告 end

#opendsp start
-keep class com.od.**{*;}
-dontwarn com.od.**
#opendsp end

#openset start
-keep class com.kc.openset.**{*;}
-dontwarn com.kc.openset.**
#openset end

#oaid start
-keep class com.asus.msa.**{*;}
-keep class com.bun.**{*;}
-keep class com.huawei.hms.ads.identifier.**{*;}
-keep class com.netease.nis.sdkwrapper.**{*;}
-keep class com.samsung.android.deviceidservice.**{*;}
-keep class com.zui.**{*;}
-keep class XI.**{*;}
#oaid end


#leto aar
-dontwarn com.ledong.lib.**
-keep class com.ledong.lib.** {*;}

-dontwarn com.leto.game.**
-keep class com.leto.game.** {*;}

-dontwarn com.mgc.leto.**
-keep class com.mgc.leto.** {*;}
-keep class com.leto.sandbox.** {*;}

#快手
-keep class org.chromium.** {*;}
-keep class org.chromium.** { *; }
-keep class aegon.chrome.** { *; }
-keep class com.kwai.**{ *; }
-keep class com.kwad.**{ *; }
-dontwarn com.kwai.**
-dontwarn com.kwad.**
-dontwarn com.ksad.**
-dontwarn aegon.chrome.**
#快手

# WindAd
-keep class com.sigmob.**{*;}
-dontwarn com.sigmob.**

#oaid
-keep class com.bun.supplier.** {*;}
-dontwarn com.bun.supplier.core.**
-keep class XI.**{*;}
-keep class com.bun.miitmdid.**{*;}
#oaid

#广点通 start
-keep class com.qq.e.** {*;}
-dontwarn com.qq.e.**
#广点通 end

#小说 start
-keep class com.iBookStar.** {*;}
-dontwarn com.iBookStar.**
#小说 end

#-------------- okhttp3 start-------------
# OkHttp3
# https://github.com/square/okhttp
# okhttp
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.squareup.okhttp.* { *; }
-keep interface com.squareup.okhttp.** { *; }
-dontwarn com.squareup.okhttp.**

# okhttp 3
-keepattributes Signature
-keepattributes *Annotation*
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**

# Okio
-dontwarn com.squareup.**
-dontwarn okio.**
-keep public class org.codehaus.* { *; }
-keep public class java.nio.* { *; }
#----------okhttp end--------------


# log start
-keep class com.aliyun.sls.android.producer.* { *; }
-keep interface com.aliyun.sls.android.producer.* { *; }
# log end

# 倍孜混淆
-dontwarn com.beizi.fusion.**
-dontwarn com.beizi.ad.**
-keep class com.beizi.fusion.** {*; }
-keep class com.beizi.ad.** {*; }

-keep class com.qq.e.** {
    public protected *;
}

-keepattributes Exceptions,InnerClasses,Signature,Deprecated,SourceFile,LineNumberTable,*Annotation*,EnclosingMethod

-dontwarn  org.apache.**

#加固
#-keep @com.qihoo.SdkProtected.OSETSDK.Keep class **{*;}
#-keep,allowobfuscation interface com.qihoo.SdkProtected.OSETSDK.Keep

###Glide
#-dontwarn com.bumptech.glide.**
#-keep class com.bumptech.glide.**{*;}
#-keep public class * implements com.bumptech.glide.module.GlideModule
#-keep public class * extends com.bumptech.glide.AppGlideModule
#-keep public enum com.bumptech.glide.load.resource.bitmap.ImageHeaderParser$** {
#  **[] $VALUES;
#  public *;
#}

# 阿里TanxAd start
-dontwarn com.alibaba.fastjson.**

-keep class com.alibaba.fastjson.**{*;}
-keep class com.bumptech.glide.**{*;}

-keep class com.alimm.tanx.**{*;}

# 有进程间通信,保证service相关不被混淆
#-keep public class * extends android.app.Service
#-keep public class * extends android.content.BroadcastReceiver

# 自动曝光数据的防混淆
-keep class * implements java.io.Serializable{
     <fields>;
    <methods>;
}
# 阿里TanxAd end