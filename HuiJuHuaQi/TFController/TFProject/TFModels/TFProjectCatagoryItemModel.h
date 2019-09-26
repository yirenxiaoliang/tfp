//
//  TFProjectCatagoryItemModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/11.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFProjectCatagoryItemModel

@end

@interface TFProjectCatagoryItemModel : JSONModel


/** 数量？ */
@property (nonatomic, strong) NSNumber <Optional>*count;
/** 项目id */
@property (nonatomic, strong) NSNumber <Optional>*id;
/** 不可用 */
@property (nonatomic, strong) NSNumber <Optional>*disabled;
/** 创建时间 */
@property (nonatomic, strong) NSNumber <Optional>*createDate;
/**类型Id:100=项目协作;200=销售业务;300=生产制造;400=设计研发;500=互联网 */
@property (nonatomic, strong) NSNumber <Optional>*categoryId;
/** 公司id */
@property (nonatomic, strong) NSNumber <Optional>*companyId;
/** 模板名 */
@property (nonatomic, copy) NSString <Optional>*categoryName;
/** type */
@property (nonatomic, strong) NSNumber <Optional>*type;

/** select */
@property (nonatomic, assign) NSNumber <Ignore>*isSelect;


@end
