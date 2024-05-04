#import "HuijingAdPreviously.h"
#import <WindMillSDK/WindMillSDK.h>

@interface HuijingAdPreviously ()<WindMillRewardVideoAdDelegate, WindMillIntersititialAdDelegate>
 
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString *rewardId;
@property (nonatomic, strong) NSString *interstitialId;
@property (nonatomic, strong) NSString *fullScreenId;
@property (nonatomic, strong) WindMillRewardVideoAd *prevRewardAd;
@property (nonatomic, strong) WindMillIntersititialAd *prevInterstitialAd;
@property (nonatomic, strong) WindMillIntersititialAd *prevFullScreenAd;
@property (nonatomic) int times;
@property (nonatomic) int intersititialTimes;
@property (nonatomic) int fullScreenTimes;

@end

@implementation HuijingAdPreviously
 
static HuijingAdPreviously* _instance = nil;
 
+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
    }) ;
     
    return _instance ;
}
 
+(id) allocWithZone:(struct _NSZone *)zone
{
    return [HuijingAdPreviously shareInstance] ;
}
 
-(id) copyWithZone:(struct _NSZone *)zone
{
    return [HuijingAdPreviously shareInstance] ;
}

-(WindMillRewardVideoAd *) getPrevRewardAd {
    return self.prevRewardAd;
}

-(NSString *) getInterstitialId {
    return self.interstitialId;
}
-(NSString *) getFullScreenId {
    return self.fullScreenId;
}
-(WindMillIntersititialAd *) getPrevInterstitialAd {
    return self.prevInterstitialAd;
}

-(WindMillIntersititialAd *) getPrevFullScreenAd {
    return self.prevFullScreenAd;
}

-(void) rewardAdPrevHandler:(int) times {
    NSLog(@"---- rewardAdPrevHandler times: %d", times);
    times--;
    self.times = times;
    WindMillAdRequest *request = [WindMillAdRequest request];
    request.placementId = self.rewardId;
    self.prevRewardAd = [[WindMillRewardVideoAd alloc] initWithRequest:request];
    self.prevRewardAd.delegate = self;
    NSLog(@"---- HJ-LOG loadAdData start ------");
    [self.prevRewardAd loadAdData];
}

-(void) intersititialAdPrevHandler:(int) times {
    NSLog(@"---- intersititialAdPrevHandler times: %d", times);
    times--;
    self.intersititialTimes = times;
    WindMillAdRequest *request = [WindMillAdRequest request];
    request.placementId = self.interstitialId;
    self.prevInterstitialAd = [[WindMillIntersititialAd alloc] initWithRequest:request];
    self.prevInterstitialAd.delegate = self;
    NSLog(@"---- HJ-LOG prevInterstitialAd loadAdData start ------");
    [self.prevInterstitialAd loadAdData];
}

-(void) fullScreenAdPrevHandler:(int) times {
    NSLog(@"---- fullScreenAdPrevHandler times: %d", times);
    times--;
    self.fullScreenTimes = times;
    WindMillAdRequest *request = [WindMillAdRequest request];
    request.placementId = self.fullScreenId;
    self.prevFullScreenAd = [[WindMillIntersititialAd alloc] initWithRequest:request];
    self.prevFullScreenAd.delegate = self;
    NSLog(@"---- HJ-LOG prevFullScreenAd loadAdData start ------");
    [self.prevFullScreenAd loadAdData];
}

-(void) adPrevHandler {
    if (self.rewardId != nil && self.rewardId.length > 0) {
        if (self.prevRewardAd == nil || !self.prevRewardAd.ready) {
            NSLog(@"---- reward  adPrevHandler");
            [self rewardAdPrevHandler:2];
        }
    }
    if (self.interstitialId != nil && self.interstitialId.length > 0) {
        if (self.prevInterstitialAd == nil || !self.prevInterstitialAd.ready) {
            NSLog(@"---- interstitial  adPrevHandler");
            [self intersititialAdPrevHandler:2];
        }
    }
    if (self.fullScreenId != nil && self.fullScreenId.length > 0) {
        if (self.prevFullScreenAd == nil || !self.prevFullScreenAd.ready) {
            NSLog(@"---- fullScreen  adPrevHandler");
            [self fullScreenAdPrevHandler:2];
        }
    }
}

