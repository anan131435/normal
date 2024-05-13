
import 'package:huijing_ads_plugin/huijing_ads_plugin.dart';

class EsoRewardListener extends HjRewardListener<HjRewardAd> {
  Function(HjRewardAd rewardAd) loadCallBack;
  Function rewardCallBack;
  Function closeCallBack;
  EsoRewardListener({this.loadCallBack,this.rewardCallBack, this.closeCallBack});
  @override
  void onAdClicked() {
    print('_rewardAdonAdClickedEsoRewardListener');
  }

  @override
  void onAdClose() {
    closeCallBack();
    print('_rewardAdonAdCloseEsoRewardListener');
  }

  @override
  void onAdExposure() {
    // TODO: implement onAdExposure
  }

  @override
  void onAdFailed(HjError error) {
    print('_rewardAdonAdFailedEsoRewardListener ${error.message} and ${error.code}');
  }

  @override
  void onAdReward(String transId) {
    rewardCallBack();
    print('_rewardAdonAdRewardEsoRewardListener');
  }

  @override
  void onAdSucceed(HjRewardAd ad) {
    print('_rewardAdonAdSucceedEsoRewardListener');
    loadCallBack(ad);
  }

  @override
  void onVideoComplete() {
    print('_rewardAdonVideoCompleteEsoRewardListener');
  }


}
