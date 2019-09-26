//
//  TFChatBL.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/11/30.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFChatBL.h"
#import "TFChatInfoListModel.h"
#import "TFGroupInfoModel.h"
#import "TFAssistListModel.h"
#import "TFAssistantSiftModel.h"
#import "TFAssistantAuthModel.h"
#import "TFAssistantMainModel.h"

@implementation TFChatBL

/**
 获取会话列表
 */

-(void)requestGetChatListInfoData {
    

    NSString *url = [super urlFromCmd:HQCMD_getChatListInfo];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:nil
                                            cmdId:HQCMD_getChatListInfo
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

//{
//    "name":"群名称",                 //群名称
//    "notice": "深圳市南山区",        //群公告
//    "peoples": "10，12",            //群成员，成员间以半角的，分割
//    "type": "1"                     //群聊类型设置 0：总群 1：新建群聊
//}

/**
 创建群聊
 */

-(void)requestAddGroupChatWithData:(NSString *)groupName groupNotice:(NSString *)groupNotice peoples:(NSString *)peoples {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (groupName) {
        
        [dict setObject:groupName forKey:@"name"];
    }
    if (groupNotice) {
        
        [dict setObject:groupNotice forKey:@"notice"];
    }
    if (peoples) {
        
        [dict setObject:peoples forKey:@"peoples"];
    }
    if (UM.userLoginInfo.employee.employee_name) {
        [dict setObject:UM.userLoginInfo.employee.employee_name forKey:@"principal_name"];
    }
    [dict setObject:@"1" forKey:@"type"];
    
    NSString *url = [super urlFromCmd:HQCMD_addGroupChat];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_addGroupChat
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/**
 创建单聊
 */

-(void)requestAddSingleChatWithData:(NSNumber *)receiverId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (receiverId) {
        
        [dict setObject:receiverId forKey:@"receiverId"];
    }

    
    NSString *url = [super urlFromCmd:HQCMD_addSingleChat];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_addSingleChat
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/**
 获取所有群组
 */

-(void)requestGetAllGroupsInfoData {
    
    
    NSString *url = [super urlFromCmd:HQCMD_getAllGroupsInfo];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:nil
                                            cmdId:HQCMD_getAllGroupsInfo
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/**
 单聊设置
 */

-(void)requestGetSingleInfoWithData:(NSNumber *)chatId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (chatId) {
        
        [dict setObject:chatId forKey:@"chatId"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_getSingleInfo];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getSingleInfo
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/**
 群聊设置
 */

-(void)requestGetGroupInfoWithData:(NSNumber *)groupId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (groupId) {
        
        [dict setObject:groupId forKey:@"groupId"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_getGroupInfo];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getGroupInfo
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/**
 置顶
 */

-(void)requestSetTopChatWithData:(NSNumber *)chatId chatType:(NSNumber *)chatType {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (chatId) {
        
        [dict setObject:chatId forKey:@"id"];
    }
    if (chatType) {
        
        [dict setObject:chatType forKey:@"chat_type"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_setTopChat];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_setTopChat
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/**
 免打扰
 */

-(void)requestSetNoBotherWithData:(NSNumber *)chatId chatType:(NSNumber *)chatType {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (chatId) {
        
        [dict setObject:chatId forKey:@"id"];
    }
    if (chatType) {
        
        [dict setObject:chatType forKey:@"chat_type"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_setNoBother];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_setNoBother
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/**
 退群
 */

-(void)requestQuiteGroupWithData:(NSNumber *)groupId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (groupId) {
        
        [dict setObject:groupId forKey:@"id"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_quitChatGroup];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_quitChatGroup
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/**
 解散群
 */

-(void)requestReleaseGroupWithData:(NSNumber *)groupId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (groupId) {
        
        [dict setObject:groupId forKey:@"id"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_releaseGroup];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_releaseGroup
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/**
 拉人
 */

-(void)requestPullPeopleWithData:(NSNumber *)groupId personId:(NSString *)personId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (groupId) {
        
        [dict setObject:groupId forKey:@"id"];
    }
    if (personId) {
        
        [dict setObject:personId forKey:@"selected_person"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_pullPeople];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_pullPeople
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/**
 踢人
 */

-(void)requestKickPeopleWithData:(NSNumber *)groupId personId:(NSString *)personId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (groupId) {
        
        [dict setObject:groupId forKey:@"id"];
    }
    if (personId) {
        
        [dict setObject:personId forKey:@"selected_person"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_kickPeople];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_kickPeople
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/**
 删除
 */

-(void)requestHideSessionWithData:(NSNumber *)chatId chatType:(NSNumber *)chatType {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (chatId) {
        
        [dict setObject:chatId forKey:@"id"];
    }
    if (chatType) {
        
        [dict setObject:chatType forKey:@"chat_type"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_hideSession];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_hideSession
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 小助手列表 */
-(void)requestGetAssistantMessageWithData:(NSNumber *)assistantId beanName:(NSString *)beanName pageSize:(NSNumber *)pageSize pageNo:(NSNumber *)pageNo {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (assistantId) {
        
        [dict setObject:assistantId forKey:@"id"];
    }
    if (pageSize) {
        
        [dict setObject:pageSize forKey:@"pageSize"];
    }
    if (pageNo) {
        
        [dict setObject:pageNo forKey:@"pageNo"];
    }
    if (beanName) {
        
        [dict setObject:beanName forKey:@"beanName"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getAssistantMessage];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getAssistantMessage
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 获取小助手设置相关信息 */
-(void)requestGetAssistantInfoWithData:(NSNumber *)assistantId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (assistantId) {
        
        [dict setObject:assistantId forKey:@"assisstantId"];
    }

    
    NSString *url = [super urlFromCmd:HQCMD_getAssistantInfo];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getAssistantInfo
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 全部标为已读 */
-(void)requestMarkAllReadWithData:(NSNumber *)assistantId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (assistantId) {
        
        [dict setObject:assistantId forKey:@"id"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_markAllRead];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_markAllRead
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/**
 修改群信息
 */

-(void)requestModifyGroupInfoWithData:(NSNumber *)groupId groupName:(NSString *)groupName notice:(NSString *)notice {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (groupId) {
        
        [dict setObject:groupId forKey:@"id"];
    }
    if (groupName) {
        
        [dict setObject:groupName forKey:@"name"];
    }
    if (notice) {
        
        [dict setObject:notice forKey:@"notice"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_modifyGroupInfo];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_modifyGroupInfo
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 小助手筛选 */

-(void)requestFindModuleListWithData:(NSNumber *)appId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (appId) {
        
        [dict setObject:appId forKey:@"application_id"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_findModuleList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_findModuleList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 小助手读取状态 */
-(void)requestReadMessageWithData:(NSNumber *)msgId assistantId:(NSNumber *)assistantId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (msgId) {
        
        [dict setObject:msgId forKey:@"id"];
    }
    if (assistantId) {
        
        [dict setObject:assistantId forKey:@"assistantId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_readMessage];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_readMessage
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 标记小助手已读未读 */
-(void)requestMarkReadOptionWithData:(NSNumber *)assId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (assId) {
        
        [dict setObject:assId forKey:@"id"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_markReadOption];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_markReadOption
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 小助手自定义应用权限 */
-(void)requestGetAuthByBeanWithData:(NSNumber *)assisId bean:(NSString *)bean {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (assisId) {
        
        [dict setObject:assisId forKey:@"dataId"];
    }
    if (bean) {
        
        [dict setObject:bean forKey:@"bean"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getAuthByBean];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getAuthByBean
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 小助手文件库权限 */
-(void)requestGetAuthByBeanWithData:(NSNumber *)fileId style:(NSNumber *)style {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (fileId) {
        
        [dict setObject:fileId forKey:@"id"];
    }
    if (style) {
        
        [dict setObject:style forKey:@"style"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_queryAidePower];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_queryAidePower
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 小助手列表数据权限判断 */
-(void)requestGetFuncAuthWithCommunalWithData:(NSString *)bean moduleId:(NSNumber *)moduleId style:(NSNumber *)style dataId:(NSNumber *)dataId reqmap:(NSString *)reqmap{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (bean) {
        
        [dict setObject:bean forKey:@"bean"];
    }
    if (moduleId) {
        
        [dict setObject:moduleId forKey:@"moduleId"];
    }
    if (style) {
        
        [dict setObject:style forKey:@"style"];
    }
    if (dataId) {
        
        [dict setObject:dataId forKey:@"dataId"];
    }
    if (reqmap) {
        
        [dict setObject:reqmap forKey:@"reqmap"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getFuncAuthWithCommunal];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getFuncAuthWithCommunal
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/**
 隐藏状态更改
 */

-(void)requestHideSessionWithStatus:(NSNumber *)id chatType:(NSNumber *)chatType status:(NSNumber *)status {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (id) {
        
        [dict setObject:id forKey:@"id"];
    }
    if (chatType) {
        
        [dict setObject:chatType forKey:@"chat_type"];
    }
    if (status) {
    
        [dict setObject:status forKey:@"status"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_HideSessionWithStatus];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_HideSessionWithStatus
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 小助手历史数据 */
-(void)requestGetAssistantMessageLimitData:(NSNumber *)assistantId beanName:(NSString *)beanName upTime:(NSNumber *)upTime downTime:(NSNumber *)downTime dataSize:(NSNumber *)dataSize {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (assistantId) {
        
        [dict setObject:assistantId forKey:@"id"];
    }
    if (beanName) {
        
        [dict setObject:beanName forKey:@"beanName"];
    }
    if (upTime) {
        
        [dict setObject:upTime forKey:@"upTime"];
    }
    if (downTime) {
        
        [dict setObject:downTime forKey:@"downTime"];
    }
    if (dataSize) {
        
        [dict setObject:dataSize forKey:@"dataSize"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getAssistantMessageLimit];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getAssistantMessageLimit
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 转让群主 */
-(void)requestTransferGroupWithData:(NSNumber *)groupId signId:(NSNumber *)signId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (groupId) {
        
        [dict setObject:groupId forKey:@"id"];
    }
    if (signId) {
        
        [dict setObject:signId forKey:@"signId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_imChatTransferGroup];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_imChatTransferGroup
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/**
 人员搜索
 */
-(void)requestEmployeeFindEmployeeVagueWithData:(NSNumber *)departmentId employeeName:(NSString *)employeeName {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (departmentId) {
        
        [dict setObject:departmentId forKey:@"departmentId"];
    }
    if (employeeName) {
        
        [dict setObject:employeeName forKey:@"employeeName"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_employeeFindEmployeeVague];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_employeeFindEmployeeVague
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
            case HQCMD_uploadFile:// 上传文件
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
                
            case HQCMD_getChatListInfo:// 会话列表
            {
                NSArray *arr = data[kData];
                
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *dict in arr) {

                    TFChatInfoListModel *model = [[TFChatInfoListModel alloc] initWithDictionary:dict error:nil];
                    
                    [array addObject:model];
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:array];
            }
                break;
                
            case HQCMD_addGroupChat:// 群聊
            {

                NSDictionary *dic = data[kData];
                
                TFGroupInfoModel *model = [[TFGroupInfoModel alloc] initWithDictionary:dic error:nil];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
                
            case HQCMD_addSingleChat:// 单聊
            {
                
                NSDictionary *dic = data[kData];
                
                TFChatInfoListModel *model = [[TFChatInfoListModel alloc] initWithDictionary:dic error:nil];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
            case HQCMD_getAllGroupsInfo:// 获取所有群组
            {
                
                NSArray *arr = data[kData];
                
                NSMutableArray *array = [NSMutableArray array];
                
                for (NSDictionary *dic in arr) {
                    
                    TFChatInfoListModel *model = [[TFChatInfoListModel alloc] initWithDictionary:dic error:nil];
                    
                    [array addObject:model];
                }
                
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:array];
            }
                break;
                
            case HQCMD_getSingleInfo:// 单聊设置
            {
                
                NSDictionary *dic = data[kData];
                
                TFChatInfoListModel *model = [[TFChatInfoListModel alloc] initWithDictionary:dic error:nil];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
                
            case HQCMD_getGroupInfo:// 群聊设置
            {
                
                NSDictionary *dic = data[kData];
                
                TFGroupInfoModel *model = [[TFGroupInfoModel alloc] initWithDictionary:dic error:nil];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
                
            case HQCMD_setTopChat:// 置顶
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
                
            case HQCMD_setNoBother:// 免打扰
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
                
            case HQCMD_quitChatGroup:// 退群
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
                
            case HQCMD_releaseGroup:// 解散群
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
                
            case HQCMD_pullPeople:// 拉人
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
                
            case HQCMD_kickPeople:// 踢人
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
                
            case HQCMD_hideSession:// 删除
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
                
            case HQCMD_getAssistantInfo:// 小助手设置
            {
                NSDictionary *dic = data[kData];
                
                TFChatInfoListModel *model = [[TFChatInfoListModel alloc] initWithDictionary:dic error:nil];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
                
            case HQCMD_markAllRead://
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
                
            case HQCMD_getAssistantMessage://小助手列表
            {
                
                NSDictionary *dic = data[kData];
//                NSArray *arr = [dic valueForKey:@"dataList"];
                
                TFAssistantMainModel *mainModel = [[TFAssistantMainModel alloc] initWithDictionary:dic error:nil];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:mainModel];
//                NSMutableArray *array = [NSMutableArray array];
//
//                for (NSDictionary *dic in arr) {
//
//                    TFAssistListModel *model = [[TFAssistListModel alloc] initWithDictionary:dic error:nil];
//
//                    [array addObject:model];
//                }
//
//
//                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:array];
            }
                break;
                
            case HQCMD_findModuleList:
            {
            
                NSArray *arr = data[kData];
                NSMutableArray *array = [NSMutableArray array];
                
                for (NSDictionary *dic in arr) {
                    
                    TFAssistantSiftModel *model = [[TFAssistantSiftModel alloc] initWithDictionary:dic error:nil];
                    
                    [array addObject:model];
                }
                
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:array];
                
            }
            
                break;
                
            case HQCMD_readMessage://
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
                
            case HQCMD_markReadOption://
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
                
            case HQCMD_modifyGroupInfo://修改群信息
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
                
            case HQCMD_imChatTransferGroup://转让群
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
                
            case HQCMD_getAuthByBean://
            {
                NSDictionary *dic = data[kData];
                
                TFAssistantAuthModel *model = [[TFAssistantAuthModel alloc] initWithDictionary:dic error:nil];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
                
            case HQCMD_queryAidePower://
            {
                NSDictionary *dic = data[kData];
                
                TFAssistantAuthModel *model = [[TFAssistantAuthModel alloc] initWithDictionary:dic error:nil];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
                
            case HQCMD_getFuncAuthWithCommunal://
            {
                NSDictionary *dic = data[kData];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dic];
            }
                break;
                
            case HQCMD_getAssistantMessageLimit://小助手列表历史
            {
                
                NSDictionary *dic = data[kData];
                TFAssistantMainModel *mainModel = [[TFAssistantMainModel alloc] initWithDictionary:dic error:nil];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:mainModel];
                
            }
                break;
                
            default:
                break;
        }
        
        [super succeedCallbackWithResponse:resp];
    }
}


@end
