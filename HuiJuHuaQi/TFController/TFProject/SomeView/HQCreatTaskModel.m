//
//  HQCreatTaskModel.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/7/27.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQCreatTaskModel.h"

@implementation HQCreatTaskModel


- (instancetype)init{
    
    if (self = [super init]) {
        self.taskTags = [NSMutableArray array];
        self.urgents = [NSMutableArray array];
        self.records = [NSMutableArray array];
        self.netRecords = [NSMutableArray array];
        self.responsiblePeopleIDs = [NSMutableArray array];
        self.prarticipantPeopleIDs = [NSMutableArray array];
        self.checkers = [NSMutableArray array];
        self.relatedTasks = [NSMutableArray array];
        self.relatedCustomers = [NSMutableArray array];
        self.relatedCustomerIDs = [NSMutableArray array];
        self.pictures = [NSMutableArray array];
        self.attachments = [NSMutableArray array];
        self.addPictures = [NSMutableArray array];
        self.frontTasks = [NSMutableArray array];
        self.files = [NSMutableArray array];
        
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    HQCreatTaskModel *instance = [[HQCreatTaskModel allocWithZone:zone] init];
    if (instance) {
        instance.taskID = self.taskID;
        instance.commitType = self.commitType;
        instance.projectId = self.projectId;
        instance.projectStageId = self.projectStageId;
        
        instance.projectName = self.projectName;
        instance.projectStage = self.projectStage;
        instance.taskTitle = self.taskTitle;
        instance.taskContent = self.taskContent;
        
        instance.taskTags = self.taskTags.mutableCopy;
        instance.endTime = self.endTime;
        instance.endTimeSp = self.endTimeSp;
        instance.responsiblePeopleIDs = self.responsiblePeopleIDs.mutableCopy;
        instance.responsiblePeopleID = self.responsiblePeopleID;
        
        instance.prarticipantPeopleIDs = self.prarticipantPeopleIDs.mutableCopy;
        instance.checkers = self.checkers.mutableCopy;
        instance.frontTasks = self.frontTasks.mutableCopy;
        instance.check = self.check;
        
        instance.urgents = self.urgents.mutableCopy;
        instance.urgent = self.urgent;
        instance.records = self.records.mutableCopy;
        instance.netRecords = self.netRecords.mutableCopy;
        instance.voiceOperation = self.voiceOperation;
        
        instance.recordTime = self.recordTime;
        instance.recorderUrl = self.recorderUrl;
        instance.relatedTasks = self.relatedTasks.mutableCopy;
        instance.relatedCustomers = self.relatedCustomers.mutableCopy;
        instance.relatedCustomerIDs = self.relatedCustomerIDs.mutableCopy;
        
        instance.pictures = self.pictures.mutableCopy;
        instance.voiceUrl = self.voiceUrl;
        instance.attachments = self.attachments.mutableCopy;
        instance.addPictures = self.addPictures.mutableCopy;
        
        instance.files = self.files.mutableCopy;
        instance.haveNumber = self.haveNumber;
        instance.number = self.number;
        instance.numberDesc = self.numberDesc;
        
        instance.haveMoney = self.haveMoney;
        instance.money = self.money;
        instance.moneyDesc = self.moneyDesc;
        
    }
    return instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    HQCreatTaskModel *instance = [[HQCreatTaskModel allocWithZone:zone] init];
    if (instance) {
        
        instance.taskID = self.taskID;
        instance.commitType = self.commitType;
        instance.projectId = self.projectId;
        instance.projectStageId = self.projectStageId;
        
        instance.projectName = self.projectName;
        instance.projectStage = self.projectStage;
        instance.taskTitle = self.taskTitle;
        instance.taskContent = self.taskContent;
        
        instance.taskTags = self.taskTags.mutableCopy;
        instance.endTime = self.endTime;
        instance.endTimeSp = self.endTimeSp;
        instance.responsiblePeopleIDs = self.responsiblePeopleIDs.mutableCopy;
        instance.responsiblePeopleID = self.responsiblePeopleID;
        
        instance.prarticipantPeopleIDs = self.prarticipantPeopleIDs.mutableCopy;
        instance.checkers = self.checkers.mutableCopy;
        instance.frontTasks = self.frontTasks.mutableCopy;
        instance.check = self.check;
        
        instance.urgents = self.urgents.mutableCopy;
        instance.urgent = self.urgent;
        instance.records = self.records.mutableCopy;
        instance.netRecords = self.netRecords.mutableCopy;
        instance.voiceOperation = self.voiceOperation;
        
        instance.recordTime = self.recordTime;
        instance.recorderUrl = self.recorderUrl;
        instance.relatedTasks = self.relatedTasks.mutableCopy;
        instance.relatedCustomers = self.relatedCustomers.mutableCopy;
        instance.relatedCustomerIDs = self.relatedCustomerIDs.mutableCopy;
        
        instance.pictures = self.pictures.mutableCopy;
        instance.voiceUrl = self.voiceUrl;
        instance.attachments = self.attachments.mutableCopy;
        instance.addPictures = self.addPictures.mutableCopy;
        
        instance.files = self.files.mutableCopy;
        instance.haveNumber = self.haveNumber;
        instance.number = self.number;
        instance.numberDesc = self.numberDesc;
        
        instance.haveMoney = self.haveMoney;
        instance.money = self.money;
        instance.moneyDesc = self.moneyDesc;
    }
    return instance;
}



//+ (HQCommitTaskModel *)creatTaskModelToCommitTaskModel:(HQCreatTaskModel *)creatTaskModel{
//    
//    HQCommitTaskModel *commit = [[HQCommitTaskModel alloc] init];
//    
//    commit.taskID = creatTaskModel.taskID;
//    commit.commitType = creatTaskModel.commitType;
//    commit.projectId = creatTaskModel.projectId;
//    commit.projectStageId = creatTaskModel.projectStageId;
//    
//    commit.title = creatTaskModel.taskTitle;
//    commit.detail = creatTaskModel.taskContent;
//    commit.tagIds = creatTaskModel.taskTags.mutableCopy;
//    commit.endTime = creatTaskModel.endTimeSp;
//    
//    commit.principalId = creatTaskModel.responsiblePeopleID;
//    commit.sendToIds = creatTaskModel.checkers.mutableCopy;
//    commit.taskIds = creatTaskModel.frontTasks.mutableCopy;
//    commit.openAcceptance = creatTaskModel.check;
//    
//    commit.emergency = creatTaskModel.urgent;
//    commit.voiceOperation = creatTaskModel.voiceOperation;
//    commit.voiceUrl = creatTaskModel.voiceUrl;
//    commit.voiceTime = creatTaskModel.recordTime;
//    
//    commit.relatedCustomerIDs = creatTaskModel.relatedCustomerIDs.mutableCopy;
//    commit.imageUrls = creatTaskModel.attachments.mutableCopy;
//    
//    return commit;
//}


//
//+ (HQCreatTaskModel *)commitTaskModelToCreatTaskModel:(HQCommitTaskModel *)commit{
//    
//    HQCreatTaskModel *creatTaskModel = [[HQCreatTaskModel alloc] init];
//    
//    creatTaskModel.taskID = commit.taskID;
//    creatTaskModel.commitType = commit.commitType;
//    creatTaskModel.projectId = commit.projectId;
//    creatTaskModel.projectStageId = commit.projectStageId ;
//    
//    creatTaskModel.taskTitle = commit.title ;
//    creatTaskModel.taskContent = commit.detail;
////    [creatTaskModel.taskTags addObjectsFromArray:commit.tagIds] ;
//    creatTaskModel.taskTags = commit.tagIds.mutableCopy;
//    
//    creatTaskModel.endTimeSp = commit.endTime;
//    
//    creatTaskModel.responsiblePeopleID = commit.principalId ;
//    
////    [creatTaskModel.checkers addObjectsFromArray:commit.sendToIds] ;
//    creatTaskModel.checkers = commit.sendToIds.mutableCopy;
//    
////    [creatTaskModel.frontTasks addObjectsFromArray:commit.taskIds] ;
//    creatTaskModel.frontTasks = commit.taskIds.mutableCopy;
//    
//    creatTaskModel.check = commit.openAcceptance ;
//    
//    creatTaskModel.urgent = commit.emergency ;
//    creatTaskModel.voiceOperation = commit.voiceOperation ;
//    creatTaskModel.voiceUrl = commit.voiceUrl ;
//    creatTaskModel.recordTime = commit.voiceTime ;
//    
////    [creatTaskModel.relatedCustomerIDs addObjectsFromArray:commit.relatedCustomerIDs] ;
//    creatTaskModel.relatedCustomerIDs = commit.relatedCustomerIDs.mutableCopy;
//    
////    [creatTaskModel.attachments addObjectsFromArray:commit.imageUrls] ;
//    creatTaskModel.attachments = commit.imageUrls.mutableCopy;
//    
//    return creatTaskModel;
//}
//
//
//
//+ (HQCreatTaskModel *)taskDetailModelToCreatTaskModel:(HQTaskDetailModel *)taskDetailModel{
//    
//    
//    HQCreatTaskModel *creatTaskModel = [[HQCreatTaskModel alloc] init];
//    
//    creatTaskModel.taskID = taskDetailModel.taskListBean.taskId;
//    creatTaskModel.taskTitle = taskDetailModel.taskListBean.title ;
//    
//    // 需做处理（1、显示 2、选中标签）
//    for (HQTagModel *tag in taskDetailModel.taskListBean.tags) {
//        
//        [creatTaskModel.taskTags addObject:tag.tagId] ;
//    }
//    
//    // 需做处理（1、显示 2、选中时间）
//    creatTaskModel.endTimeSp = taskDetailModel.taskListBean.endTime;
//    creatTaskModel.endTime = [HQHelper nsdateToTimeNowYear:taskDetailModel.taskListBean.endTime];
//
//    
//    // 负责人
//    creatTaskModel.responsiblePeopleID = taskDetailModel.taskListBean.principalId ;
//    if (taskDetailModel.taskListBean.principalId) {
//        
//        [creatTaskModel.responsiblePeopleIDs addObject:taskDetailModel.taskListBean.principalId];
//    }
//    
//    // 抄送人
//    [creatTaskModel.checkers addObjectsFromArray:taskDetailModel.sendToIds];
//    
//    [creatTaskModel.prarticipantPeopleIDs addObjectsFromArray:[HQHelper employeesWithEmployIds:taskDetailModel.sendToIds]];
//
//    
//    // 紧急度
//    creatTaskModel.urgent = taskDetailModel.taskListBean.emergency ;
//    if (taskDetailModel.taskListBean.emergency != 0) {
//        [creatTaskModel.urgents addObject:@(taskDetailModel.taskListBean.emergency)];
//    }
//    
//    
//    creatTaskModel.projectId = taskDetailModel.projectId;
//    creatTaskModel.projectStageId = taskDetailModel.projectStageId ;
//    
//    creatTaskModel.taskContent = taskDetailModel.detail;
//    
//    [creatTaskModel.frontTasks addObjectsFromArray:taskDetailModel.taskIds] ;
//    
//    creatTaskModel.check = taskDetailModel.openAcceptance ;
//    
//    // 网络录音
//    creatTaskModel.voiceUrl = taskDetailModel.voiceUrl ;
//    creatTaskModel.recordTime = taskDetailModel.voiceTime ;
//    if (taskDetailModel.voiceUrl && ![taskDetailModel.voiceUrl isEqualToString:@""]) {
//        [creatTaskModel.netRecords addObject:taskDetailModel.voiceUrl];
//    }
//    
//    // 关联客户
//    if (taskDetailModel.customerIds.count) {
//        for (HQCustomerModel *customer in taskDetailModel.customerIds) {
//            HQHighSeaModel *model = [[HQHighSeaModel alloc] init];
//            model.id = customer.customerId;
//            model.title = customer.customerTitle;
//            model.isLookDetail = customer.isHavePermission;
//            
//            [creatTaskModel.relatedCustomers addObject:model] ;
//            [creatTaskModel.relatedCustomerIDs addObject:customer.customerId] ;
//        }
//    }
//    // 图片
//    if (taskDetailModel.annexs.count) {
//        [creatTaskModel.attachments addObjectsFromArray:taskDetailModel.annexs] ;
//        [creatTaskModel.pictures addObjectsFromArray:taskDetailModel.annexs];
//    }
//    
//    // 此两项有实际操作决定
//    // creatTaskModel.commitType = commit.commitType;
//    // creatTaskModel.voiceOperation = commit.voiceOperation ;
//    
//    return creatTaskModel;
//}
//
//
//

//+ (HQCreatTaskModel *)projectStageModelToCreatTaskModel:(HQProjectStageModel *)projectStage{
//    
//    HQCreatTaskModel *creatTaskModel = [[HQCreatTaskModel alloc] init];
//    
//    creatTaskModel.projectId = projectStage.projectID;
//    creatTaskModel.projectStageId = projectStage.stageID;
//    creatTaskModel.projectName = projectStage.projectName;
//    creatTaskModel.projectStage = projectStage.stageName;
//    
//    
//    return creatTaskModel;
//}














@end
