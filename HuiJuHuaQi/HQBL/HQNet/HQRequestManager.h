//
//  HQRequestManager.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/1/12.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HQRequestManagerDelegate.h"
#import "HQRequestItem.h"

@interface HQRequestManager : NSObject

/** 单例 */
+ (HQRequestManager *)sharedManager;

/** 单例销毁 */
+ (void)dellocManager;

/** 
 *  基本接口请求
 *  method(用于区分请求，与http的GET，POST，DELETE意义一样，为application/x-www-form-urlencoded传数据。SELF为POST请求，为application/json传数据)
 *
 *  GET,POST,DELETE,SELF四种值
 *
 */
- (HQRequestItem *)requestToURL:(NSString*)url method:(NSString*)method requestParam:(id)params cmdId:(HQCMD)cmdId delegate:(id<HQRequestManagerDelegate>)delegate startBlock:(WillRequestBlk)blk;

/** 上传图片请求 (mediaDatas数组中全是UIImage对象) */
- (HQRequestItem *)uploadPicToURL:(NSString*)url requestParam:(id)params mediaDatas:(NSArray*)mediaDatas cmdId:(HQCMD)cmdId delegate:(id<HQRequestManagerDelegate>)delegate startBlock:(WillRequestBlk)blk;

/** 上传图片与录音请求 (imgDatas数组中全是UIImage对象)(vedioDatas数组中全是录音对象) */
- (HQRequestItem *)uploadPicToURL:(NSString*)url requestParam:(id)params imgDatas:(NSArray*)imgDatas audioDatas:(NSArray *)audioDatas videoDatas:(NSArray *)videoDatas cmdId:(HQCMD)cmdId delegate:(id<HQRequestManagerDelegate>)delegate startBlock:(WillRequestBlk)blk;

@end
