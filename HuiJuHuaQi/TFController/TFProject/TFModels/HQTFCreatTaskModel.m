//
//  HQTFCreatTaskModel.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFCreatTaskModel.h"

@implementation HQTFCreatTaskModel

-(instancetype)init{
    if (self=[super init]) {
        
        self.projTask = [[TFProjTaskModel alloc] init];
    }
    return self;
}

@end
