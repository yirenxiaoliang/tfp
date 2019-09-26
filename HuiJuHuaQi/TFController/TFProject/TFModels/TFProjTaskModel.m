//
//  TFProjTaskModel.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/2.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjTaskModel.h"

@implementation TFProjTaskModel

//+(JSONKeyMapper*)keyMapper
//{
//    return [[JSONKeyMapper alloc] initWithDictionary:@{
//                                                       @"description": @"desc"
//                                                       }];
//}

-(instancetype)init{
    if (self=[super init]) {
        self.teamUserIds = [NSMutableArray array];
        self.labelIds = [NSMutableArray array];
        self.deadlineType = @2;
    }
    return self;
}

@end
