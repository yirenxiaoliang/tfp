//
//  HQFileResponseModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/12/26.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseResponseModel.h"

@protocol HQFileInfo @end

@interface HQFileInfo : JSONModel

/** 尺寸 */
@property (nonatomic, strong) NSNumber <Optional>*attachSize;

/** 类型 */
@property (nonatomic, strong) NSString <Optional>*attachType;

/** 文件类型0其他1文档2图片3语音 */
@property (nonatomic, strong) NSString <Optional>*fileType;

/** URL */
@property (nonatomic, strong) NSString <Optional>* attachUrl ;

/** 原始名字 */
@property (nonatomic, strong) NSString <Optional>*attachName;

/** 序列号 */
@property (nonatomic, strong) NSNumber <Optional>* serialNumber ;

/** 所属记录的类型：0项目、1任务列表、2任务、3子任务or合同、4任务评论 */
@property (nonatomic, strong) NSNumber <Optional>*itemType;
/** 所属记录id，可为项目、任务列表、任务、子任务、任务评论、关联项 */
@property (nonatomic, strong) NSNumber <Optional>*itemId ;

/** 公司id */
@property (nonatomic, strong) NSNumber <Optional>* companyId  ;
/** 项目id */
@property (nonatomic, strong) NSNumber <Optional>* projectId  ;
@property (nonatomic, strong) NSNumber <Optional>* isRelated  ;
/** 创建人id */
@property (nonatomic, strong) NSNumber <Optional>* creatorId  ;
/** 任务列表id */
@property (nonatomic, strong) NSNumber <Optional>* taskListId  ;


@end


@interface HQFileResponseModel : HQBaseResponseModel

/** 文件数组信息 */
@property (nonatomic, strong) NSArray<Optional,HQFileInfo> *data;

@end










