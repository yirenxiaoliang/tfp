//
//  TFReceiveLoadBalanceData.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/7/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFReceiveLoadBalanceData.h"

@implementation TFReceiveLoadBalanceData

/**  */
+(NSString *)loadBalanceResponseWithData:(NSData *)data{
    
//    if (data.length > 21) {
    
//         [data getBytes:&str range:(NSRange){21,data.length}];
    NSData *data1 = [data subdataWithRange:NSMakeRange(21, data.length-21)];
//        str= [NSString stringWithFormat:@"%ld",login];
     NSString *rawString=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    return rawString;
}

-(NSData *)data{
    
    uint32_t net_flag = self.net_flag;
    uint8_t state = self.state;
    uint64_t Imid = self.Imid;
    uint64_t ServerTime = self.ServerTime;
    NSString *loadBalanceUrl = self.loadBalanceUrl;
    
    NSMutableData *data = [NSMutableData dataWithBytes:&net_flag length:sizeof(net_flag)];
    
    [data appendBytes:&state length:sizeof(state)];
    
    [data appendBytes:&Imid length:sizeof(Imid)];
    
    [data appendBytes:&ServerTime length:sizeof(ServerTime)];
    
    [data appendBytes:&loadBalanceUrl length:sizeof(loadBalanceUrl)];
    
    return data;
}

//解析im服务器返回的负载均衡数据
+ (TFReceiveLoadBalanceData *)receiveLoadBalanceWithData:(NSData *)data {
    
    if (data.length == 0) {
        
        NSLog(@"空数据！");
        
        return nil;
    }
    else {
        
        TFReceiveLoadBalanceData *loadBalance = [[TFReceiveLoadBalanceData alloc] init];
        
        uint32_t net_flag;
        uint8_t state;
        uint64_t Imid;
        uint64_t ServerTime;
        
        NSArray *headRange = @[@0,@(4),@(1),@(8),@(8)];
        
        NSInteger location = 0;
        NSInteger length = 0;
        
        location += [headRange[0] integerValue];
        length = [headRange[1] integerValue];
        [data getBytes:&net_flag range:(NSRange){location,length}];
        
        location += [headRange[1] integerValue];
        length = [headRange[2] integerValue];
        [data getBytes:&state range:(NSRange){location,length}];
        
        location += [headRange[2] integerValue];
        length = [headRange[3] integerValue];
        [data getBytes:&Imid range:(NSRange){location,length}];
        
        location += [headRange[3] integerValue];
        length = [headRange[4] integerValue];
        [data getBytes:&ServerTime range:(NSRange){location,length}];
        
        loadBalance.net_flag = net_flag;
        loadBalance.state = state;
        loadBalance.Imid = Imid;
        loadBalance.ServerTime = ServerTime;
        
        return loadBalance;
        
    }
    
}

+ (TFReceiveLoadBalanceData *)receiveBalanceWithData:(NSData *)data {
    
    if (data.length == 0) {
        
        NSLog(@"空数据！");
        
        return nil;
    }
    else {
        
        TFReceiveLoadBalanceData *loadBalance = [[TFReceiveLoadBalanceData alloc] init];
        
        uint32_t net_flag;
        
        NSArray *headRange = @[@0,@(4)];
        
        NSInteger location = 0;
        NSInteger length = 0;
        
        location += [headRange[0] integerValue];
        length = [headRange[1] integerValue];
        [data getBytes:&net_flag range:(NSRange){location,length}];
        
        return loadBalance;
        
    }
}


@end
