//
//  TFPositionModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/22.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseVoModel.h"

@protocol TFPositionModel @end

@interface TFPositionModel : HQBaseVoModel


/** 职务名称 */
@property (nonatomic, copy) NSString <Optional>*name;

/** 职务状态 */
@property (nonatomic, copy) NSString <Optional>*status;

/** 职务名称 */
//@property (nonatomic, copy) NSString <Optional>*position;
/** 公司id */
@property (nonatomic, strong) NSNumber <Optional>*companyId;
/** isDefault */
@property (nonatomic, strong) NSNumber <Optional>*isDefault;
/** disabled */
@property (nonatomic, strong) NSNumber <Optional>*disabled;

/** 用于选择 */
@property (nonatomic, strong) NSNumber <Ignore>*select;


@end
