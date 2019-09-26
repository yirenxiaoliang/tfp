//
//  TFAddPCRuleCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/14.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAddPCRuleCell.h"

@interface TFAddPCRuleCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *tipLab;

@end

@implementation TFAddPCRuleCell


- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    //设置选项卡被选中的颜色
    [self.segment setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateSelected];
    //设置选中的选项卡
    self.segment.selectedSegmentIndex = 0;
    [self.segment addTarget:self action:@selector(SegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
}


//配置数据
- (void)configAddPCRuleCellWithTableView:(NSInteger)type {
    
    if (type == 0) {
        
        self.tipLab.text = @"每天考勤时间一样，适用于:IT、金融、文化1传媒、政府、事业单位、教育培训等行业";
    }
    else if (type == 1) {
        
        self.tipLab.text = @"自定义设置考勤时间，适用于：餐饮、制造、物流贸易、客户服务、医院等行业";
    }
    else if (type == 2) {
        
        self.tipLab.text = @"不设置班次，随时打卡，用于:班次没有规律，装修，家政，物流等计算工作时长的行业";
    }
    
}

- (void)SegmentedControlAction:(UISegmentedControl *)sender {
    
    if ([self.delegate respondsToSelector:@selector(indexDidChangeForSegmentedControl:)]) {
        
        [self.delegate indexDidChangeForSegmentedControl:sender];
    }
    
}

+ (instancetype)TFAddPCRuleCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFAddPCRuleCell" owner:self options:nil] lastObject];
}

+ (instancetype)addPCRuleCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"TFAddPCRuleCell";
    TFAddPCRuleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self TFAddPCRuleCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
