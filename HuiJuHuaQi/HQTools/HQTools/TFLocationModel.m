//
//  TFLocationModel.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/5/8.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFLocationModel.h"

@implementation TFLocationModel

-(NSString *)totalAddress{
    if (!IsStrEmpty(_totalAddress)) {
        return _totalAddress;
    }
    return [NSString stringWithFormat:@"%@%@%@%@",TEXT(self.province),TEXT(self.city),TEXT(self.district),TEXT(self.address)];
}

@end
