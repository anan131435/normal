import 'package:huijing_ads_plugin/src/ads/splash/hj_splash.dart';
import 'package:huijing_ads_plugin/src/hj_error.dart';
import 'package:huijing_ads_plugin/src/hj_ad_event_handler.dart';
import 'package:huijing_ads_plugin/src/hj_listener.dart';

abstract class HjSplashListener<T> extends HjListener<T> {}

class IHjSplashListener with HjAdEvent {
  final HjSplashAd splashAd;
  final HjSplashListener<HjSplashAd> listener;

  IHjSplashListener(this.splashAd, this.listener);

  @override
  void onAdSucceed(Map<String, dynamic> arguments) {
    print("xiuxiu开屏广告加载OK");
    listener.onAdSucceed(splashAd);
  }

  @override
  void onAdFailed(HjError error) {
    print("xiuxiu开屏广告加载失败");
    listener.onAdFailed(error);
  }

  @override
  void onAdExposure(Map<String, dynamic> arguments) {
    listener.onAdExposure();
  }

  @override
  void onAdClicked() {
    listener.onAdClicked();
  }

  @override
  void onAdClose() {
    listener.onAdClose();
  }
}
