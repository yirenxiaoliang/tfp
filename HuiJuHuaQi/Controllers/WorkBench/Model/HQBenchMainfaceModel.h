//
//  HQBenchMainfaceModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/7/15.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HQBenchMainfaceModel : NSObject<NSCoding>


/** 所有Items */
@property (nonatomic, strong) NSMutableArray *allItems;
/** 工作台Items */
@property (nonatomic, strong) NSMutableArray *nowItems;
/** 员工ID */
@property (nonatomic, copy) NSNumber *employID;


/** *******************************固定工作台*************************** */
/** 归档 */
+ (void)benchMainfaceArchiveWithModel:(HQBenchMainfaceModel *)model;
/** 解档 */
+ (instancetype)benchMainfaceUnarchiveWithEmployID:(NSNumber *)employID;


/** *******************************滑动工作台*************************** */
/** 归档 */
+ (void)workDeskArchiveWithModel:(HQBenchMainfaceModel *)model;
/** 解档 */
+ (instancetype)workDeskUnarchiveWithEmployID:(NSNumber *)employID;


/** *******************************模块管管（我的应用）*************************** */
/** 归档 */
+ (void)modelManageArchiveWithModel:(HQBenchMainfaceModel *)model;
/** 解档 */
+ (instancetype)modelManageUnarchiveWithEmployID:(NSNumber *)employID;


/** *******************************第三方应用*************************** */
/** 归档 */
+ (void)thirdAppArchiveWithModel:(HQBenchMainfaceModel *)model;
/** 解档 */
+ (instancetype)thirdAppUnarchiveWithEmployID:(NSNumber *)employID;

/** *******************************所有审批*************************** */
/** 归档 */
+ (void)approvalTypeArchiveWithModel:(HQBenchMainfaceModel *)model;
/** 解档 */
+ (instancetype)approvalTypeUnarchiveWithEmployID:(NSNumber *)employID;


/** *******************************最近使用审批*************************** */
/** 归档 */
+ (void)nowApprovalTypeArchiveWithModel:(HQBenchMainfaceModel *)model;
/** 解档 */
+ (instancetype)nowApprovalTypeUnarchiveWithEmployID:(NSNumber *)employID;



/** *******************************销售应用*************************** */
/** 归档 */
+ (void)sellArchiveWithModel:(HQBenchMainfaceModel *)model;
/** 解档 */
+ (instancetype)sellUnarchiveWithEmployID:(NSNumber *)employID;


/** *******************************商品应用*************************** */
/** 归档 */
+ (void)goodsArchiveWithModel:(HQBenchMainfaceModel *)model;
/** 解档 */
+ (instancetype)goodsUnarchiveWithEmployID:(NSNumber *)employID;


@end
