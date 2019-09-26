//
//  TFCustomOptionItemCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/8/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFCustomerRowsModel.h"

@protocol TFCustomOptionItemCellDelegate <NSObject>

@optional

-(void)customOptionItemCellDidClickedRightBtn:(UIButton *)rightBtn;

@end

@interface TFCustomOptionItemCell : UITableViewCell

/** edit */
@property (nonatomic, assign) BOOL edit;

/** 右边图片 */
@property (nonatomic, weak) UIButton *rightBtn;

/** 展示样式 YES：编辑样式  NO: 详情样式 */
@property (nonatomic, assign) BOOL showEdit;
/** delegate */
@property (nonatomic, weak) id <TFCustomOptionItemCellDelegate>delegate;

/** 创建cell */
+(instancetype)customOptionItemCellWithTableView:(UITableView *)tableView;

/** 刷新 */
-(void)refreshCustomOptionItemCellWithModel:(TFCustomerRowsModel *)model edit:(BOOL)edit;
/** 刷新 */
-(void)refreshCustomOptionItemCellWithOptions:(NSArray *)options;

/** 高度 */
+(CGFloat)refreshCustomOptionItemCellHeightWithOptions:(NSArray *)options;

/** 高度 */
+(CGFloat)refreshCustomOptionItemCellHeightWithModel:(TFCustomerRowsModel *)modell edit:(BOOL)edit;

@end
