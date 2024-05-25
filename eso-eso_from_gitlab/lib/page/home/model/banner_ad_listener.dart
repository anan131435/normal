import 'package:eso/page/home/entity/banner_ad.dart';
import 'package:event_bus/event_bus.dart';
import 'package:huijing_ads_plugin/huijing_ads_plugin.dart';

class EsoBannerListener extends HjBannerListener<HjBannerAd> {

  @override
  void onAdAutoRefreshFail(HjBannerAd ad, HjError error) {
    print('flu-banner --- onAdAutoRefreshFail: ${error.message}');
  }


  @override
  void onAdAutoRefreshed(HjBannerAd ad) {
    print('#############Interstitial onAdSucceed');
  }

  @override
  void onAdShowError(HjBannerAd ad, HjError error) {
    print('flu-banner --- onAdShowError: ${error.message}');
  }

  @override
  void onAdClose() {
    print('flu-banner --- onAdClose');

  }

  @override
  void onAdExposure() {
    print('flu-banner --- onAdExposure');
  }

  @override
  void onAdFailed(HjError error) {
    print('flu-banner --- onAdFailed');
  }

  @override
  void onAdSucceed(HjBannerAd ad)  {
    eventBus.fire(BannerAd());
    print('flu-banner --- onAdSucceed');
  }

  @override
  void onAdClicked() {
    // TODO: implement onAdClicked
  }
}
