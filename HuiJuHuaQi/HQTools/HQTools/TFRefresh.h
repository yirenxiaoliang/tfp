//
//  TFRefresh.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/10/30.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJRefresh.h"

@interface TFRefresh : NSObject

/** 下拉刷新 普通模式 */
+ (MJRefreshNormalHeader *)headerNormalRefreshWithBlock:(void(^)(void))block;

/** 下拉刷新 GIF模式 */
+ (MJRefreshNormalHeader *)headerGifRefreshWithBlock:(void(^)(void))block;

/** 上拉加载更多 back模式 */
+ (MJRefreshBackNormalFooter *)footerBackRefreshWithBlock:(void(^)(void))block;

/** 上拉加载更多 自动模式 */
+ (MJRefreshAutoNormalFooter *)footerAutoRefreshWithBlock:(void(^)(void))block;


@end
