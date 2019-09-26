//
//  TFChatBL.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/11/30.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseBL.h"

@interface TFChatBL : HQBaseBL

/**
 获取会话列表
 */

-(void)requestGetChatListInfoData;

/**
 创建群聊
 */

-(void)requestAddGroupChatWithData:(NSString *)groupName groupNotice:(NSString *)groupNotice peoples:(NSString *)peoples;

/**
 创建单聊
 */

-(void)requestAddSingleChatWithData:(NSNumber *)receiverId;

/**
 获取所有群组
 */

-(void)requestGetAllGroupsInfoData;

/**
 单聊设置
 */

-(void)requestGetSingleInfoWithData:(NSNumber *)chatId;

/**
 群聊设置
 */

-(void)requestGetGroupInfoWithData:(NSNumber *)groupId;

/**
 置顶
 */

-(void)requestSetTopChatWithData:(NSNumber *)chatId chatType:(NSNumber *)chatType;

/**
 免打扰
 */

-(void)requestSetNoBotherWithData:(NSNumber *)chatId chatType:(NSNumber *)chatType;

/**
 退群
 */

-(void)requestQuiteGroupWithData:(NSNumber *)groupId;

/**
 解散群
 */

-(void)requestReleaseGroupWithData:(NSNumber *)groupId;

/**
 拉人
 */

-(void)requestPullPeopleWithData:(NSNumber *)groupId personId:(NSString *)personId;

/**
 踢人
 */

-(void)requestKickPeopleWithData:(NSNumber *)groupId personId:(NSString *)personId;

/**
 删除
 */

-(void)requestHideSessionWithData:(NSNumber *)chatId chatType:(NSNumber *)chatType;

/**
 修改群信息
 */

-(void)requestModifyGroupInfoWithData:(NSNumber *)groupId groupName:(NSString *)groupName notice:(NSString *)notice;

/** 小助手列表 */
-(void)requestGetAssistantMessageWithData:(NSNumber *)assistantId beanName:(NSString *)beanName pageSize:(NSNumber *)pageSize pageNo:(NSNumber *)pageNo;

/** 获取小助手设置相关信息 */
-(void)requestGetAssistantInfoWithData:(NSNumber *)assistantId;

/** 全部标为已读 */
-(void)requestMarkAllReadWithData:(NSNumber *)assistantId;

/** 小助手筛选 */
-(void)requestFindModuleListWithData:(NSNumber *)appId;

/** 小助手读取状态 */
-(void)requestReadMessageWithData:(NSNumber *)msgId assistantId:(NSNumber *)assistantId;

/** 标记小助手已读未读 */
-(void)requestMarkReadOptionWithData:(NSNumber *)assId;

/** 小助手权限 */
-(void)requestGetAuthByBeanWithData:(NSNumber *)assisId bean:(NSString *)bean;

/** 小助手文件库权限 */
-(void)requestGetAuthByBeanWithData:(NSNumber *)fileId style:(NSNumber *)style;

/** 小助手列表数据权限判断 */
-(void)requestGetFuncAuthWithCommunalWithData:(NSString *)bean moduleId:(NSNumber *)moduleId style:(NSNumber *)style dataId:(NSNumber *)dataId reqmap:(NSString *)reqmap;

-(void)requestHideSessionWithStatus:(NSNumber *)id chatType:(NSNumber *)chatType status:(NSNumber *)status;

/** 小助手历史数据 */
-(void)requestGetAssistantMessageLimitData:(NSNumber *)assistantId beanName:(NSString *)beanName upTime:(NSNumber *)upTime downTime:(NSNumber *)downTime dataSize:(NSNumber *)dataSize;

/** 转让群主 */
-(void)requestTransferGroupWithData:(NSNumber *)groupId signId:(NSNumber *)signId;

/**
 人员搜索
 */
-(void)requestEmployeeFindEmployeeVagueWithData:(NSNumber *)departmentId employeeName:(NSString *)employeeName;

@end
