import 'package:flutter/services.dart';
import 'package:huijing_ads_plugin/huijing_ads_plugin.dart';

class HjRewardInfo {
   bool isReward;
   String transId;
   String userId;
  Map<String, dynamic> customData;
}

class HjRewardAd with HjAdEventHandler {
  static const MethodChannel _channel = MethodChannel('com.huijingads/reward');

  final HjAdRequest request;
   String _uniqId;
   MethodChannel _adChannel;

   HjRewardListener<HjRewardAd> _listener;

  HjRewardAd({
     this.request,
     HjRewardListener<HjRewardAd> listener,
  }) : super() {
    _uniqId = hashCode.toString();
    _listener = listener;
    delegate = IHjRewardListener(this, _listener);
    _adChannel = MethodChannel('com.huijingads/reward.$_uniqId');
    _adChannel.setMethodCallHandler(handleEvent);
  }

  Future<bool> isReady() async {
    bool isReady = await _channel.invokeMethod('isReady', {"uniqId": _uniqId});
    return isReady;
  }

  Future<void> loadAdData() async {
    await _channel
        .invokeMethod('load', {"uniqId": _uniqId, 'request': request.toJson()});
  }

  Future<void> showAd({Map<String, String> options}) async {
    await _channel.invokeMethod('showAd', {
      "uniqId": _uniqId,
      'request': request.toJson(),
      'options': options ?? {}
    });
  }

  Future<void> destroy() async {
    await _channel.invokeMethod('destroy', {"uniqId": _uniqId});
  }
}
