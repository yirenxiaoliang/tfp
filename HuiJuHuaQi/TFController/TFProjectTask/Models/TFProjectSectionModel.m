//
//  TFProjectSectionModel.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/3.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectSectionModel.h"

@implementation TFProjectSectionModel

-(instancetype)init{
    if (self = [super init]) {
        self.pageSize = @10;
        self.pageNum = @1;
    }
    return self;
}

@end
