//
//  TFSocketManager.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/11/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketRocket.h"
#import "TFIMHeaderFile.h"
#import "TFIMHeadData.h"
#import "TFIMLoginData.h"
#import "TFIMContentData.h"
#import "DataBaseHandle.h"
#import "TFIMHistoryData.h"
#import "TFIMHIstoryContentData.h"

@interface TFSocketManager : NSObject

/** 连接状态 */
@property (nonatomic,assign) SRReadyState socketReadyState;
/** 登录状态 */
@property (nonatomic, assign) BOOL isLogin;


/** 单例 */
+ (TFSocketManager *)sharedInstance;
/** 开启连接 */
-(void)socketOpenIsReconnect:(BOOL)reconnect;
/** 关闭连接 */
-(void)socketClose;
/** 发送数据 */
- (void)sendData:(id)data;

/** 登陆 */
- (void)loginSocket;

/** 退出登陆 */
- (void)loginOutSocket;

/**  发送聊天消息方法
 *
 * @param cmdType 命令类型 1:群聊 2:单聊
 * @param receiverId 聊天对象 （群聊时为群id，单聊时为接收者id）
 * @param chatId 会话id
 * @param text 文本聊天内容
 * @param msgType 消息类型 1:文本 2:图片 3:语音 4:文件 5:小视频 6:位置 7:提示
 * @param datas 后台返回图片、小视频数据
 */
- (void)sendMsgData:(NSInteger)cmdType receiverId:(NSNumber *)receiverId chatId:(NSNumber *)chatId text:(NSString *)text msgType:(NSNumber *)msgType datas:(NSArray *)datas atList:(NSArray *)atList voiceTime:(NSNumber *)voiceTime;

/** 退群 */
- (void)sendQuitGroupData:(NSNumber *)receiverId chatId:(NSNumber *)chatId text:(NSString *)text msgType:(NSNumber *)msgType;

- (void)getHistoryRecordData:(NSNumber *)msgType chatId:(NSNumber *)chatId timeSp:(NSNumber *)timeSp Count:(NSInteger)Count;

@end
