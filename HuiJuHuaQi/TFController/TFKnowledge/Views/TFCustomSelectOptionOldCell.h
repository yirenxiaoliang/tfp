//
//  TFCustomSelectOptionOldCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/4.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFCustomerRowsModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TFCustomSelectOptionOldCellDelegate<NSObject>
@optional
-(void)customOptionItemCellDidClickedOptions:(NSArray *)options isSingle:(BOOL)isSingle model:(TFCustomerRowsModel *)model level:(NSInteger)level;

@end

@interface TFCustomSelectOptionOldCell : UITableViewCell

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
@property (nonatomic, weak) id <TFCustomSelectOptionOldCellDelegate>delegate;

/** 创建cell */
+(instancetype)customSelectOptionCellWithTableView:(UITableView *)tableView;

/** 高度 */
+(CGFloat)refreshCustomSelectOptionCellHeightWithModel:(TFCustomerRowsModel *)model showEdit:(BOOL)showEdit;

@end

NS_ASSUME_NONNULL_END
