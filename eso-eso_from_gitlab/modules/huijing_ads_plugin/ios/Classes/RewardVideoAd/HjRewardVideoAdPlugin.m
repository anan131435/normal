//
//  HjRewardVideoAdPlugin.m
//  huijing_ads_plugin
//
//

#import "HjRewardVideoAdPlugin.h"
#import "HuijingAdsPlugin.h"
#import "HjUtil.h"
#import "HjPluginContant.h"
#import "HuijingAdPreviously.h"
#import <Flutter/Flutter.h>
#import <WindMillSDK/WindMillSDK.h>

@interface HjRewardVideoAdPlugin ()<WindMillRewardVideoAdDelegate>
@property (nonatomic, strong) FlutterMethodChannel *channel;
@property (nonatomic, strong) NSObject<FlutterPluginRegistrar> *registrar;
@property (nonatomic, strong) NSMutableDictionary<NSString *, HjRewardVideoAdPlugin *> *pluginMap;
@property (nonatomic, strong) WindMillRewardVideoAd *reward;
@property (nonatomic, weak) HjRewardVideoAdPlugin *father;
@property (nonatomic,strong) WindMillAdInfo *adinfo;

@end

@implementation HjRewardVideoAdPlugin

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel
                        request:(WindMillAdRequest *)request {
    self = [super init];
    if (self) {
        _channel = channel;
        _reward = [HuijingAdPreviously shareInstance].getPrevRewardAd;
//        _reward = nil;
        if (_reward == nil || !_reward.ready) {
            NSLog(@"---- reward  initWithChannel");
            _reward = [[WindMillRewardVideoAd alloc] initWithRequest:request];
        }
        _reward.delegate = self;
    }
    return self;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _pluginMap = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
                                        methodChannelWithName:@"com.huijingads/reward"
                                        binaryMessenger:[registrar messenger]];
    HjRewardVideoAdPlugin *plugin = [[HjRewardVideoAdPlugin alloc] init];
    plugin.registrar = registrar;
    [registrar addMethodCallDelegate:plugin channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *uniqId = [call.arguments objectForKey:@"uniqId"];
    HjRewardVideoAdPlugin *rewardAd = [self getRewardAdPluginWithUniqId:uniqId arguments:call.arguments];
    NSString *func = [NSString stringWithFormat:@"%@MethodCall:result:", call.method];
    SEL selector = NSSelectorFromString(func);
    BOOL isImplementSel = NO;
    isImplementSel = [rewardAd respondsToSelector:selector];
    NSLog(@"reward: %@", self);
    NSLog(@"reward: [isImplementSel = %d, target = %@, func = %@, argus = %@]", isImplementSel, rewardAd, func, call.arguments);
    if (!isImplementSel) {
        result(FlutterMethodNotImplemented);
    }else {
        ((void (*)(id, SEL, id, id))[rewardAd methodForSelector:selector])(rewardAd, selector, call, result);
    }
}
- (HjRewardVideoAdPlugin *)getRewardAdPluginWithUniqId:(NSString *)uniqId arguments:(NSDictionary *)arguments {
    HjRewardVideoAdPlugin *rewardAd = [self.pluginMap objectForKey:uniqId];
    if (!rewardAd) {
        NSDictionary *reqItem = [arguments objectForKey:@"request"];
        WindMillAdRequest *adRequest = [HjUtil getAdRequestWithItem:reqItem];
        if(adRequest.userId == nil || adRequest.userId.length==0){
            adRequest.userId = [HuijingAdsPlugin getUserId];
        }
        NSString *channelName = [NSString stringWithFormat:@"com.huijingads/reward.%@", uniqId];
        FlutterMethodChannel *channel = [FlutterMethodChannel
                                            methodChannelWithName:channelName
                                            binaryMessenger:[self.registrar messenger]];
        rewardAd = [[HjRewardVideoAdPlugin alloc] initWithChannel:channel request:adRequest];
        rewardAd.father = self;
        [self.pluginMap setValue:rewardAd forKey:uniqId];
    }
    return rewardAd;
}
#pragma mark - ----- Method -----
- (void)isReadyMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    result(@([self.reward isAdReady]));
}
- (void)loadMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if (!self.reward.ready) {
//        NSLog(@"---- loadMethodCall  new load");
        self.adinfo = nil;
        [self.reward loadAdData];
    } else {
        [self.channel invokeMethod:HuijingEventAdSucceed arguments:@{}];
    }
    result(nil);
}
- (void)showAdMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    UIViewController *rootViewController = [HjUtil getCurrentController];
    NSDictionary *options = [call.arguments objectForKey:@"options"];
    
    NSString * scene_id = options[@"AD_SCENE_ID"];
    NSString * scene_desc = options[@"AD_SCENE_DESC"];
    
    NSDictionary *opt = @{WindMillAdSceneId:scene_id,WindMillAdSceneDesc:scene_desc};
    
    
    [self.reward showAdFromRootViewController:rootViewController options:opt];
    result(nil);
}

- (void)getAdInfoMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    if(self.adinfo == nil){
        result(nil);
    }else{
        result([self.adinfo toJson]);
    }
}

- (void)destroyMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *uniqId = [call.arguments objectForKey:@"uniqId"];
    [self.father.pluginMap removeObjectForKey:uniqId];
    result(nil);
}
#pragma mark - WindMillRewardVideoAdDelegate
- (void)rewardVideoAdDidLoad:(WindMillRewardVideoAd *)rewardVideoAd {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:HuijingEventAdSucceed arguments:@{}];
}

- (void)rewardVideoAdDidLoad:(WindMillRewardVideoAd *)rewardVideoAd didFailWithError:(NSError *)error {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSLog(@"_rewardVideoAdDidLoad");
    [self.channel invokeMethod:HuijingEventAdFailed arguments:@{
        @"code": @(error.code),
        @"message": error.localizedDescription
    }];
}

- (void)rewardVideoAdDidVisible:(WindMillRewardVideoAd *)rewardVideoAd {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    self.adinfo = [rewardVideoAd adInfo];
    NSLog(@"_rewardVideoAdDidVisible");
    [self.channel invokeMethod:HuijingEventAdExposure arguments:@{}];
}

- (void)rewardVideoAdDidClick:(WindMillRewardVideoAd *)rewardVideoAd {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSLog(@"_rewardVideoAdDidClick");
    [self.channel invokeMethod:HuijingEventAdClicked arguments:@{}];
}

- (void)rewardVideoAdDidClickSkip:(WindMillRewardVideoAd *)rewardVideoAd {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:HuijingEventAdClose arguments:@{}];
}

- (void)rewardVideoAd:(WindMillRewardVideoAd *)rewardVideoAd reward:(WindMillRewardInfo *)reward {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSLog(@"_rewardVideoAdreward");

    [self.channel invokeMethod:HuijingEventAdReward arguments:@{
          @"user_id":reward.userId,
          @"trans_id":reward.transId
    }];
}

- (void)rewardVideoAdDidClose:(WindMillRewardVideoAd *)rewardVideoAd {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSLog(@"_rewardVideoAdDidClose");
    [self.channel invokeMethod:HuijingEventAdClose arguments:@{}];
}

- (void)rewardVideoAdDidPlayFinish:(WindMillRewardVideoAd *)rewardVideoAd didFailWithError:(NSError *)error {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:HuijingEventAdVideoComplete arguments:@{
        @"code": @(error.code),
        @"message": error.localizedDescription
    }];   
}

- (void)dealloc {
    NSLog(@"--- dealloc -- %@", self);
    self.reward.delegate = nil;
    self.reward = nil;
    self.channel = nil;
}

@end
