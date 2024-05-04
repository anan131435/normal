//
//  HjBannerViewFactory.m
//  huijing_ads_plugin
//
//

#import "HjBannerViewFactory.h"
#import "HjBannerAdViewPlugin.h"


@interface HjBannerViewFactory ()

@end

@implementation HjBannerViewFactory


- (NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(NSDictionary *)args {
    NSLog(@"createWithFrame - %@", NSStringFromCGRect(frame));
    NSLog(@"createWithViewId - %lld", viewId);
    NSLog(@"createWithArgs - %@", args);
    
    return [[HjBannerAdViewPlugin alloc] initWithFrame:frame arguments:args];

 
    return nil;
}

- (NSObject<FlutterMessageCodec> *)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messenger {
    self = [super init];
    if (self) {
        _messenger = messenger;
    }
    return self;
}
@end
