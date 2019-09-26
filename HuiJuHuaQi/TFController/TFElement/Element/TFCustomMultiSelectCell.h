//
//  TFCustomMultiSelectCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/21.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFCustomerRowsModel.h"

@protocol TFCustomMultiSelectCellDelegate<NSObject>

@optional
-(void)customMultiSelectCellDidOptionWithModel:(TFCustomerRowsModel *)model;

@end

@interface TFCustomMultiSelectCell : UITableViewCell

/** edit */
@property (nonatomic, assign) BOOL edit;

/** model */
@property (nonatomic, strong) TFCustomerRowsModel *model;

/** 必填控制 */
@property (nonatomic, copy) NSString *fieldControl;

/** 标题 */
@property (nonatomic, copy) NSString *title;

/** 初始化 */
+ (TFCustomMultiSelectCell *)CustomMultiSelectCellWithTableView:(UITableView *)tableView;

/** 刷新cell高度 */
+ (CGFloat)refreshCustomMultiSelectCellHeightWithModel:(TFCustomerRowsModel *)model;

/** delegate */
@property (nonatomic, weak) id <TFCustomMultiSelectCellDelegate>delegate;


@end
