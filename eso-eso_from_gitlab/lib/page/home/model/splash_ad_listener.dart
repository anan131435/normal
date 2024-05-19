import 'package:huijing_ads_plugin/huijing_ads_plugin.dart';

class SplashListener extends HjSplashListener<HjSplashAd> {
  Function loadSuccess;
  Function loadFailed;
  SplashListener({this.loadSuccess,this.loadFailed}) : super();
  @override
  void onAdSucceed(HjSplashAd ad) {
    print("xiuxiu开屏广告加载成功");
    loadSuccess();
  }
  @override
  void onAdClose() {
    print("xiuxiu开屏广告关闭");
  }

  @override
  void onAdClicked() {
    print("xiuxiu开屏广告点击");
  }

  @override
  void onAdFailed(HjError error) {
    print("xiuxiu开屏广告加载失败$error");
    loadFailed();
  }
  @override
  void onAdExposure() {
    print("xiuxiu开屏广告onAdExposure");
  }
}