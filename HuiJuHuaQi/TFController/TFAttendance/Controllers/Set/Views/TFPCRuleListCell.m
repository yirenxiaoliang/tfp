//
//  TFPCRuleListCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/8.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFPCRuleListCell.h"

@interface TFPCRuleListCell ()

@property (weak, nonatomic) IBOutlet UIButton *logoBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *memberLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@end

@implementation TFPCRuleListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.logoBtn.layer.cornerRadius = self.logoBtn.width/2.0;
    self.logoBtn.layer.masksToBounds = YES;
    
    self.deleteBtn.layer.cornerRadius = 4.0;
    self.deleteBtn.layer.masksToBounds = YES;
    self.deleteBtn.layer.borderWidth = 1.0;
    self.deleteBtn.layer.borderColor = [GreenColor CGColor];
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    self.deleteBtn.titleLabel.font = FONT(12);
    [self.deleteBtn addTarget:self action:@selector(deleteClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.editBtn.layer.cornerRadius = 4.0;
    self.editBtn.layer.masksToBounds = YES;
    self.editBtn.layer.borderWidth = 1.0;
    self.editBtn.layer.borderColor = [GreenColor CGColor];
    [self.editBtn setTitle:@"修改" forState:UIControlStateNormal];
    [self.editBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    self.editBtn.titleLabel.font = FONT(12);
    [self.editBtn addTarget:self action:@selector(editClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)deleteClicked:(UIButton *)button {
    
    if ([self.delegate respondsToSelector:@selector(deleteAction:)]) {
        
        [self.delegate deleteAction:self.index];
    }
    
}

- (void)editClicked:(UIButton *)button {
    
    if ([self.delegate respondsToSelector:@selector(editAction:)]) {
        
        [self.delegate editAction:self.index];
    }
    
}

- (void)refreshPCRuleListCellWithModel:(TFPCRuleListModel *)model {
    
    [self.logoBtn setImage:IMG(@"组织架构") forState:UIControlStateNormal];
    
    self.nameLab.text = model.name;
//    self.memberLab.text = [NSString stringWithFormat:@"考勤人数：%@",model.attendance_number];
//    if ([model.attendance_type isEqualToString:@"0"]) {
//        
//        self.typeLab.text = @"考勤类型：固定班制";
//    }
//    else if ([model.attendance_type isEqualToString:@"1"]) {
//        
//        self.typeLab.text = @"考勤类型：排班制";
//    }
//    else if ([model.attendance_type isEqualToString:@"2"]) {
//        
//        self.typeLab.text = @"考勤类型：自由工时";
//    }
    
    self.timeLab.text = [NSString stringWithFormat:@"考勤时间：%@",model.attendance_time];
    
}

+ (instancetype)TFPCRuleListCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFPCRuleListCell" owner:self options:nil] lastObject];
}

+ (instancetype)PCRuleListCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"TFPCRuleListCell";
    TFPCRuleListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self TFPCRuleListCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
