//
//  HQSportManager.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/11/1.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQSportManager.h"
#import <CoreLocation/CoreLocation.h>

@interface HQSportManager ()<NSCopying,NSMutableCopying,CLLocationManagerDelegate>
/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;
/** 定位管理者 */
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation HQSportManager

static HQSportManager *_sharedManager = nil;
/** 单例 */
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
        _sharedManager.timer = [[NSTimer alloc] init];
        _sharedManager.locationManager = [[CLLocationManager alloc] init];
        _sharedManager.locationManager.delegate = _sharedManager;
        [_sharedManager.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        
        if ([[UIDevice currentDevice].systemVersion floatValue] > 8)
        {
            /** 请求用户权限：分为：只在前台开启定位  /在后台也可定位， */
            
            /** 只在前台开启定位 */
            //        [self.locationManager requestWhenInUseAuthorization];
            
            /** 后台也可以定位 */
            [_sharedManager.locationManager requestAlwaysAuthorization];
        }
        
        if ([[UIDevice currentDevice].systemVersion floatValue] > 9)
        {
            /** iOS9新特性：将允许出现这种场景：同一app中多个location manager：一些只能在前台定位，另一些可在后台定位（并可随时禁止其后台定位）。 */
            [_sharedManager.locationManager setAllowsBackgroundLocationUpdates:YES];
        }
        
        /** 开始定位 */
        [_sharedManager.locationManager startUpdatingLocation];
        
    });
    return _sharedManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [super allocWithZone:zone];
    });
    return _sharedManager;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    return _sharedManager;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone{
    return _sharedManager;
}



@end
