//
//  TFReceiveLoadBalanceData.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/7/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFReceiveLoadBalanceData : NSObject

@property (nonatomic, assign) uint32_t net_flag;

@property (nonatomic, assign) uint8_t state;

@property (nonatomic, assign) uint64_t Imid;

@property (nonatomic, assign) uint64_t ServerTime;

@property (nonatomic, copy) NSString *loadBalanceUrl;

/** 头部数据转为Data */
-(NSMutableData *)data;

//解析im服务器返回的负载均衡数据//解析im服务器返回的负载均衡数据
+ (TFReceiveLoadBalanceData *)receiveLoadBalanceWithData:(NSData *)data;

+ (TFReceiveLoadBalanceData *)receiveBalanceWithData:(NSData *)data;

/**  */
+(NSString *)loadBalanceResponseWithData:(NSData *)data;

@end
