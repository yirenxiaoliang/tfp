//
//  TFAddAtdWayModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/25.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFAtdLocationModel.h"

@interface TFAddAtdWayModel : JSONModel

//{
//    "name":"思创科技大厦/DAKA2",
//    "address":"广东省深圳市南山区粤海街道思创科技大厦",
//    "location": [
//                 {
//                     "lat":11.11,
//                     "lng":22.22,
//                     "address":"广东省深圳市科技园"
//
//                 }],
//    "effectiveRange ":"300米",
//    "attendanceType ": "0"
//}
@property (nonatomic, strong) NSNumber <Optional>*id;

@property (nonatomic, copy) NSString <Optional>*name;

@property (nonatomic, copy) NSString <Optional>*address;

@property (nonatomic, strong) NSArray <TFAtdLocationModel,Optional>*location;

@property (nonatomic, strong) NSNumber <Optional>*effectiveRange;

@property (nonatomic, copy) NSString <Optional>*wayType;

@property (nonatomic, strong) NSNumber <Optional>*effective_range;



@end
