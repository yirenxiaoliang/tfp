//
//  TFRuleCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/7.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFPCRuleListModel.h"
NS_ASSUME_NONNULL_BEGIN
@class TFRuleCell;
@protocol TFRuleCellDelegate <NSObject>

@optional
-(void)ruleCellDidClickedDelete:(TFRuleCell *)cell;
-(void)ruleCellDidClickedPeople:(TFRuleCell *)cell;
-(void)ruleCellDidClickedRule:(TFRuleCell *)cell;


@end

@interface TFRuleCell : HQBaseCell

@property (nonatomic, weak) id <TFRuleCellDelegate>delegate;
-(void)refreshRuleCellWithModel:(TFPCRuleListModel *)model;
+(instancetype)ruleCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
