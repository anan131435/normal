//
//  HjIntersititialAdPlugin.m
//  huijing_ads_plugin
//
//

#import "HjIntersititialAdPlugin.h"
#import "HuijingAdPreviously.h"
#import "HuijingAdsPlugin.h"
#import "HjUtil.h"
#import "HjPluginContant.h"
#import <Flutter/Flutter.h>
#import <WindMillSDK/WindMillSDK.h>

@interface HjIntersititialAdPlugin ()<WindMillIntersititialAdDelegate>
@property (nonatomic, strong) FlutterMethodChannel *channel;
@property (nonatomic, strong) NSObject<FlutterPluginRegistrar> *registrar;
@property (nonatomic, strong) NSMutableDictionary<NSString *, HjIntersititialAdPlugin *> *pluginMap;
@property (nonatomic, strong) WindMillIntersititialAd *intersititialAd;
@property (nonatomic, weak) HjIntersititialAdPlugin *father;
@property (nonatomic,strong) WindMillAdInfo *adinfo;
@property (nonatomic) BOOL loadFlag;
@end

@implementation HjIntersititialAdPlugin

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel request:(WindMillAdRequest *)request {
    self = [super init];
    if (self) {
        _channel = channel;
        HuijingAdPreviously* huijingAdPreviously = [HuijingAdPreviously shareInstance];
        _intersititialAd = nil;
        if (huijingAdPreviously.getInterstitialId != nil &&
            [huijingAdPreviously.getInterstitialId isEqualToString:request.placementId]) {
            NSLog(@"---- InterstitialAd");
            _intersititialAd = huijingAdPreviously.getPrevInterstitialAd;
        } else {
            NSLog(@"---- FullScreenAd");
            _intersititialAd = huijingAdPreviously.getPrevFullScreenAd;
        }
        if (_intersititialAd == nil || !_intersititialAd.ready) {
            NSLog(@"---- _intersititialAd  initWithChannel");
            _intersititialAd = [[WindMillIntersititialAd alloc] initWithRequest:request];
        }
        _intersititialAd.delegate = self;
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
                                        methodChannelWithName:@"com.huijingads/interstitial"
                                        binaryMessenger:[registrar messenger]];
    HjIntersititialAdPlugin *plugin = [[HjIntersititialAdPlugin alloc] init];
    plugin.registrar = registrar;
    [registrar addMethodCallDelegate:plugin channel:channel];
}
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *uniqId = [call.arguments objectForKey:@"uniqId"];
    HjIntersititialAdPlugin *plugin = [self getPluginWithUniqId:uniqId arguments:call.arguments];
    NSString *func = [NSString stringWithFormat:@"%@MethodCall:result:", call.method];
    SEL selector = NSSelectorFromString(func);
    BOOL isImplementSel = NO;
    isImplementSel = [plugin respondsToSelector:selector];
    NSLog(@"intersititial: %@", self);
    NSLog(@"intersititial: [isImplementSel = %d, target = %@, func = %@, argus = %@]", isImplementSel, plugin, func, call.arguments);
    if (!isImplementSel) {
        result(FlutterMethodNotImplemented);
    }else {
        ((void (*)(id, SEL, id, id))[plugin methodForSelector:selector])(plugin, selector, call, result);
    }
}

