//
//  HQCategoryItemModel.h
//  HuiJuHuaQi
//
//  Created by hq001 on 16/4/14.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "HQEmployModel.h"
#import "HQCommentItemModel.h"
#import "TFFileModel.h"

@protocol HQCategoryItemModel

@end

@interface HQCategoryItemModel : JSONModel

/**
 * 动态的唯一标识
 */
@property(nonatomic,strong) NSNumber <Optional> *id;

/**
 * 发布者信息
 */

@property(nonatomic,copy) NSString <Optional> *employeeId;

@property(nonatomic,copy) NSString <Optional> *photograph;

@property(nonatomic,copy) NSString <Optional> *employeeName;

/**
 * 发表时间
 */
@property(nonatomic,strong) NSNumber <Optional> *datetimeCreateDate;

/**
 * 发表地址
 */
@property(nonatomic,copy)NSString <Optional>* address;
/**
 * 经度
 */
@property(nonatomic,copy)NSString <Optional>* longitude;
/**
 * 纬度
 */
@property(nonatomic,copy)NSString <Optional>* latitude;


/**
 * 发表的描述信息
 */
@property(nonatomic,copy)NSString <Optional>* info;

/** 图片 */
@property(nonatomic,strong) NSArray<Optional,TFFileModel>* images;

/**
 * 为你点赞的人
 */
@property(nonatomic,strong) NSMutableArray<Optional,HQEmployModel> *praiseList;

/**
 * 评论数据
 */
@property(nonatomic,strong) NSMutableArray<HQCommentItemModel,Optional>* commentList;

/** 是否点赞 */
@property (nonatomic, strong) NSNumber <Optional>*isPraise;
/** 是否删除 */
@property (nonatomic, strong) NSNumber <Optional>*isDelete;


/** 显示全文 */
@property (nonatomic, strong) NSNumber <Ignore>*allWordShow;
/** 显示评论框 */
@property (nonatomic, strong) NSNumber <Ignore>*commentShow;


@end
