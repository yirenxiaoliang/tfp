//
//  TFCustomSelectCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFCustomerOptionModel.h"
#import "TFModuleModel.h"
#import "TFAttendenceFieldModel.h"

@interface TFCustomSelectCell : HQBaseCell

+ (TFCustomSelectCell *)CustomSelectCellWithTableView:(UITableView *)tableView;

//刷新弹框cell
- (void)refreshCustomSelectViewWithModel:(TFCustomerOptionModel *)model;

//刷新弹框cell高度
+ (CGFloat)refreshCustomSelectCellHeightWithModel:(TFCustomerOptionModel *)model;

// 选择模块
- (void)refreshCustomSelectAttendenceWithModel:(TFModuleModel *)model;
// 选择字段
- (void)refreshCustomSelectFieldWithModel:(TFAttendenceFieldModel *)model;
// 选择控制器
- (void)refreshCustomSelectVcWithModel:(TFCustomerOptionModel *)model;

// 选择控制器的高
+ (CGFloat)refreshCustomSelectVcHeightWithModel:(TFCustomerOptionModel *)model;

//刷新复选框cell
- (void)refreshCustomMultiCellWithModel:(TFCustomerOptionModel *)model;
//刷新复选框cell高度
+ (CGFloat)refreshCustomMultiCellHeightWithModel:(TFCustomerOptionModel *)model;

@end
