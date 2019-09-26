//
//  TFKnowledgeBL.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/12/11.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseBL.h"

@interface TFKnowledgeBL : HQBaseBL
/** 保存知识 */
-(void)requestSaveKnowledgeWithDict:(NSDictionary *)dict;
/** 删除知识 id拼接，逗号分隔 */
-(void)requesDeleteKnowledgeWithKnowledgeId:(NSString *)knowledgeId;
/** 更新知识 */
-(void)requestUpdateKnowledgeWithDict:(NSDictionary *)dict;
/** 获取知识详情 */
-(void)requestGetKnowledgeDetailWithKnowledgeId:(NSNumber *)knowledgeId;
/** 获取知识列表 */
-(void)requestGetKnowledgeListWithCategoryId:(NSString *)categoryId labelId:(NSString *)labelId range:(NSNumber *)range keyWord:(NSString *)keyWord pageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize;
/** 获取分类及标签 */
-(void)requestGetKnowledgeCategoryAndLabel;
/** 获取标签 */
-(void)requestGetKnowledgeLabelWithCategoryId:(NSNumber *)categoryId;
/** 确认学习 0:确认 1:取消 */
-(void)requestSureLearnWithKnowledgeId:(NSNumber *)knowledgeId learnStatus:(NSNumber *)learnStatus;
/** 阅读及确认学习的人员列表 */
-(void)requestSureLearnAndReadPeopleWithKnowledgeId:(NSNumber *)knowledgeId;
/** 点赞 0:点赞 1:取消 */
-(void)requestGoodWithKnowledgeId:(NSNumber *)knowledgeId goodStatus:(NSNumber *)goodStatus;
/**点赞人员列表 */
-(void)requestGoodPeopleWithKnowledgeId:(NSNumber *)knowledgeId;
/**收藏 0:收藏 1:取消 */
-(void)requestCollectionWithKnowledgeId:(NSNumber *)knowledgeId collectStatus:(NSNumber *)collectStatus;
/** 收藏人员列表 */
-(void)requestCollectionPeopleWithKnowledgeId:(NSNumber *)knowledgeId;
/** 知识版本列表 */
-(void)requestKnowledgeVersionWithKnowledgeId:(NSNumber *)knowledgeId;
/** 单独的分类 */
-(void)requestGetKnowledgeCategory;
/**  移动 */
-(void)requestMoveKnowledgeWithDataId:(NSNumber *)dataId categoryId:(NSString *)categoryId labelIds:(NSString *)labelIds;
/**  回答保存 */
-(void)requestAnwserSaveWithDict:(NSDictionary *)dict;
/**  回答更新 */
-(void)requestAnwserUpdateWithDict:(NSDictionary *)dict;
/**  回答删除 */
-(void)requestAnwserDeleteWithDataId:(NSNumber *)dataId;
/**  回答详情 */
-(void)requestAnwserDetailWithDataId:(NSNumber *)dataId;
/**  提问回答列表 */
-(void)requestAnwserListWithDataId:(NSNumber *)dataId orderBy:(NSString *)orderBy;
/**  知识、提问置顶 */
-(void)requestKnowledgeTopWithDataId:(NSNumber *)dataId top:(NSNumber *)top;
/**  提问置顶 */
-(void)requestAnwserTopWithDataId:(NSNumber *)dataId status:(NSNumber *)status;
/** 知识引用列表 */
-(void)requestKnowledgeReferanceListWithKnowledgeId:(NSNumber *)knowledgeId fromStatus:(NSNumber *)fromStatus;
/** 邀请回答 */
-(void)requestInvitePeopleToAnswerWithDataId:(NSNumber *)dataId employeeIds:(NSString *)employeeIds;
/** 将选择任务等换成卡片样式（所有引用或关联都可用此接口） */
-(void)requestChangeItemToCardWithIds:(NSString *)ids beanType:(NSNumber *)beanType;

@end
