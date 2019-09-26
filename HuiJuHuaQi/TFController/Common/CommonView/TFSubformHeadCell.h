//
//  TFSubformHeadCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/4.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@class TFSubformHeadCell;

@protocol TFSubformHeadCellDelegate <NSObject>

@optional
- (void)subformHeadCell:(TFSubformHeadCell *)subformHeadCell didClickedAddButton:(UIButton *)button;

@end

@interface TFSubformHeadCell : HQBaseCell

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *addButton;
/** delegate */
@property (nonatomic, weak) id<TFSubformHeadCellDelegate> delegate;

/** fieldControl */
@property (nonatomic, copy) NSString *fieldControl;

+ (instancetype)subformHeadCellWithTableView:(UITableView *)tableView;

@end
