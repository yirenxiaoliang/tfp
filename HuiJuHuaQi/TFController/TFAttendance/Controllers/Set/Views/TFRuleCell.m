//
//  TFRuleCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/7.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFRuleCell.h"

@interface TFRuleCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *peopleBtn;
@property (weak, nonatomic) IBOutlet UIButton *ruleBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end

@implementation TFRuleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.textColor = LightBlackTextColor;
    self.numLabel.textColor = ExtraLightBlackTextColor;
    self.typeLabel.textColor = ExtraLightBlackTextColor;
    self.timeLabel.textColor = ExtraLightBlackTextColor;
    self.nameLabel.font = FONT(16);
    self.numLabel.font = FONT(14);
    self.typeLabel.font = FONT(14);
    self.timeLabel.font = FONT(14);
    self.headImage.layer.cornerRadius = 22;
    self.headImage.layer.masksToBounds = YES;
    self.peopleBtn.layer.masksToBounds = YES;
    self.peopleBtn.layer.cornerRadius = 4;
    self.ruleBtn.layer.cornerRadius = 4;
    self.ruleBtn.layer.masksToBounds = YES;
    self.peopleBtn.backgroundColor = GreenColor;
    self.ruleBtn.backgroundColor = GreenColor;
    self.bottomLine.hidden = NO;
    [[self.deleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if ([self.delegate respondsToSelector:@selector(ruleCellDidClickedDelete:)]) {
            [self.delegate ruleCellDidClickedDelete:self];
        }
    }];
    [[self.peopleBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        if ([self.delegate respondsToSelector:@selector(ruleCellDidClickedPeople:)]) {
            [self.delegate ruleCellDidClickedPeople:self];
        }
    }];
    [[self.ruleBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        if ([self.delegate respondsToSelector:@selector(ruleCellDidClickedRule:)]) {
            [self.delegate ruleCellDidClickedRule:self];
        }
    }];
    
}

-(void)refreshRuleCellWithModel:(TFPCRuleListModel *)model{
    
    self.nameLabel.text = model.name;
    self.numLabel.text = [NSString stringWithFormat:@"考勤人数：%@人",model.memeber_number];
    NSString *str = @"";
    if ([model.attendance_type integerValue] == 0) {
        str = @"固定班次";
    }else if ([model.attendance_type integerValue] == 1){
        str = @"排班班次";
    }else{
        str = @"自由班次";
    }
    NSString *classStr = @"";
    for (TFAtdClassModel *cls in model.selected_class) {
        classStr = [classStr stringByAppendingString:[NSString stringWithFormat:@"%@:%@,",cls.name,cls.classDesc]];
    }
    if (classStr.length) {
        classStr = [classStr substringToIndex:classStr.length-1];
    }
    self.typeLabel.text = [NSString stringWithFormat:@"考勤类型：%@",str];
    self.timeLabel.text = [NSString stringWithFormat:@"考勤时间：%@",classStr];

}

+(instancetype)ruleCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFRuleCell" owner:self options:nil] lastObject];
}

+(instancetype)ruleCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFRuleCell";
    TFRuleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [TFRuleCell ruleCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.masksToBounds = YES;
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
