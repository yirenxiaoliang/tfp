//
//  TFFilterModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/8/17.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFCustomerOptionModel.h"
#import "TFFilterItemModel.h"

typedef enum {
    FilterTypePeople=1,// 人
    FilterTypeCreateTime,// 时间
    FilterTypeCustomerType,// 客户类型
    FilterTypeName,// 模糊名字
    
    
}FilterType;


@interface TFFilterModel : JSONModel

/** 筛选类型 text/picklist/area/location/textarea/email/url/personnel/phone */
@property (nonatomic, copy) NSString <Optional>*type;

/** 筛选类型名字 */
@property (nonatomic, copy) NSString <Optional>*name;

/** 字段名 */
@property (nonatomic, copy) NSString <Optional>*id;

/** 是否展开 */
@property (nonatomic, strong) NSNumber <Ignore>*open;

/** 展开后的子项 */
@property (nonatomic, strong) NSMutableArray <Ignore>*entrys;

/** 子项dict */
@property (nonatomic, strong) NSArray <Ignore>*options;

/** modelName */
@property (nonatomic, copy) NSString <Ignore>*modelName;
/** modelLabel */
@property (nonatomic, copy) NSString <Ignore>*modelLabel;
/** modelOpen */
@property (nonatomic, strong) NSNumber <Ignore>*modelOpen;

@end
