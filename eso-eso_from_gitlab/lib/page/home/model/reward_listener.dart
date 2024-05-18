
import 'package:eso/utils/local_storage_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:huijing_ads_plugin/huijing_ads_plugin.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';

class EsoRewardListener extends HjRewardListener<HjRewardAd> {
  Function(HjRewardAd rewardAd) loadCallBack;
  Function rewardCallBack;
  Function closeCallBack;
  EsoRewardListener({this.loadCallBack,this.rewardCallBack, this.closeCallBack}) :super() ;


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
