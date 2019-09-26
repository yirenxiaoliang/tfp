//
//  TFIMHeadData.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/11/20.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFIMHeadData : NSObject

/** 自己的IMID  自己id如果是登录包不知道自己id可以填充0登录成功会返回，别的任何包都必须要填充 */
@property (nonatomic, assign) int64_t OneselfIMID;

/** 命令类型ID */
@property (nonatomic, assign) uint16_t usCmdID;

/** 版本号 */
@property (nonatomic, assign) uint8_t ucVer;

/** 设备类型 */
@property (nonatomic, assign) uint8_t ucDeviceType;

/** 暂时不用 填充0*/
@property (nonatomic, assign) uint8_t ucFlag;

/** 客户端填充0,服务器时间戳.由服务器返回包来填充 */
@property (nonatomic, assign) int64_t ServerTimes;

/** 发送者ID号,登录请求包可以不填充. */
@property (nonatomic, assign) uint64_t senderID;

/** 接收者ID.当群发的时候为群ID */
@property (nonatomic, assign) uint64_t receiverID;

/** 客户端填充时间戳,微秒 */
@property (nonatomic, assign) int64_t clientTimes;

/** 随机数 */
@property (nonatomic, assign) uint32_t RAND;


//-(NSData *)data;

/** 头部数据转为Data */
-(NSMutableData *)data;
/** 解释头部数据 */
+ (TFIMHeadData *)headerWithData:(NSData *)data;


@end
