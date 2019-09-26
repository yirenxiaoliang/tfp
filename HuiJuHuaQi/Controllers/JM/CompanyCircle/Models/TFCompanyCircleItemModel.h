//
//  TFCompanyCircleItemModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/18.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseVoModel.h"

@interface TFCompanyCircleItemModel : HQBaseVoModel

/** addressDesc */
@property (nonatomic, copy) NSString *addressDesc;
/** 经度 */
@property (nonatomic, strong) NSNumber *longitude;
/** 纬度 */
@property (nonatomic, strong) NSNumber *latitude;
/** images */
@property (nonatomic, strong) NSArray *images;
/** content */
@property (nonatomic, copy) NSString *content;

@end
