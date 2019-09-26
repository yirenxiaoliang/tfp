//
//  TFTaskDeadlineDelayModel.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/14.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTaskDeadlineDelayModel.h"

@implementation TFTaskDeadlineDelayModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"timeType": @"deadlineType",
                                                       @"applyTime": @"deadline"
                                                       }];
}
@end
