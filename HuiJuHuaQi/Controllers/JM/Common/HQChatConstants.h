//
//  HQChatConstants.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/11/24.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#ifndef HQChatConstants_h
#define HQChatConstants_h

#import "JCHATStringUtils.h"
#import "JCHATAlertToSendImage.h"
#import "ViewUtil.h"

#define kStatusBarHeight 20
static NSInteger const st_toolBarTextSize = 17.0f;

/** 聊天记录存储通知 */
#define kDBMigrateStartNotification @"DBMigrateStartNotification"
#define kDBMigrateFinishNotification @"DBMigrateFinishNotification"
/** 创建群组 */
#define kCreatGroupState  @"creatGroupState"
/** 创建群组 */
#define kCreatGroupStateServer  @"creatGroupStateServer"

/** 跳转单聊 */
#define kSkipToSingleChatViewState  @"SkipToSingleChatViewState"

/** 登录通知 */
#define kLogin_NotifiCation @"loginNotification"

/** 异步block */
#define JCHATMAINTHREAD(block) dispatch_async(dispatch_get_main_queue(), block)


static NSString * const st_receiveUnknowMessageDes = @"收到新消息类型无法解析的数据，请升级查看";
static NSString * const st_receiveErrorMessageDes = @"接收消息错误";

static NSInteger const messagePageNumber = 25;
static NSInteger const messagefristPageNumber = 20;

#define kAlertToSendImage @"AlertToSendImage"
#define kDeleteMessage @"DeleteMessage"
#define kDeleteAllMessage  @"deleteAllMessage"
#define kConversationChange @"ConversationChange"

/** 异步完成通知 */
#define AsynchronizeFinishNotification @"AsynchronizeFinishNotification"


//NavigationBar
#define kGoBackBtnImageOffset UIEdgeInsetsMake(0, 0, 0, 15)
#define kNavigationLeftButtonRect CGRectMake(0, 0, 30, 30)

#define kSeparateLineFrame CGRectMake(0, 150-0.5,SCREEN_WIDTH, 0.5)
#define kSeparateLineColor HexColor(0xd0d0cf,1)
#define kHeadViewFrame CGRectMake((SCREEN_WIDTH - 70)/2, (150-70)/2, 70, 70)
#define kNameLabelFrame CGRectMake(0, 150-40, SCREEN_WIDTH, 40)

#define upLoadImgWidth 720

#define kVoiceRecorderTotalTime 60.0

#endif /* HQChatConstants_h */
