//
//  TFOneLableCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/5/8.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
@class TFOneLableCell;
@protocol TFOneLableCellDelegate <NSObject>

@optional
- (void)addPCDateClicked:(TFOneLableCell *)cell;

@end

@interface TFOneLableCell : HQBaseCell
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIButton *enterBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *enterH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *enterW;


@property (nonatomic, weak) id <TFOneLableCellDelegate>delegate;

+ (instancetype)OneLableCellWithTableView:(UITableView *)tableView;

@end
