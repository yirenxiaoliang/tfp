//
//  TFCompanyCircleBL.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/6/23.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseBL.h"

@interface TFCompanyCircleBL : HQBaseBL

/** 创建企业圈一条数据 */
-(void)requestCompanyCircleAddWithContent:(NSString *)content images:(NSArray *)images address:(NSString *)address longitude:(NSNumber *)longitude latitude:(NSNumber *)latitude peoples:(NSArray *)peoples;

/** 点赞or取消点赞 */
-(void)requestCompanyCircleUpWithCircleId:(NSNumber *)circleId;

/** 企业圈的评论 */
-(void)requestCompanyCircleUpWithCircleId:(NSNumber *)circleId senderId:(NSNumber *)senderId receiverId:(NSNumber *)receiverId content:(NSString *)content;

/** 删除企业圈 */
-(void)requestCompanyCircleDeleteWithCircleId:(NSNumber *)circleId;

/** 删除评论 */
-(void)requestCompanyCircleCommentDeleteWithCommentId:(NSNumber *)commentId;

/** 企业圈列表 */
-(void)requestCompanyCircleListWithPageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize isPerson:(NSNumber *)isPerson startTime:(NSNumber *)startTime endTime:(NSNumber *)endTime;

/** 企业圈个人详情 */
-(void)requestCompanyCirclePeopleDetailWithEmployeeId:(NSNumber *)employeeId imUserName:(NSString *)imUserName;

/** 企业圈个人详情 */
-(void)requestCompanyCirclePeopleBackgroundWithImCirclePhoto:(NSString *)imCirclePhoto;



@end
