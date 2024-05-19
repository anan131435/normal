package com.sskj.flutter_plugin_ad;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Map;

import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

/**
 * 原生 View 工厂
 */
@SuppressWarnings("unchecked")
public class AdNativeViewFactory extends PlatformViewFactory {
    @NonNull
    private final String viewName;// View 名字
    private final PluginAdSetDelegate pluginDelegate; // 插件代理类

    public AdNativeViewFactory(String viewName, @NonNull PluginAdSetDelegate pluginDelegate) {
        super(StandardMessageCodec.INSTANCE);
        this.viewName = viewName;
        this.pluginDelegate = pluginDelegate;
    }

    @NonNull
    @Override
    public PlatformView create(@NonNull Context context, int id, @Nullable Object args) {
        final Map<String, Object> creationParams = (Map<String, Object>) args;
        if (this.viewName.equals("flutter_plugin_ad_banner")) {
            return new AdBannerView(context, id, creationParams, pluginDelegate);
        }
        return null;
//        else {
//            return new RecycleAdView(context, id, creationParams, pluginDelegate);
//        }


    }
}