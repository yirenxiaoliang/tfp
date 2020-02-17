//
//  TFCustomerLayoutModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/8/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFCustomerRowsModel.h"

@protocol TFCustomerLayoutModel 

@end

@interface TFCustomerLayoutModel : JSONModel


/** 分栏中文名称 */
@property (nonatomic, copy) NSString <Optional>*title;
/** 分栏是否展开 0 不隐藏 ，1隐藏 */
@property (nonatomic, copy) NSString <Optional>*isSpread;
/** 分栏英文名称 */
@property (nonatomic, copy) NSString <Optional>*name;
/** pc端 */
@property (nonatomic, copy) NSString <Optional>*terminalPc;
/** APP端 */
@property (nonatomic, copy) NSString <Optional>*terminalApp;
/** 创建时显示 */
@property (nonatomic, copy) NSString <Optional>*isHideInCreate;
/** 详情时显示 */
@property (nonatomic, copy) NSString <Optional>*isHideInDetail;
/** 显示分栏名字 0 不隐藏 ，1隐藏*/
@property (nonatomic, copy) NSString <Optional>*isHideColumnName;

/** 选项控制是否隐藏 nil or 0 不隐藏 ，1隐藏 */
@property (nonatomic, copy) NSString <Ignore>*isOptionHidden;
/** 用于记录隐藏组件的name */
@property (nonatomic, copy) NSString <Ignore>*optionHiddenName;

/** 行 */
@property (nonatomic, strong) NSMutableArray <TFCustomerRowsModel,Optional>*rows;

/** 虚拟布局 */
@property (nonatomic, copy) NSString <Ignore>*virValue;
/** 位置 */
@property (nonatomic, strong) NSNumber <Ignore>*position;
/** 对应字段 */
@property (nonatomic, copy) NSString <Ignore>*fieldName;
/** 同一层 */
@property (nonatomic, copy) NSString <Ignore>*level;
/** 展示 */
@property (nonatomic, copy) NSString <Ignore>*show;
/** 只读属性 0 不只读 ，1只读*/
@property (nonatomic, copy) NSString <Optional>*fieldControl;
@property (nonatomic, copy) NSString <Optional>*add;
@property (nonatomic, copy) NSString <Optional>*adelete;

@end
