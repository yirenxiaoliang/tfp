//
//  TFIMessageBL.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/6/5.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFIMessageBL.h"
#import "TFAssistantTypeModel.h"
#import "HQEmployModel.h"
#import "TFAssistantModel.h"
#import "TFGroupDetailModel.h"
#import "TFAssistantSettingModel.h"
#import "TFAssistantListModel.h"

@implementation TFIMessageBL


/** 获取公司总群和小秘书 */
-(void)getMessageCompanyAndAssistantGroup{
    
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    
//    NSString *url = [super urlFromCmd:HQCMD_messageGetBasicGroup];
//    
//    HQRequestItem *requestItem = [RM requestToURL:url
//                                           method:@"GET"
//                                     requestParam:dict
//                                            cmdId:HQCMD_messageGetBasicGroup
//                                         delegate:self
//                                       startBlock:^(HQCMD cmd, NSInteger sid) {
//                                       }];
//    
//    [self.tasks addObject:requestItem];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSString *url = [super urlFromCmd:HQCMD_messageGroupList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_messageGroupList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];

}

/** 获取助手列表 */
-(void)getMessageAssistList{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSString *url = [super urlFromCmd:HQCMD_messageGetAssistList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_messageGetAssistList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/** 获取助手信息 */
-(void)getMessageAssistDetailWithItemId:(NSNumber *)itemId isRead:(NSNumber *)isRead isHandle:(NSNumber *)isHandle pageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (itemId) {
        [dict setObject:itemId forKey:@"itemId"];
    }
    if (isRead) {
        [dict setObject:isRead forKey:@"isRead"];
    }
    if (isHandle) {
        [dict setObject:isHandle forKey:@"isHandle"];
    }
    if (pageNo) {
        [dict setObject:pageNo forKey:@"pageNo"];
    }
    if (pageSize) {
        [dict setObject:pageSize forKey:@"pageSize"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_messageGetAssistDetail];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_messageGetAssistDetail
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 更改助手处理状态 */
-(void)modifyMessageAssistHandleWithItemId:(NSNumber *)itemId isHandle:(NSNumber *)isHandle{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (itemId) {
        [dict setObject:itemId forKey:@"id"];
    }
    if (isHandle) {
        [dict setObject:isHandle forKey:@"isHandle"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_messageModifyHandle];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"POST"
                                     requestParam:dict
                                            cmdId:HQCMD_messageModifyHandle
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/** 更改助手已读状态 */
-(void)modifyMessageAssistReadWithItemId:(NSNumber *)itemId isRead:(NSNumber *)isRead{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (itemId) {
        [dict setObject:itemId forKey:@"id"];
    }
    if (isRead) {
        [dict setObject:@1 forKey:@"isRead"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_messageModifyRead];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"POST"
                                     requestParam:dict
                                            cmdId:HQCMD_messageModifyRead
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 置顶 */
-(void)messageTopWithItemId:(NSNumber *)itemId top:(NSNumber *)top{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (itemId) {
        [dict setObject:itemId forKey:@"itemId"];
    }
    if (top) {
        [dict setObject:top forKey:@"top"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_messageModifyTop];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"POST"
                                     requestParam:dict
                                            cmdId:HQCMD_messageModifyTop
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 助手待处理数据的清空 */
-(void)messageClearHandleWithItemId:(NSNumber *)itemId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (itemId) {
        [dict setObject:itemId forKey:@"itemId"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_messageClearHandle];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"POST"
                                     requestParam:dict
                                            cmdId:HQCMD_messageClearHandle
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 修改助手设置 */
-(void)messageModifyAssistantSetDataWithItemId:(NSNumber *)itemId itemType:(NSNumber *)itemType assiatNotice:(NSNumber *)assiatNotice{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (itemId) {
        [dict setObject:itemId forKey:@"itemId"];
    }
    if (itemType) {
        [dict setObject:itemType forKey:@"itemType"];
    }
    if (assiatNotice) {
        [dict setObject:assiatNotice forKey:@"assiatNotice"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_messageModifyAssistantSetData];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_messageModifyAssistantSetData
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/** 极光用户获取员工信息 */
-(void)employeeWithImUserName:(NSString *)imUserName{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (imUserName) {
        [dict setObject:imUserName forKey:@"imUserName"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_messageGetEmployee];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_messageGetEmployee
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 未读页面数据全部变为已读 */
-(void)modToAllReadWithItemId:(NSNumber *)itemId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (itemId) {
        [dict setObject:itemId forKey:@"itemId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_messageModToAllRead];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"POST"
                                     requestParam:dict
                                            cmdId:HQCMD_messageModToAllRead
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 获取助手设置信息 */
-(void)getAssistantSettingInfoWithItemId:(NSNumber *)itemId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (itemId) {
        [dict setObject:itemId forKey:@"itemId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_messageGetAssistSetData];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_messageGetAssistSetData
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 创建群组 */
-(void)creatGroupWithName:(NSString *)name desc:(NSString *)desc memberIds:(NSArray *)memberIds imUserNames:(NSArray *)imUserNames ownerUserName:(NSString *)ownerUserName{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (name) {
        [dict setObject:name forKey:@"name"];
    }
    if (desc) {
        [dict setObject:desc forKey:@"desc"];
    }
    if (memberIds) {
        [dict setObject:memberIds forKey:@"memberId"];
    }
    if (imUserNames) {
        [dict setObject:imUserNames forKey:@"membersUserName"];
    }
    if (ownerUserName) {
        [dict setObject:ownerUserName forKey:@"ownerUserName"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_messageAddGroup];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_messageAddGroup
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/** 获取群组 */
-(void)getGroupList{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSString *url = [super urlFromCmd:HQCMD_messageGroupList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_messageGroupList
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
                
            case HQCMD_messageGetAssistList:// 助手列表
            {
                NSDictionary *dict = data[kData];
                
                NSArray *arr = [dict valueForKey:@"taskDetail"];
                
                NSMutableArray *models = [NSMutableArray array];
                
                for (NSDictionary *dict1 in arr) {
                    
                    TFAssistantTypeModel *model = [[TFAssistantTypeModel alloc] initWithDictionary:dict1 error:nil];
                    [models addObject:model];
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
                
            case HQCMD_messageGetAssistDetail:// 助手详情
            {
                NSDictionary *dict = data[kData];
                TFAssistantListModel *model = [[TFAssistantListModel alloc] initWithDictionary:dict error:nil];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
            case HQCMD_messageModifyHandle:// 助手处理状态
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
                
            case HQCMD_messageModifyRead:// 助手已读状态
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_messageModifyTop:// 助手置顶
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_messageClearHandle:// 助手待处理数据的清空
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_messageModifyAssistantSetData:// 修改助手设置
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_messageGetEmployee:// 极光用户获取员工
            {
                NSDictionary *dict = data[kData];
                HQEmployModel *employ = [[HQEmployModel alloc] initWithDictionary:dict error:nil];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:employ];
            }
                break;
            case HQCMD_messageModToAllRead:// 未读页面数据全部变为已读
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_messageGetAssistSetData:// 获取助手设置信息
            {
                NSArray *arr = data[kData];
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    
                    TFAssistantSettingModel *model = [[TFAssistantSettingModel alloc] initWithDictionary:dict error:nil];
                    [models addObject:model];
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
            case HQCMD_messageAddGroup:// 新建群 
            {
                NSDictionary *dict = data[kData];
                TFGroupDetailModel *model = [[TFGroupDetailModel alloc] initWithDictionary:dict error:nil];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
            case HQCMD_messageGroupList:// 群list
            {
                NSDictionary *dict = data[kData];
                NSArray *arr = [dict valueForKey:@"groupList"];
                NSMutableArray *models = [NSMutableArray array];
                if (![arr isKindOfClass:[NSNull class]]) {
                    
                    for (NSDictionary *di in arr) {
                        
                        TFGroupDetailModel *model = [[TFGroupDetailModel alloc] initWithDictionary:di error:nil];
                        [models addObject:model];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
            case HQCMD_messageGetBasicGroup:// 总群和小秘书
            {
                NSDictionary *dict = data[kData];
                NSArray *arr = [dict valueForKey:@"groupList"];
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *di in arr) {
                    
                    TFGroupDetailModel *model = [[TFGroupDetailModel alloc] initWithDictionary:di error:nil];
                    [models addObject:model];
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
                
            default:
                break;
        }
        
        [super succeedCallbackWithResponse:resp];
    }
}



@end
