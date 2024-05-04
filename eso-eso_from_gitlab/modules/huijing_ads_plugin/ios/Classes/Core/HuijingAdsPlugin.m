#import "HuijingAdsPlugin.h"
#import <WindMillSDK/WindMillSDK.h>
#import "HjBannerViewFactory.h"

#import "HjPluginContant.h"
#import "HjIntersititialAdPlugin.h"
#import "HjBannerAdPlugin.h"
#import "HjRewardVideoAdPlugin.h"
#import "HjSplashAdPlugin.h"
#import "HjUtil.h"
#import "HuijingAdPreviously.h"


@implementation HuijingAdsPlugin

static NSString *userId;
NSMutableArray * sdkConfigures;

+(NSString *)getUserId{
    return userId;
}

+(void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    NSLog(@"---- registerWithRegistrar ---- ");
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"com.huijingads.ad"
                                     binaryMessenger:[registrar messenger]];
    HuijingAdsPlugin* instance = [[HuijingAdsPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    // 注册BannerAdView 工厂
    HjBannerViewFactory *bannerFactory = [[HjBannerViewFactory alloc]
                                                initWithMessenger:[registrar messenger]];
    [registrar registerViewFactory:bannerFactory withId:kHjBannerAdViewId];

    [HjIntersititialAdPlugin registerWithRegistrar:registrar];
    [HjRewardVideoAdPlugin registerWithRegistrar:registrar];
    [HjBannerAdPlugin registerWithRegistrar:registrar];
    [HjSplashAdPlugin registerWithRegistrar:registrar];
    
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *func = [NSString stringWithFormat:@"%@MethodCall:result:", call.method];
    SEL selector = NSSelectorFromString(func);
    BOOL isImplementSel = NO;
    id target = self;
    isImplementSel = [target respondsToSelector:selector];
    NSLog(@"plugin: [isImplementSel = %d, target = %@, func = %@, argus = %@]", isImplementSel, target, func, call.arguments);
    if (!isImplementSel) {
        result(FlutterMethodNotImplemented);
    }else {
        ((void (*)(id, SEL, id, id))[target methodForSelector:selector])(target, selector, call, result);
    }
}


- (void)setPresetLocalStrategyPathMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *bundleName = call.arguments[@"path"];
    
    if(bundleName != nil){
        
        NSBundle * bundle = nil;
        if( [bundleName isEqualToString: @"mainbundle"]){
            bundle = [NSBundle mainBundle];
        }else{
            NSString * bundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
           
            if([[NSFileManager defaultManager] fileExistsAtPath:bundlePath]){
                bundle = [NSBundle bundleWithPath:bundlePath];
            }else{
                NSLog(@"error: bundle %@ not exist",bundleName);
            }
        }
        
        if(bundle != nil){
            NSLog(@"setPresetPlacementConfigPathBundle bundle: %@ sccess",bundleName);

            [WindMillAds setPresetPlacementConfigPathBundle:bundle];
        }
    }

    result(nil);
}

/*
 * 获取sdk的版本号
 */
- (void)initMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *appId = call.arguments[@"appId"];
    NSString *rewardId = call.arguments[@"rewardId"];
    NSString *interstitialId = call.arguments[@"interstitialId"];
    NSString *fullScreenId = call.arguments[@"fullScreenId"];
    NSLog(@"---- rewardId: %@", rewardId);
//    NSLog(@"---- interstitialId: %@", interstitialId);
//    NSLog(@"---- fullScreenId: %@", fullScreenId);
    [WindMillAds setupSDKWithAppId:appId sdkConfigures:sdkConfigures];
    HuijingAdPreviously* huijingAdPreviously = [HuijingAdPreviously shareInstance];
    [huijingAdPreviously startAdPreviously:rewardId interstitialId:interstitialId fullScreenId:fullScreenId];
    
    result(nil);
}

@end
