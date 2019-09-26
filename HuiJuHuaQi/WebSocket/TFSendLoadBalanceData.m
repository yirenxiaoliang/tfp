//
//  TFSendLoadBalanceData.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/7/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSendLoadBalanceData.h"

@implementation TFSendLoadBalanceData

-(instancetype)init{
    if (self = [super init]) {
        
        self.net_flag = 1364414138;
        self.DeviceType = 2;
        
    }
    return self;
}

-(NSData *)data{

    uint32_t net_flag = self.net_flag;
    uint8_t state = self.state;
    uint64_t Imid = self.Imid;
    uint8_t DeviceType = self.DeviceType;

    
    NSMutableData *data = [NSMutableData dataWithBytes:&net_flag length:sizeof(net_flag)];
    
    [data appendBytes:&state length:sizeof(state)];
    
    [data appendBytes:&Imid length:sizeof(Imid)];
    
    [data appendBytes:&DeviceType length:sizeof(DeviceType)];
    
    return data;
}


@end
