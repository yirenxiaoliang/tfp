//
//  TFWorkMemberCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/14.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@protocol TFWorkMemberCellDelegate <NSObject>

@optional
- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)sender;

@end

@interface TFWorkMemberCell : HQBaseCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
+ (instancetype)workMemberCellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id <TFWorkMemberCellDelegate>delegate;
@end
