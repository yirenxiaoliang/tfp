//
//  TFWorkMemberCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/14.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFWorkMemberCell.h"

@interface TFWorkMemberCell ()

@property (weak, nonatomic) IBOutlet UILabel *requireLab;

@end

@implementation TFWorkMemberCell


- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.titleLab.font = FONT(14);
    self.titleLab.textColor = CellTitleNameColor;
    
    //设置选项卡被选中的颜色
    [self.segment setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateSelected];
    //设置选中的选项卡
    self.segment.selectedSegmentIndex = 0;
    [self.segment addTarget:self action:@selector(SegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
}


//配置数据
- (void)configCRMDetailCellWithTableView:(NSArray *)model {
    
    
}

- (void)SegmentedControlAction:(UISegmentedControl *)sender {
    
    if ([self.delegate respondsToSelector:@selector(indexDidChangeForSegmentedControl:)]) {
        
        [self.delegate indexDidChangeForSegmentedControl:sender];
    }
    
}

+ (instancetype)TFWorkMemberCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFWorkMemberCell" owner:self options:nil] lastObject];
}

+ (instancetype)workMemberCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"TFWorkMemberCell";
    TFWorkMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self TFWorkMemberCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
