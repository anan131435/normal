import 'package:flutter/services.dart';
import 'hj_error.dart';
import 'package:event_bus/event_bus.dart';
mixin HjAdEvent {
  void onAdSucceed(Map<String, dynamic> arguments) {}
  void onAdExposure(Map<String, dynamic> arguments) {}
  void onAdClicked() {}
  void onAdClose() {}
  void onAdFailed(HjError error) {}
  void onVideoComplete() {}
  void onAdReward(Map<String, dynamic> arguments) {}
  void onAdAutoRefreshFail(HjError error, Map<String, dynamic> arguments) {}
  void onAdAutoRefreshed(Map<String, dynamic> arguments) {}
}
EventBus eventBus = EventBus();
mixin HjAdEventHandler {
   HjAdEvent delegate = null;

  Future<void> handleEvent(MethodCall call) async {
    try {
      if (delegate == null) return;
      Map<String, dynamic> arguments = {};
      if (call.arguments == null) {
        arguments.addAll(Map<String, dynamic>.from(call.arguments));
      }
      HjError error;
      if (arguments.containsKey('code')) {
        var errorCode = arguments['code'] as int;
        var msg = arguments['message'] as String;
        error = HjError(errorCode, msg);
      }
      switch (call.method) {
        case 'onAdSucceed':
          delegate.onAdSucceed(arguments);
          break;
        case 'onAdExposure':
          delegate.onAdExposure(arguments);
          break;
        case 'onAdClicked':
          delegate.onAdClicked();
          break;
        case 'onAdClose':
          delegate.onAdClose();
          break;
        case 'onAdFailed':
          delegate.onAdFailed(error);
          break;
        case 'onVideoComplete':
          delegate.onVideoComplete();
          break;
        case 'onAdReward':
          eventBus.fire(true);
    delegate.onAdReward(arguments);
          break;
        case 'onAdAutoRefreshed':
          delegate.onAdAutoRefreshed(arguments);
          break;
        case 'onAdAutoRefreshFail':
          delegate.onAdAutoRefreshFail(error, arguments);
          break;
      }
    } catch (_) {}
  }
}
