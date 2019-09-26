//
//  TFLocationModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/5/8.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFLocationModel : NSObject

/** 地址名 */
@property (nonatomic, copy) NSString *name;
/** UID */
@property (nonatomic, copy) NSString *uid;
/** 地址 */
@property (nonatomic, copy) NSString *address;
/** 城市 */
@property (nonatomic, copy) NSString *city;
/** 省 */
@property (nonatomic, copy) NSString *province;
/** 区 */
@property (nonatomic, copy) NSString *district;
/** 经度 */
@property (nonatomic, assign) double longitude;
/** 纬度 */
@property (nonatomic, assign) double latitude;

/** 自己用的新建或编辑 */
@property (nonatomic, copy) NSString *totalAddress;

/** 自己用的详情 */
@property (nonatomic, copy) NSString *detailAddress;
/** 用于显示选中状态 */
@property (nonatomic, assign) BOOL select;
/** 有效范围 */
@property (nonatomic, copy) NSString *effective_range;

@end
