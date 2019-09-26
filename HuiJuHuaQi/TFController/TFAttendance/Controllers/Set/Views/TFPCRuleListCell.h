//
//  TFPCRuleListCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/8.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFPCRuleListModel.h"

@protocol TFPCRuleListCellDelegate <NSObject>

@optional
- (void)deleteAction:(NSInteger)index;

- (void)editAction:(NSInteger)index;
@end

@interface TFPCRuleListCell : HQBaseCell

@property (nonatomic, assign) NSInteger index;
+ (instancetype)PCRuleListCellWithTableView:(UITableView *)tableView;

- (void)refreshPCRuleListCellWithModel:(TFPCRuleListModel *)model;

@property (nonatomic, weak) id <TFPCRuleListCellDelegate>delegate;

@end