- (HjIntersititialAdPlugin *)getPluginWithUniqId:(NSString *)uniqId arguments:(NSDictionary *)arguments {
    HjIntersititialAdPlugin *plugin = [self.pluginMap objectForKey:uniqId];
    if (!plugin) {
        NSDictionary *reqItem = [arguments objectForKey:@"request"];
        WindMillAdRequest *adRequest = [HjUtil getAdRequestWithItem:reqItem];
        if(adRequest.userId == nil || adRequest.userId.length==0){
            adRequest.userId = [HuijingAdsPlugin getUserId];
        }
        NSString *channelName = [NSString stringWithFormat:@"com.huijingads/interstitial.%@", uniqId];
        FlutterMethodChannel *channel = [FlutterMethodChannel
                                            methodChannelWithName:channelName
                                            binaryMessenger:[self.registrar messenger]];
        plugin = [[HjIntersititialAdPlugin alloc] initWithChannel:channel request:adRequest];
        plugin.father = self;
        [self.pluginMap setValue:plugin forKey:uniqId];
    }
    return plugin;
}
#pragma mark - ----- Method -----
- (void)isReadyMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    result(@([self.intersititialAd isAdReady]));
}
- (void)loadMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    self.loadFlag = NO;
    if (!self.intersititialAd.ready) {
        NSLog(@"---- intersititialAd loadMethodCall  new load");
        self.loadFlag = YES;
        self.adinfo = nil;
        [self.intersititialAd loadAdData];
    } else {
//        NSLog(@"---- intersititialAd loadMethodCall load 2222");
        [self.channel invokeMethod:HuijingEventAdSucceed arguments:@{}];
    }
    result(nil);
}


- (void)getAdInfoMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    if(self.adinfo == nil){
        result(nil);
    }else{
        result([self.adinfo toJson]);
    }
}


- (void)showAdMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    UIViewController *rootViewController = [HjUtil getCurrentController];
    NSDictionary *options = [call.arguments objectForKey:@"options"];
    
    NSString * scene_id =   options[@"AD_SCENE_ID"];
    
    NSString * scene_desc =   options[@"AD_SCENE_DESC"];

    NSDictionary *opt = @{WindMillAdSceneId:scene_id,WindMillAdSceneDesc:scene_desc};
    
    [self.intersititialAd showAdFromRootViewController:rootViewController options:opt];
    result(nil);
}
- (void)destroyMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *uniqId = [call.arguments objectForKey:@"uniqId"];
    [self.father.pluginMap removeObjectForKey:uniqId];
    result(nil);
}
#pragma mark - ----- WindMillIntersititialAdDelegate -----
- (void)intersititialAdDidLoad:(WindMillIntersititialAd *)intersititialAd {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    if (self.loadFlag) {
        self.loadFlag = NO;
        [self.channel invokeMethod:HuijingEventAdSucceed arguments:@{}];
    }
}
- (void)intersititialAdDidLoad:(WindMillIntersititialAd *)intersititialAd
              didFailWithError:(NSError *)error {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:HuijingEventAdFailed arguments:@{
        @"code": @(error.code),
        @"message": error.localizedDescription
    }];
}
- (void)intersititialAdDidVisible:(WindMillIntersititialAd *)intersititialAd {
    NSLog(@"%@", NSStringFromSelector(_cmd));
     self.adinfo = [intersititialAd adInfo];
    [self.channel invokeMethod:HuijingEventAdExposure arguments:@{}];
}
- (void)intersititialAdDidClick:(WindMillIntersititialAd *)intersititialAd {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:HuijingEventAdClicked arguments:@{}];
}
- (void)intersititialAdDidClickSkip:(WindMillIntersititialAd *)intersititialAd {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:HuijingEventAdClose arguments:@{}];
}
- (void)intersititialAdDidClose:(WindMillIntersititialAd *)intersititialAd {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:HuijingEventAdClose arguments:@{}];
}
- (void)intersititialAdDidPlayFinish:(WindMillIntersititialAd *)intersititialAd
                    didFailWithError:(NSError *)error {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:HuijingEventAdVideoComplete arguments:@{
        @"code": @(error.code),
        @"message": error.localizedDescription
    }];    
}

- (void)intersititialAdDidCloseOtherController:(WindMillIntersititialAd *)intersititialAd withInteractionType:(WindMillInteractionType)interactionType{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (void)dealloc {
    NSLog(@"--- dealloc -- %@", self);
    self.intersititialAd.delegate = nil;
    self.intersititialAd = nil;
    self.channel = nil;
    self.adinfo = nil;

}
@end
