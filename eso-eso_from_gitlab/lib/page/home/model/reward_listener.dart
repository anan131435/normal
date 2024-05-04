
import 'package:huijing_ads_plugin/huijing_ads_plugin.dart';

class EsoRewardListener extends HjRewardListener<HjRewardAd> {
  @override
  void onAdClicked() {
    // TODO: implement onAdClicked
  }

  @override
  void onAdClose() {
    // TODO: implement onAdClose
  }

  @override
  void onAdExposure() {
    // TODO: implement onAdExposure
  }

  @override
  void onAdFailed(HjError error) {
    print('flu-reward --- onAdFailed ${error.message} and ${error.code}');
  }

  @override
  void onAdReward(String transId) {
    // TODO: implement onAdReward
  }

  @override
  void onAdSucceed(HjRewardAd ad) {
    // TODO: implement onAdSucceed
    print('flu-reward --- onAdSucceed');
  }

  @override
  void onVideoComplete() {
    print('flu-reward --- onVideoComplete');
  }


}
