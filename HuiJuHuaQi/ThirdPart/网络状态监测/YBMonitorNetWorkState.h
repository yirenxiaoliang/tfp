//
//  YBMonitorNetWorkState.h
//  YBMonitorNetWorkState
//
//  Created by hxcj on 16/5/19.
//  Copyright © 2016年 hxcj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"



@protocol YBMonitorNetWorkStateDelegate <NSObject>

@optional

/**
 * 当网络状态发生改变的时候触发， 前提是必须是添加网络状态监听
 */
- (void)netWorkStateChanged;

@end


@interface YBMonitorNetWorkState : NSObject

@property (nonatomic, strong) Reachability *conn;

@property (nonatomic, assign) id<YBMonitorNetWorkStateDelegate>delegate;

/**
 * 实例化单例对象
 */
+ (YBMonitorNetWorkState *)shareMonitorNetWorkState;

/**
 * 获取当前网络类型 GPRS / wifi / noConnect
 */
- (NSString *)getCurrentNetWorkType;

/**
 * 添加网络状态监听
 */
- (void)addMonitorNetWorkState;

/**
 * 获取网络状态
 * YES 有网络
 * NO  无网络
 */
- (BOOL)getNetWorkState;

@end

//{
//    1.导入头文件，遵守代理协议
//// 2.设置代理
//[YBMonitorNetWorkState shareMonitorNetWorkState].delegate = self;
//// 3.添加网络监听
//[[YBMonitorNetWorkState shareMonitorNetWorkState] addMonitorNetWorkState];
//
//[self netWorkStateChanged];
//
//
////
////}
//
//#pragma mark 4.网络监听的代理方法，当网络状态发生改变的时候触发
//- (void)netWorkStateChanged{
//    
//    // 获取当前网络类型
//    NSString *currentNetWorkState = [[YBMonitorNetWorkState shareMonitorNetWorkState] getCurrentNetWorkType];
//    
//    // 显示当前网络类型
//    self.showCurrentNetWorkState.text = currentNetWorkState;
//}

