//
//  HQBLDelegate.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/1/12.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HQResponseEntity.h"

@class HQBaseBL;


/**
 *  业务类委托协议
 */
@protocol HQBLDelegate <NSObject>



@optional

/**
 *  即将处理业务逻辑
 *
 *  @param blEntiy   业务对象
 */
- (void)willHandle:(HQBaseBL *)blEntiy;

/**
 *  业务成功回调方法
 *
 *  @param blEntiy   业务对象
 *  @param result    业务处理之后的返回数据
 */
- (void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity*)resp;

/**
 *  业务失败回调方法
 *
 *  @param blEntiy   业务对象
 *  @param result    包括错误信息的对象
 */
- (void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity*)resp;


/**
 *  业务进度回调方法
 *
 *  @param blEntiy   业务对象
 *  @param result    返回数据
 */
- (void)progressHandle:(HQBaseBL *)blEntity response:(HQResponseEntity*)resp;

@end
