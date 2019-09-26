//
//  TFCustomSelectOptionCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/8/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQBaseCell.h"
#import "TFCustomerRowsModel.h"

@protocol TFCustomSelectOptionCellDelegate<NSObject>
@optional
-(void)customOptionItemCellDidClickedOptions:(NSArray *)options isSingle:(BOOL)isSingle model:(TFCustomerRowsModel *)model level:(NSInteger)level;

@end

@interface TFCustomSelectOptionCell : HQBaseCell

/** edit */
@property (nonatomic, assign) BOOL edit;
/** model */
@property (nonatomic, strong) TFCustomerRowsModel *model;
/** 必填控制 */
@property (nonatomic, copy) NSString *fieldControl;
/** 标题 */
@property (nonatomic, copy) NSString *title;

/** 展示样式 YES：编辑样式  NO: 详情样式 */
@property (nonatomic, assign) BOOL showEdit;


/** delegate */
@property (nonatomic, weak) id <TFCustomSelectOptionCellDelegate>delegate;

/** 创建cell */
+(instancetype)customSelectOptionCellWithTableView:(UITableView *)tableView;

/** 高度 */
+(CGFloat)refreshCustomSelectOptionCellHeightWithModel:(TFCustomerRowsModel *)model showEdit:(BOOL)showEdit;

@end
