//
//  TFAtdLocationModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/25.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFAtdLocationModel @end

@interface TFAtdLocationModel : JSONModel

//{
//    "lat":11.11,
//    "lng":22.22,
//    "address":"广东省深圳市科技园"
//
//}

@property(nonatomic, strong) NSNumber <Optional>*lat;

@property(nonatomic, strong) NSNumber <Optional>*lng;

@property(nonatomic, copy) NSString <Optional>*address;

@property(nonatomic, copy) NSString <Optional>*name;

@end
