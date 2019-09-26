//
//  TFEmailUnreadModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/14.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFEmailUnreadModel : JSONModel

//{
//    "mail_box_id": 2,
//    "count": 1
//},

@property (nonatomic, strong) NSNumber <Optional>*mail_box_id;

@property (nonatomic, strong) NSNumber <Optional>*count;

@end
