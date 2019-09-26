//
//  TFIMessageBL.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/6/5.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseBL.h"

@interface TFIMessageBL : HQBaseBL

/** 获取公司总群和小秘书 */
-(void)getMessageCompanyAndAssistantGroup;

/** 获取助手列表 */
-(void)getMessageAssistList;

/** 获取助手信息 */
-(void)getMessageAssistDetailWithItemId:(NSNumber *)itemId isRead:(NSNumber *)isRead isHandle:(NSNumber *)isHandle pageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize;

/** 更改助手处理状态 */
-(void)modifyMessageAssistHandleWithItemId:(NSNumber *)itemId isHandle:(NSNumber *)isHandle;
/** 更改助手已读状态 */
-(void)modifyMessageAssistReadWithItemId:(NSNumber *)itemId isRead:(NSNumber *)isRead;

/** 置顶 */
-(void)messageTopWithItemId:(NSNumber *)itemId top:(NSNumber *)top;

/** 助手待处理数据的清空 */
-(void)messageClearHandleWithItemId:(NSNumber *)itemId;

/** 修改助手设置 */
-(void)messageModifyAssistantSetDataWithItemId:(NSNumber *)itemId itemType:(NSNumber *)itemType assiatNotice:(NSNumber *)assiatNotice;

/** 极光用户获取员工信息 */
-(void)employeeWithImUserName:(NSString *)imUserName;

/** 未读页面数据全部变为已读 */
-(void)modToAllReadWithItemId:(NSNumber *)itemId;

/** 获取助手设置信息 */
-(void)getAssistantSettingInfoWithItemId:(NSNumber *)itemId;

/** 创建群组 */
-(void)creatGroupWithName:(NSString *)name desc:(NSString *)desc memberIds:(NSArray *)memberIds imUserNames:(NSArray *)imUserNames ownerUserName:(NSString *)ownerUserName;

/** 获取群组 */
-(void)getGroupList;

@end
