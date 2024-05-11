
import 'package:huijing_ads_plugin/huijing_ads_plugin.dart';

class EsoRewardListener extends HjRewardListener<HjRewardAd> {
  Function(HjRewardAd rewardAd) loadCallBack;
  Function rewardCallBack;
  Function closeCallBack;
  EsoRewardListener({this.loadCallBack,this.rewardCallBack, this.closeCallBack});
  @override
  void onAdClicked() {
    print('rewardAdonAdClicked');
  }

  @override
  void onAdClose() {
    closeCallBack();
    print('rewardAdonAdClose');
  }

  @override
  void onAdExposure() {
    // TODO: implement onAdExposure
  }

  @override
  void onAdFailed(HjError error) {
    print('rewardAdonAdFailed ${error.message} and ${error.code}');
  }

  @override
  void onAdReward(String transId) {
    rewardCallBack();
    print('rewardAdonAdReward');
  }

  @override
  void onAdSucceed(HjRewardAd ad) {
    print('rewardAdonAdSucceed');
    loadCallBack(ad);
  }

  @override
  void onVideoComplete() {
    print('rewardAdonVideoComplete');
  }


}
