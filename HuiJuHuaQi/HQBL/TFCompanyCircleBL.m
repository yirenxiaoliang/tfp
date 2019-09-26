//
//  TFCompanyCircleBL.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/6/23.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCompanyCircleBL.h"
#import "TFCompanyCircleListModel.h"
#import "TFCircleEmployModel.h"

@implementation TFCompanyCircleBL

/** 创建企业圈一条数据 */
-(void)requestCompanyCircleAddWithContent:(NSString *)content images:(NSArray *)images address:(NSString *)address longitude:(NSNumber *)longitude latitude:(NSNumber *)latitude peoples:(NSArray *)peoples{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (content) {
        [dict setObject:content forKey:@"info"];
    }
    if (images) {
        [dict setObject:images forKey:@"images"];
    }
    if (address) {
        [dict setObject:address forKey:@"address"];
    }
    if (longitude) {
        [dict setObject:longitude forKey:@"longitude"];
    }
    if (latitude) {
        [dict setObject:latitude forKey:@"latitude"];
    }
    if (peoples) {
        [dict setObject:peoples forKey:@"peoples"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_companyCircleAdd];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_companyCircleAdd
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 点赞or取消点赞 */
-(void)requestCompanyCircleUpWithCircleId:(NSNumber *)circleId{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (circleId) {
        [dict setObject:circleId forKey:@"circleMainId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_companyCircleUp];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_companyCircleUp
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 企业圈的评论 */
-(void)requestCompanyCircleUpWithCircleId:(NSNumber *)circleId senderId:(NSNumber *)senderId receiverId:(NSNumber *)receiverId content:(NSString *)content{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (circleId) {
        [dict setObject:circleId forKey:@"circleMainId"];
    }
    if (senderId) {
        [dict setObject:senderId forKey:@"employeeId"];
    }
    if (receiverId) {
        [dict setObject:receiverId forKey:@"receiverId"];
    }
    if (content) {
        [dict setObject:content forKey:@"contentInfo"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_companyCircleComment];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_companyCircleComment
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 删除企业圈 */
-(void)requestCompanyCircleDeleteWithCircleId:(NSNumber *)circleId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (circleId) {
        [dict setObject:circleId forKey:@"circleMainId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_companyCircleDelete];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_companyCircleDelete
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 删除评论 */
-(void)requestCompanyCircleCommentDeleteWithCommentId:(NSNumber *)commentId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (commentId) {
        [dict setObject:commentId forKey:@"commentId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_companyCircleCommentDelete];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_companyCircleCommentDelete
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 企业圈列表 */
-(void)requestCompanyCircleListWithPageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize isPerson:(NSNumber *)isPerson startTime:(NSNumber *)startTime endTime:(NSNumber *)endTime{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (pageNo) {
        [dict setObject:pageNo forKey:@"pageNo"];
    }
    if (pageSize) {
        [dict setObject:pageSize forKey:@"pageSize"];
    }
    if (startTime) {
        [dict setObject:startTime forKey:@"startTime"];
    }
    if (endTime) {
        [dict setObject:endTime forKey:@"endTime"];
    }
    if (isPerson) {
        [dict setObject:isPerson forKey:@"isPerson"];
    }
    NSString *url = [super urlFromCmd:HQCMD_companyCircleList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_companyCircleList
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
            case HQCMD_companyCircleAdd:// 企业圈添加一条动态
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_companyCircleUp:// 企业圈的点赞
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_companyCircleComment:// 企业圈的评论
            {
                NSDictionary *dict = data[kData];
                HQCommentItemModel *model = [[HQCommentItemModel alloc] initWithDictionary:dict error:nil];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
            case HQCMD_companyCircleList:// 企业圈列表
            {
                NSDictionary *dict = data[kData];
                TFCompanyCircleListModel *model = [[TFCompanyCircleListModel alloc] initWithDictionary:dict error:nil];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
            case HQCMD_companyCircleDelete:// 企业圈删除
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_companyCircleCommentDelete:// 企业圈评论
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
                
            default:
                break;
        }
        
        [super succeedCallbackWithResponse:resp];
    }
}
@end
