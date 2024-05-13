
import 'package:eso/utils/local_storage_utils.dart';
import 'package:huijing_ads_plugin/huijing_ads_plugin.dart';
import 'package:intl/intl.dart';

class EsoRewardListener extends HjRewardListener<HjRewardAd> {
  Function(HjRewardAd rewardAd) loadCallBack;
  Function rewardCallBack;
  Function closeCallBack;
  EsoRewardListener({this.loadCallBack,this.rewardCallBack, this.closeCallBack});
  @override
  void onAdClicked() {
    print("xiuxiu点击广告了");
    print('_rewardAdonAdClickedEsoRewardListener');
  }

  @override
  void onAdClose() {
    closeCallBack();
    print("xiuxiu关闭广告了");
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
    //拿到奖励算一次
    DateTime now = DateTime.now();
    String dateStr = DateFormat.yMd().format(now);
    print("xiuxiu${dateStr}拿到奖励了");
    int showCount = LocalStorage.getInstance().get(dateStr);
    print("xiuxiu${dateStr}拿到了${showCount}次奖励");
    if (showCount == null ) {
      showCount = 1;
    } else {
      showCount += 1;
    }
    print("xiuxiu${dateStr}拿到了${showCount}次奖励");
    LocalStorage.getInstance().setData(dateStr, showCount);
  }

  @override
  void onAdSucceed(HjRewardAd ad) {
    print("xiuxiu加载到广告了");
    print('_rewardAdonAdSucceedEsoRewardListener');
    loadCallBack(ad);
  }

  @override
  void onVideoComplete() {
    print('_rewardAdonVideoCompleteEsoRewardListener');
  }


}