-(void) startAdPreviously:(NSString *)rewardId interstitialId:(NSString *)interstitialId fullScreenId:(NSString *)fullScreenId {
    NSLog(@"---- startAdPreviously rewardId: %@", rewardId);
    NSLog(@"---- startAdPreviously interstitialId: %@", interstitialId);
    NSLog(@"---- startAdPreviously fullScreenId: %@", fullScreenId);
    if ((rewardId && rewardId != [NSNull null] && rewardId.length > 0) ||
        (interstitialId && interstitialId != [NSNull null] && interstitialId.length > 0) ||
        (fullScreenId && fullScreenId != [NSNull null] && fullScreenId.length > 0)) {
        self.rewardId = rewardId;
        self.interstitialId = interstitialId;
        self.fullScreenId = fullScreenId;
        // 创建一个定时器，并指定要调用的方法和调用间隔
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3600.0
                                                      target:self
                                                    selector:@selector(timerFired:)
                                                    userInfo:nil
                                                     repeats:YES];
        // 获取主运行循环
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        // 在默认模式下添加timer
        [runLoop addTimer:self.timer forMode:NSDefaultRunLoopMode];
        // 立即执行一次
        [self timerFired:self.timer];
    }
}

- (void)timerFired:(NSTimer *)timer {
    // 定时器触发时调用的方法
    [self adPrevHandler];
}
 
- (void)stopTimer {
    // 停止并移除定时器
    [self.timer invalidate];
    self.timer = nil;
}
 
- (void)rewardVideoAd:(nonnull WindMillRewardVideoAd *)rewardVideoAd reward:(nonnull WindMillRewardInfo *)reward {
}

- (void)rewardVideoAdDidLoad:(WindMillRewardVideoAd *)rewardVideoAd {
    NSLog(@"-------- rewardVideoAdDidLoad %@", NSStringFromSelector(_cmd));
   
   
}

- (void)rewardVideoAdDidLoad:(WindMillRewardVideoAd *)rewardVideoAd didFailWithError:(NSError *)error {
    NSLog(@"--------- HJ-LOG rewardVideoAdDidLoad didFailWithError %@", NSStringFromSelector(_cmd));
    if (self.times > 0) {
        [NSThread sleepForTimeInterval:0.5];
        [self rewardAdPrevHandler:self.times];
    }
}

- (void)intersititialAdDidLoad:(WindMillIntersititialAd *)intersititialAd {
    NSLog(@"-------- intersititialAdDidLoad %@", intersititialAd.placementId);
    if (self.interstitialId != nil && [self.interstitialId isEqualToString:intersititialAd.placementId]) {
        NSLog(@"-------- intersititialAdDidLoad %@", NSStringFromSelector(_cmd));
    } else {
        NSLog(@"-------- fullScreen intersititialAdDidLoad %@", NSStringFromSelector(_cmd));
    }
        
    
   
}
- (void)intersititialAdDidLoad:(WindMillIntersititialAd *)intersititialAd
              didFailWithError:(NSError *)error {
    if (self.interstitialId != nil && [self.interstitialId isEqualToString:intersititialAd.placementId]) {
        NSLog(@"--------- HJ-LOG intersititialAdDidLoad didFailWithError %@", NSStringFromSelector(_cmd));
        if (self.intersititialTimes > 0) {
            [NSThread sleepForTimeInterval:0.5];
            [self intersititialAdPrevHandler:self.intersititialTimes];
        }
    } else {
        NSLog(@"--------- HJ-LOG fullScreen intersititialAdDidLoad didFailWithError %@", NSStringFromSelector(_cmd));
        if (self.fullScreenTimes > 0) {
            [NSThread sleepForTimeInterval:0.5];
            [self fullScreenAdPrevHandler:self.fullScreenTimes];
        }
    }
}

@end
