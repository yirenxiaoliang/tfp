//
//  TFNoticeCategoryModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/6/9.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "HQEmployModel.h"

@interface TFNoticeCategoryModel : JSONModel

/** 分类id */
@property (nonatomic, strong) NSNumber<Optional> *id;
/** 颜色 */
@property (nonatomic, copy) NSString<Optional> *color;
/** 标签名字 */
@property (nonatomic, copy) NSString<Optional> *typeName;
/** 类型 0 ：自建 1：全员公告 */
@property (nonatomic, strong) NSNumber<Optional> *type;
/** 人员个数 */
@property (nonatomic, strong) NSNumber<Optional> *count;

/** 创建者id */
@property (nonatomic, strong) NSNumber<Optional> *creatorId;
/** 创建时间 */
@property (nonatomic, strong) NSNumber<Optional> *createDate;
/** 接收人的版本号 */
@property (nonatomic, strong) NSNumber<Optional> *versionNumber;

/** 接收人数组 */
@property (nonatomic, strong) NSMutableArray <Optional,HQEmployModel>*receiverList;
/** 接收人数组 */
@property (nonatomic, strong) NSMutableArray <Optional>*receiverListIds;


/** 用于选择 */
@property (nonatomic, assign) NSNumber<Ignore> *select;


@end
