//
//  TFMailBL.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/6.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseBL.h"
#import "TFEmailReceiveListModel.h"

@interface TFMailBL : HQBaseBL

/** 收信 */
- (void)getMailOperationReceive;

/** 发送邮件 */
- (void)sendMailWithData:(TFEmailReceiveListModel *)model;

/** 手动发送 */
- (void)manualSendMailWithData:(NSString *)emaiId;

/** 回复邮件 */
- (void)replayMailWithData:(TFEmailReceiveListModel *)model;

/** 转发邮件 */
- (void)forwardMailWithData:(TFEmailReceiveListModel *)model;

/** 获取个人有效账号 */
- (void)getPersonnelMailAccount;

/** 邮件列表 */
- (void)getMailListData:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize;

/** 全部标为已读 */
- (void)requestMarkAllMailRead:(NSNumber *)mailId;

/** 标为已读 */
- (void)requestMarkMailReadOrUnread:(NSString *)ids status:(NSNumber *)status;

/** 最近联系人（邮件） */
- (void)getMailContactQueryListWithKeyword:(NSString *)keyword;

/** 获取邮件通讯录 */
- (void)getMailCatalogQueryList:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize keyWord:(NSString *)keyWord;

/** 获取邮件列表 1 收件箱 2 已发送 3 草稿箱 4 已删除 5 垃圾箱 */
- (void)getMailOperationQueryList:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize accountId:(NSNumber *)accountId boxId:(NSNumber *)boxId keyWord:(NSString *)keyWord;

/** 获取邮件详情 */
- (void)getMailDetailWithData:(NSNumber *)mailId type:(NSNumber *)type;

/** 邮件草稿 */
- (void)requesMailOperationSaveToDraftWithData:(TFEmailReceiveListModel *)model;

/** 不同邮件未读数 */
- (void)getMailOperationQueryUnreadNumsByBoxData;

/** 获取自定义关联邮箱列表 */
- (void)getCustomEmailListWithPageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize accountName:(NSString *)accountName;

/** 获取模块联系人 */
- (void)getModuleEmailsDataWithKeyword:(NSString *)keyword ;

/** 获取模块联系人 */
- (void)getModuleEmailsData;

/** 获取模块邮件 */
- (void)getModuleEmailGetEmailFromModuleDetailDataWithBean:(NSString *)bean ids:(NSString *)ids;

/** 邮件草稿删除 */
- (void)requesMailOperationDeleteDraftWithData:(NSString *)idStr;

/** 删除彻底 */
- (void)requesMailOperationClearMailWithData:(NSString *)idStr;

/** 标记不是垃圾邮件 */
- (void)requestMarkMailNotTrash:(NSString *)mailId;

/** 编辑草稿 */
- (void)requesMailOperationEditDraftWithData:(TFEmailReceiveListModel *)model;

@end
