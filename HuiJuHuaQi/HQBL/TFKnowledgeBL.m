//
//  TFKnowledgeBL.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/12/11.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFKnowledgeBL.h"
#import "TFCategoryModel.h"
#import "TFKnowledgeListModel.h"
#import "TFKnowledgeVersionModel.h"

@implementation TFKnowledgeBL


/** 保存知识 */
-(void)requestSaveKnowledgeWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_saveKnowledge];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_saveKnowledge
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 删除知识 */
-(void)requesDeleteKnowledgeWithKnowledgeId:(NSString *)knowledgeId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (!IsStrEmpty(knowledgeId)) {
        [dict setObject:knowledgeId forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_deleteKnowledge];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_deleteKnowledge
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 更新知识 */
-(void)requestUpdateKnowledgeWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_updateKnowledge];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_updateKnowledge
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 获取知识详情 */
-(void)requestGetKnowledgeDetailWithKnowledgeId:(NSNumber *)knowledgeId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (knowledgeId) {
        [dict setObject:knowledgeId forKey:@"repositoryId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getKnowledgeDetail];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getKnowledgeDetail
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 获取知识列表 */
-(void)requestGetKnowledgeListWithCategoryId:(NSString *)categoryId labelId:(NSString *)labelId range:(NSNumber *)range keyWord:(NSString *)keyWord pageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (categoryId) {
        [dict setObject:categoryId forKey:@"class_id"];
    }
    if (labelId) {
        [dict setObject:labelId forKey:@"label_id"];
    }
    if (range) {
        [dict setObject:range forKey:@"range"];
    }
    if (keyWord) {
        [dict setObject:keyWord forKey:@"keyWord"];
    }
    [dict setObject:@(pageNum) forKey:@"pageNum"];
    [dict setObject:@(pageSize) forKey:@"pageSize"];
    
    NSString *url = [super urlFromCmd:HQCMD_getKnowledgeList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_getKnowledgeList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 获取分类及标签 */
-(void)requestGetKnowledgeCategoryAndLabel{
    
    NSString *url = [super urlFromCmd:HQCMD_getKnowledgeCategoryAndLabel];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:nil
                                            cmdId:HQCMD_getKnowledgeCategoryAndLabel
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 获取标签 */
-(void)requestGetKnowledgeLabelWithCategoryId:(NSNumber *)categoryId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (categoryId) {
        [dict setObject:categoryId forKey:@"classificationId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_knowledgeLabel];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_knowledgeLabel
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 确认学习 0:确认 1:取消 */
-(void)requestSureLearnWithKnowledgeId:(NSNumber *)knowledgeId learnStatus:(NSNumber *)learnStatus{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (knowledgeId) {
        [dict setObject:knowledgeId forKey:@"repositoryId"];
    }
    if (learnStatus) {
        [dict setObject:learnStatus forKey:@"status"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_sureLearnKnowledge];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_sureLearnKnowledge
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 阅读及确认学习的人员列表 */
-(void)requestSureLearnAndReadPeopleWithKnowledgeId:(NSNumber *)knowledgeId{
   
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (knowledgeId) {
        [dict setObject:knowledgeId forKey:@"repositoryId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_learnAndReadKnowledgePeople];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_learnAndReadKnowledgePeople
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 点赞 0:点赞 1:取消 */
-(void)requestGoodWithKnowledgeId:(NSNumber *)knowledgeId goodStatus:(NSNumber *)goodStatus{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (knowledgeId) {
        [dict setObject:knowledgeId forKey:@"repositoryId"];
    }
    if (goodStatus) {
        [dict setObject:goodStatus forKey:@"status"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_goodKnowledge];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_goodKnowledge
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/**点赞人员列表 */
-(void)requestGoodPeopleWithKnowledgeId:(NSNumber *)knowledgeId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (knowledgeId) {
        [dict setObject:knowledgeId forKey:@"repositoryId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_goodKnowledgePeople];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_goodKnowledgePeople
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/**收藏 0:收藏 1:取消 */
-(void)requestCollectionWithKnowledgeId:(NSNumber *)knowledgeId collectStatus:(NSNumber *)collectStatus{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (knowledgeId) {
        [dict setObject:knowledgeId forKey:@"repositoryId"];
    }
    if (collectStatus) {
        [dict setObject:collectStatus forKey:@"status"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_collectKnowledge];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_collectKnowledge
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 收藏人员列表 */
-(void)requestCollectionPeopleWithKnowledgeId:(NSNumber *)knowledgeId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (knowledgeId) {
        [dict setObject:knowledgeId forKey:@"repositoryId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_collectKnowledgePeople];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_collectKnowledgePeople
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 知识版本列表 */
-(void)requestKnowledgeVersionWithKnowledgeId:(NSNumber *)knowledgeId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (knowledgeId) {
        [dict setObject:knowledgeId forKey:@"repositoryId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_knowledgeVersion];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_knowledgeVersion
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 单独的分类 */
-(void)requestGetKnowledgeCategory{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setObject:@1 forKey:@"pageNum"];
//    [dict setObject:@10000 forKey:@"pageSize"];
    
    NSString *url = [super urlFromCmd:HQCMD_getKnowledgeCategory];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getKnowledgeCategory
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/**  移动 */
-(void)requestMoveKnowledgeWithDataId:(NSNumber *)dataId categoryId:(NSString *)categoryId labelIds:(NSString *)labelIds{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (dataId) {
        [dict setObject:dataId forKey:@"id"];
    }
    if (categoryId) {
        [dict setObject:categoryId forKey:@"classification_id"];
    }
    if (labelIds) {
        [dict setObject:labelIds forKey:@"label_ids"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_knowledgeMove];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_knowledgeMove
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/**  回答保存 */
-(void)requestAnwserSaveWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_anwserSave];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_anwserSave
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/**  回答更新 */
-(void)requestAnwserUpdateWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_anwserUpdate];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_anwserUpdate
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/**  回答删除 */
-(void)requestAnwserDeleteWithDataId:(NSNumber *)dataId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (dataId) {
        [dict setObject:dataId forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_anwserDelete];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_anwserDelete
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/**  回答详情 */
-(void)requestAnwserDetailWithDataId:(NSNumber *)dataId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (dataId) {
        [dict setObject:dataId forKey:@"answerId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_anwserDetail];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_anwserDetail
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/**  提问回答列表 */
-(void)requestAnwserListWithDataId:(NSNumber *)dataId orderBy:(NSString *)orderBy{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (dataId) {
        [dict setObject:dataId forKey:@"repositoryId"];
    }
    if (orderBy) {
        [dict setObject:orderBy forKey:@"orderBy"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_anwserList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_anwserList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/**  知识、提问置顶 */
-(void)requestKnowledgeTopWithDataId:(NSNumber *)dataId top:(NSNumber *)top{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (dataId) {
        [dict setObject:dataId forKey:@"id"];
    }
    if (top) {
        [dict setObject:top forKey:@"top"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_knowledgeTop];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_knowledgeTop
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 回答置顶 */
-(void)requestAnwserTopWithDataId:(NSNumber *)dataId status:(NSNumber *)status{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (dataId) {
        [dict setObject:dataId forKey:@"id"];
    }
    if (status) {
        [dict setObject:status forKey:@"status"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_anwserTop];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_anwserTop
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 知识引用列表 */
-(void)requestKnowledgeReferanceListWithKnowledgeId:(NSNumber *)knowledgeId fromStatus:(NSNumber *)fromStatus{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (knowledgeId) {
        [dict setObject:knowledgeId forKey:@"repositoryId"];
    }
    if (fromStatus) {
        [dict setObject:fromStatus forKey:@"fromStatus"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_knowledgeReferances];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_knowledgeReferances
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 邀请回答 */
-(void)requestInvitePeopleToAnswerWithDataId:(NSNumber *)dataId employeeIds:(NSString *)employeeIds{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (dataId) {
        [dict setObject:dataId forKey:@"id"];
    }
    if (employeeIds) {
        [dict setObject:employeeIds forKey:@"invite_employees"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_inviteToAnswer];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_inviteToAnswer
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 将选择任务等换成卡片样式（所有引用或关联都可用此接口） */
-(void)requestChangeItemToCardWithIds:(NSString *)ids beanType:(NSNumber *)beanType{
 
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (ids) {
        [dict setObject:ids forKey:@"ids"];
    }
    if (beanType) {
        [dict setObject:beanType forKey:@"beanType"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_changeItemToCard];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_changeItemToCard
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

-(void)requestManager:(HQRequestManager *)manager sequenceID:(NSInteger)sid didCompleteWithData:(id)data cmdId:(HQCMD)cmdId{
    BOOL result = [super requestManager:manager commonData:data sequenceID:sid cmdId:cmdId];
    HQResponseEntity *resp = nil;
    
    if (result) {
        switch (cmdId) {
            case HQCMD_saveKnowledge:
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_deleteKnowledge:
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_updateKnowledge:
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_getKnowledgeDetail:
            {
                NSDictionary *dict = data[kData];
                
                TFKnowledgeItemModel *model = [[TFKnowledgeItemModel alloc] initWithDictionary:dict error:nil];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
                
            case HQCMD_getKnowledgeList:
            {
                NSDictionary *dict = data[kData];
                TFKnowledgeListModel *listModel = [[TFKnowledgeListModel alloc] initWithDictionary:dict error:nil];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:listModel];
            }
                break;
            case HQCMD_getKnowledgeCategoryAndLabel:
            {
                NSArray *arr = data[kData];
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    TFCategoryModel *model = [[TFCategoryModel alloc] initWithDictionary:dict error:nil];
                    if (model) {
                        [models addObject:model];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
            case HQCMD_getKnowledgeCategory:
            {
                NSArray *dd = data[kData];
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dict in dd) {
                    TFCategoryModel *model = [[TFCategoryModel alloc] initWithDictionary:dict error:nil];
                    if (model) {
                        [models addObject:model];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
            case HQCMD_sureLearnKnowledge:
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_learnAndReadKnowledgePeople:
            {
                NSDictionary *dict = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
            case HQCMD_goodKnowledge:
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_goodKnowledgePeople:
            {
                NSArray *arr = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:arr];
            }
                break;
            case HQCMD_collectKnowledge:
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_collectKnowledgePeople:
            {
                NSArray *arr = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:arr];
            }
                break;
            case HQCMD_knowledgeVersion:
            {
                NSArray *arr = data[kData];
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    TFKnowledgeVersionModel *model = [[TFKnowledgeVersionModel alloc] initWithDictionary:dict error:nil];
                    if (model) {
                        [models addObject:model];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
            case HQCMD_knowledgeLabel:
            {
                NSArray *arr = data[kData];
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    TFCategoryModel *model = [[TFCategoryModel alloc] initWithDictionary:dict error:nil];
                    if (model) {
                        [models addObject:model];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
            case HQCMD_knowledgeMove:
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_anwserSave:
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_anwserUpdate:
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_anwserDelete:
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_anwserDetail:
            {
                NSDictionary *dict = data[kData];
                TFKnowledgeItemModel *model = [[TFKnowledgeItemModel alloc] initWithDictionary:dict error:nil];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
            case HQCMD_anwserList:
            {
                NSArray *arr = data[kData];
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    
                    TFKnowledgeItemModel *model = [[TFKnowledgeItemModel alloc] initWithDictionary:dict error:nil];
                    if (model) {
                        [models addObject:model];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
            case HQCMD_knowledgeTop:
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_anwserTop:
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_ChatFile:
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
            case HQCMD_knowledgeReferances:
            {
                NSDictionary *dict = data[kData];
                NSArray *arr = [dict valueForKey:@"dataList"];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:arr];
            }
                break;
            case HQCMD_inviteToAnswer:
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_changeItemToCard:
            {
                NSDictionary *dict = data[kData];
                NSArray *arr = [dict valueForKey:@"dataList"];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:arr];
            }
                break;
                
            default:
                break;
        }
        
        [super succeedCallbackWithResponse:resp];
    }
}

@end
