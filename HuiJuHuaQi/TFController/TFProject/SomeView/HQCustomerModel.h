//
//  HQCustomerModel.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/3/17.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol HQCustomerModel @end

@interface HQCustomerModel : JSONModel

/**
 * 客户id
 */
@property (nonatomic, strong) NSNumber *customerId;

/**
 * 客户标题
 */
@property (nonatomic, strong) NSString *customerTitle;

/**
 *  权限，1为有，0为无
 */
@property (nonatomic, assign) NSInteger isHavePermission;

/**
 *  添加时间
 */
@property (nonatomic, strong) NSString *time;

/**
 *  负责人
 */
@property (nonatomic, copy) NSString *responsible;

@end
