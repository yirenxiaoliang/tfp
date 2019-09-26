//
//  TFMailBL.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/6.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFMailBL.h"
#import "TFEmailAccountModel.h"
#import "TFEmailAddessBookModel.h"
#import "TFEmailRecentContactsModel.h"
#import "TFEmailsListModel.h"
#import "TFEmailUnreadModel.h"
#import "TFEmailModuleListModel.h"
#import "TFEmailModuleAccountModel.h"

@implementation TFMailBL

/** 收信 */
- (void)getMailOperationReceive {
    
    NSString *url = [super urlFromCmd:HQCMD_mailOperationReceive];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:nil
                                            cmdId:HQCMD_mailOperationReceive
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 发送邮件 */
- (void)sendMailWithData:(TFEmailReceiveListModel *)model {

    NSDictionary *dict = [model toDictionary];

    
    NSString *url = [super urlFromCmd:HQCMD_mailOperationSend];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_mailOperationSend
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 手动发送 */
- (void)manualSendMailWithData:(NSString *)emaiId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (emaiId) {
        
        [dict setObject:emaiId forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_mailOperationManualSend];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_mailOperationManualSend
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 回复邮件 */
- (void)replayMailWithData:(TFEmailReceiveListModel *)model {
    
    NSDictionary *dict = [model toDictionary];
    
    
    NSString *url = [super urlFromCmd:HQCMD_mailOperationMailReply];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_mailOperationMailReply
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 转发邮件 */
- (void)forwardMailWithData:(TFEmailReceiveListModel *)model {
    
    NSDictionary *dict = [model toDictionary];
    
    
    NSString *url = [super urlFromCmd:HQCMD_mailOperationMailForward];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_mailOperationMailForward
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 获取个人有效账号 */
- (void)getPersonnelMailAccount {
    
    
    NSString *url = [super urlFromCmd:HQCMD_queryPersonnelAccount];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:nil
                                            cmdId:HQCMD_queryPersonnelAccount
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 邮件列表 */
- (void)getMailListData:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize {

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (pageNum) {
        
        [dic setObject:pageNum forKey:@"pageNum"];
    }
    if (pageSize) {
        
        [dic setObject:pageSize forKey:@"pageSize"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_queryMailList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dic
                                            cmdId:HQCMD_queryMailList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 全部标为已读 */
- (void)requestMarkAllMailRead:(NSNumber *)mailId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (mailId) {
        
        [dict setObject:mailId forKey:@"boxId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_markAllMailRead];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_markAllMailRead
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 标为已读 */
- (void)requestMarkMailReadOrUnread:(NSString *)ids status:(NSNumber *)status {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (ids) {
        
        [dict setObject:ids forKey:@"ids"];
    }
    if (status) {
        
        [dict setObject:status forKey:@"readStatus"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_markMailReadOrUnread];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_markMailReadOrUnread
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 最近联系人（邮件） */
- (void)getMailContactQueryListWithKeyword:(NSString *)keyword {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (keyword) {
        [dict setObject:keyword forKey:@"keyword"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_mailContactQueryList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_mailContactQueryList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 获取邮件通讯录 */
- (void)getMailCatalogQueryList:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize keyWord:(NSString *)keyWord{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (pageNum) {
        
        [dic setObject:pageNum forKey:@"pageNum"];
    }
    if (pageSize) {
        
        [dic setObject:pageSize forKey:@"pageSize"];
    }
    if (keyWord) {
        [dic setObject:keyWord forKey:@"keyword"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_mailCatalogQueryList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dic
                                            cmdId:HQCMD_mailCatalogQueryList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 获取邮件列表 1 收件箱 2 已发送 3 草稿箱 4 已删除 5 垃圾箱 */
- (void)getMailOperationQueryList:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize accountId:(NSNumber *)accountId boxId:(NSNumber *)boxId keyWord:(NSString *)keyWord{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (pageNum) {
        
        [dic setObject:pageNum forKey:@"pageNum"];
    }
    if (pageSize) {
        
        [dic setObject:pageSize forKey:@"pageSize"];
    }
    if (accountId) {
        
        [dic setObject:accountId forKey:@"accountId"];
    }
    if (boxId) {
        
        [dic setObject:boxId forKey:@"boxId"];
    }
    if (keyWord) {
        
        [dic setObject:keyWord forKey:@"keyword"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_mailOperationQueryList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dic
                                            cmdId:HQCMD_mailOperationQueryList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 获取邮件详情 */
- (void)getMailDetailWithData:(NSNumber *)mailId type:(NSNumber *)type {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (mailId) {
        
        [dic setObject:mailId forKey:@"id"];
    }
    if (type) {
        
        [dic setObject:type forKey:@"type"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_mailOperationQueryById];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dic
                                            cmdId:HQCMD_mailOperationQueryById
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 邮件草稿 */
- (void)requesMailOperationSaveToDraftWithData:(TFEmailReceiveListModel *)model {
    
    NSDictionary *dict = [model toDictionary];
    
    
    NSString *url = [super urlFromCmd:HQCMD_mailOperationSaveToDraft];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_mailOperationSaveToDraft
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 不同邮件未读数 */
- (void)getMailOperationQueryUnreadNumsByBoxData {
    
    
    NSString *url = [super urlFromCmd:HQCMD_mailOperationQueryUnreadNumsByBox];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:nil
                                            cmdId:HQCMD_mailOperationQueryUnreadNumsByBox
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 获取模块联系人 */
- (void)getModuleEmailsDataWithKeyword:(NSString *)keyword {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (keyword) {
        [dict setObject:keyword forKey:@"keyword"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_moduleEmailGetModuleEmails];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_moduleEmailGetModuleEmails
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 获取模块联系人 */
- (void)getModuleSubmenusData {
    
    
    NSString *url = [super urlFromCmd:HQCMD_moduleEmailGetModuleSubmenus];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:nil
                                            cmdId:HQCMD_moduleEmailGetModuleSubmenus
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 获取模块邮件 */
- (void)getModuleEmailGetEmailFromModuleDetailDataWithBean:(NSString *)bean ids:(NSString *)ids {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (bean) {
        
        [dict setObject:bean forKey:@"bean"];
    }
    if (ids) {
        
        [dict setObject:ids forKey:@"ids"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_moduleEmailGetEmailFromModuleDetail];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_moduleEmailGetEmailFromModuleDetail
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 获取自定义关联邮箱列表 */
- (void)getCustomEmailListWithPageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize accountName:(NSString *)accountName{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:@(pageNum) forKey:@"pageNum"];
    [dict setObject:@(pageSize) forKey:@"pageSize"];
    if (accountName) {
        [dict setObject:accountName forKey:@"accountName"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_customEmailList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_customEmailList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 邮件草稿删除 */
- (void)requesMailOperationDeleteDraftWithData:(NSString *)idStr {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (idStr) {
        
        [dict setObject:idStr forKey:@"id"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_mailOperationDeleteDraft];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_mailOperationDeleteDraft
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 删除彻底 */
- (void)requesMailOperationClearMailWithData:(NSString *)idStr {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (idStr) {
        
        [dict setObject:idStr forKey:@"id"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_mailOperationClearMail];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_mailOperationClearMail
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 标记不是垃圾邮件 */
- (void)requestMarkMailNotTrash:(NSString *)mailId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (mailId) {
        
        [dict setObject:mailId forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_mailOperationMarkNotTrash];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_mailOperationMarkNotTrash
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 编辑草稿 */
- (void)requesMailOperationEditDraftWithData:(TFEmailReceiveListModel *)model {
    
    NSDictionary *dict = [model toDictionary];
    
    
    NSString *url = [super urlFromCmd:HQCMD_mailOperationEditDraft];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_mailOperationEditDraft
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

#pragma mark - Response
- (void)requestManager:(HQRequestManager *)manager sequenceID:(NSInteger)sid didCompleteWithData:(id)data cmdId:(HQCMD)cmdId{
    BOOL result = [super requestManager:manager commonData:data sequenceID:sid cmdId:cmdId];
    HQResponseEntity *resp = nil;
    
    if (result) {
        switch (cmdId) {
                
            case HQCMD_mailOperationReceive://收信
            {

                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_mailOperationSend:// 发送邮件
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_mailOperationMailReply:// 回复邮件
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_mailOperationMailForward:// 转发邮件
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_mailOperationQueryList:// 邮件列表
            {
                NSDictionary *dic = data[kData];
                
                TFEmailsListModel *model = [[TFEmailsListModel alloc] initWithDictionary:dic error:nil];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
                
            case HQCMD_queryPersonnelAccount:// 个人有效账号
            {
                
                NSArray *arr = data[kData];

                NSMutableArray *array = [NSMutableArray array];

                for (NSDictionary *dic in arr) {

                    TFEmailAccountModel *model = [[TFEmailAccountModel alloc] initWithDictionary:dic error:nil];

                    [array addObject:model];
                }
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:array];
            }
                break;
                
            case HQCMD_mailCatalogQueryList:// 邮件通讯录
            {
                
                NSDictionary *dic = data[kData];
                    
                TFEmailAddessBookModel *model = [[TFEmailAddessBookModel alloc] initWithDictionary:dic error:nil];

                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
                
            case HQCMD_mailContactQueryList:// 最近联系人
            {
                
                NSArray *arr = data[kData];
                
                NSMutableArray *array = [NSMutableArray array];
                
                for (NSDictionary *dic in arr) {
                    
                    TFEmailRecentContactsModel *model = [[TFEmailRecentContactsModel alloc] initWithDictionary:dic error:nil];
                    
                    [array addObject:model];
                }
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:array];
            }
                break;
                
            case HQCMD_ChatFile:// 上传文件
            {
                NSArray *files = data[kData];
                
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *dict in files) {
                    
                    TFFileModel *model = [[TFFileModel alloc] initWithDictionary:dict error:nil];
                    
                    [array addObject:model];
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:array];
            }
                break;
                
            case HQCMD_markAllMailRead:// 全部标为已读
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_markMailReadOrUnread:// 标为已读
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_mailOperationQueryById:// 获取邮件详情
            {
                NSDictionary *dic = data[kData];
                
                TFEmailReceiveListModel *model = [[TFEmailReceiveListModel alloc] initWithDictionary:dic error:nil];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
                
            case HQCMD_mailOperationSaveToDraft:// 邮件草稿
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_mailOperationQueryUnreadNumsByBox:// 不同邮箱未读数
            {
                NSArray *files = data[kData];
                
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *dict in files) {
                    
                    TFEmailUnreadModel *model = [[TFEmailUnreadModel alloc] initWithDictionary:dict error:nil];
                    
                    [array addObject:model];
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:array];
            }
                break;
            case HQCMD_customEmailList:// 自定义邮件列表
            {
                NSDictionary *dic = data[kData];
                
                TFEmailsListModel *model = [[TFEmailsListModel alloc] initWithDictionary:dic error:nil];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
                
            case HQCMD_moduleEmailGetModuleEmails:// 选择模块联系人
            {
                NSArray *files = data[kData];
                
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *dict in files) {
                    
                    TFEmailModuleListModel *model = [[TFEmailModuleListModel alloc] initWithDictionary:dict error:nil];
                    
                    [array addObject:model];
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:array];
            }
                break;
                
            case HQCMD_moduleEmailGetEmailFromModuleDetail:// 模块邮件
            {
                NSArray *arr = data[kData];
                
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    
                    TFEmailModuleAccountModel *model = [[TFEmailModuleAccountModel alloc] initWithDictionary:dict error:nil];
                    
                    [array addObject:model];
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:array];
            }
                break;
                
            case HQCMD_mailOperationDeleteDraft:// 邮件草稿删除
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_mailOperationClearMail:// 彻底删除
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_mailOperationMarkNotTrash:// 标记不是垃圾邮件
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_mailOperationEditDraft:// 编辑草稿
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_mailOperationManualSend:// 手动发送
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            default:
                break;
        }
        
        [super succeedCallbackWithResponse:resp];
    }
}

@end
