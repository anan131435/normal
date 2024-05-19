package com.sskj.flutter_plugin_ad.entity;

import java.util.HashMap;

// 广告事件
public class AdEvent {
    String eventType=EventType.unknown;
    String msg="";
    String adType = "";

    public AdEvent(String eventType) {
        this.eventType = eventType;
        this.msg="";
    }

    public AdEvent(String eventType, String msg) {
        this.eventType = eventType;
        this.msg = msg;
    }

    public AdEvent(String eventType, String msg,String adType) {
        this.eventType = eventType;
        this.msg = msg;
        this.adType = adType;
    }

    @Override
    public String toString() {
        return "AdEvent{" +
                "eventType='" + eventType + '\'' +
                ", msg='" + msg + '\'' +
                '}';
    }

    public HashMap<String,String> toMap() {
        HashMap<String,String> map=new HashMap<String,String>();
        map.put("eventType",eventType);
        map.put("msg",msg);
        map.put("adType",adType);
        return map;
    }
}
