//
//  TFAddPCRuleCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/14.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@protocol TFAddPCRuleCellDelegate <NSObject>

@optional
- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)sender;

@end

@interface TFAddPCRuleCell : HQBaseCell

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
+ (instancetype)addPCRuleCellWithTableView:(UITableView *)tableView;

//配置数据
- (void)configAddPCRuleCellWithTableView:(NSInteger)type;

@property (nonatomic, weak) id <TFAddPCRuleCellDelegate>delegate;
@end
