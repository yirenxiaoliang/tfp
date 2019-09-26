//
//  TFSendLoadBalanceData.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/7/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFSendLoadBalanceData : NSObject

//typedef struct _ClientGetNodeURLPackets
//{//总共占14字节
//    uint32_t net_flag; //占4字节,固定为十六进制0x51534eba,十进制1364414138
//    uint8_t state;//占1字节，发送过来填充为0
//    uint64_t Imid;//占8字节，填充自己的Imid
//    uint8_t  DeviceType;//占1字节，填充自己的设备类型
//}ClientGetNodeURLPackets;

@property (nonatomic, assign) uint32_t net_flag;

@property (nonatomic, assign) uint8_t state;

@property (nonatomic, assign) uint64_t Imid;

@property (nonatomic, assign) uint8_t  DeviceType;

/** 头部数据转为Data */
-(NSMutableData *)data;

@end
