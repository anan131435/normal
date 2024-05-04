#import <Foundation/Foundation.h>
#import <WindMillSDK/WindMillSDK.h>

@interface HuijingAdPreviously : NSObject
+(instancetype) shareInstance;
-(void) startAdPreviously:(NSString *)rewardId interstitialId:(NSString *)interstitialId fullScreenId:(NSString *)fullScreenId;
-(WindMillRewardVideoAd *) getPrevRewardAd;
-(WindMillIntersititialAd *) getPrevInterstitialAd;
-(WindMillIntersititialAd *) getPrevFullScreenAd;
-(NSString *) getInterstitialId;
-(NSString *) getFullScreenId;
@end
