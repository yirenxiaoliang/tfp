//
//  TFStatisticsTypeCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/26.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFStatisticsTypeCell.h"

@interface TFStatisticsTypeCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTopw;

@end

@implementation TFStatisticsTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.textColor = BlackTextColor;
    self.nameLabel.font = FONT(14);
    self.timeLabel.textColor = ExtraLightBlackTextColor;
    self.timeLabel.font = FONT(12);
    self.addressLabel.textColor = ExtraLightBlackTextColor;
    self.addressLabel.font = FONT(12);
    self.nameLabel.text = @"";
    self.timeLabel.text = @"";
    self.addressLabel.text = @"";
}

/** 刷新数据
 *  model : 数据
 *  index ： 0,日统计；1,月统计；2,我的统计
 *  type ： 统计维度类型,0：打卡人数，1：迟到，2：早退，3：缺卡,4:旷工，5：外勤打卡，6：关联审批
 *  row :  行数
 */
-(void)refreshStatisticsTypeCellWithModel:(TFDimensionModel *)model index:(NSInteger)index type:(NSInteger)type row:(NSInteger)row{
    
    if (index == 0) {// 日
        
        if (type == 1) {// 迟到
            long long expect = [model.expect_punchcard_time longLongValue];
            self.nameLabel.text = [HQHelper nsdateToTime:expect formatStr:@"yyyy年MM月dd日(EEEE)"];
            
            long long real = [model.real_punchcard_time longLongValue];
            NSString *expectStr = [HQHelper nsdateToTime:expect formatStr:@"HH:mm"];
            NSString *realStr = [HQHelper nsdateToTime:real formatStr:@"HH:mm"];
            long long delta = real - expect;
            NSInteger num = delta/(1000 * 60);
            self.timeLabel.text = [NSString stringWithFormat:@"上班时间：%@   打卡时间：%@   迟到%ld分钟",expectStr,realStr,num];
            if (model.late_time_number && ![model.late_time_number isEqualToNumber:@0]) {
                self.timeLabel.text = [NSString stringWithFormat:@"上班时间：%@   打卡时间：%@   迟到%ld分钟",expectStr,realStr,[model.late_time_number integerValue]];
            }
            
            self.headW.constant = 54;
            self.timeW.constant = SCREEN_WIDTH - 54 - 30;
            
            if (row == 0) {
                self.nameLabel.hidden = NO;
            }else{
                self.nameLabel.hidden = YES;
                self.nameLabel.text = @"";
            }
            
        }else if (type == 2){// 早退
            
            long long expect = [model.expect_punchcard_time longLongValue];
            self.nameLabel.text = [HQHelper nsdateToTime:expect formatStr:@"yyyy年MM月dd日(EEEE)"];
            
            long long real = [model.real_punchcard_time longLongValue];
            NSString *expectStr = [HQHelper nsdateToTime:expect formatStr:@"HH:mm"];
            NSString *realStr = [HQHelper nsdateToTime:real formatStr:@"HH:mm"];
            long long delta =  expect - real;
            NSInteger num = delta/(1000 * 60);
            self.timeLabel.text = [NSString stringWithFormat:@"下班时间：%@   打卡时间：%@   早退%ld分钟",expectStr,realStr,num];
            if (model.leave_early_time_number && ![model.leave_early_time_number isEqualToNumber:@0]) {
                self.timeLabel.text = [NSString stringWithFormat:@"下班时间：%@   打卡时间：%@   早退%ld分钟",expectStr,realStr,[model.leave_early_time_number integerValue]];
            }
            
            self.headW.constant = 54;
            self.timeW.constant = SCREEN_WIDTH - 54 - 30;
            
            if (row == 0) {
                self.nameLabel.hidden = NO;
            }else{
                self.nameLabel.hidden = YES;
                self.nameLabel.text = @"";
            }
        }else if (type == 3){// 缺卡
            
            long long expect = [model.expect_punchcard_time longLongValue];
            self.nameLabel.text = [HQHelper nsdateToTime:expect formatStr:@"yyyy年MM月dd日(EEEE)"];
            
            NSString *str = @"";
            if ([model.punchcard_type isEqualToString:@"1"]) {// 上班
                str = @"上班时间：";
            }else if ([model.punchcard_type isEqualToString:@"2"]) {// 下班
                str = @"下班时间：";
            }
            long long real = [model.expect_punchcard_time longLongValue];
            NSString *realStr = [HQHelper nsdateToTime:real formatStr:@"HH:mm"];
            
            self.timeLabel.text = [NSString stringWithFormat:@"%@%@",str,realStr];
            
            self.headW.constant = 54;
            self.timeW.constant = SCREEN_WIDTH - 54 - 30;
            self.nameTopw.constant = 0;
            
        }else if (type == 4){// 旷工
            
        }else if (type == 5){// 外勤
            
            long long expect = [model.expect_punchcard_time longLongValue];
            self.nameLabel.text = [HQHelper nsdateToTime:expect formatStr:@"yyyy年MM月dd日(EEEE)"];
            
            NSString *str = @"";
            if ([model.punchcard_type isEqualToString:@"1"]) {// 上班
                str = @"上班时间：";
            }else if ([model.punchcard_type isEqualToString:@"2"]) {// 下班
                str = @"下班时间：";
            }
            long long real = [model.real_punchcard_time longLongValue];
            NSString *realStr = [HQHelper nsdateToTime:real formatStr:@"HH:mm"];
            
            self.timeLabel.text = [NSString stringWithFormat:@"%@%@",str,realStr];
            
            self.addressLabel.text = model.punchcard_address;
            self.addressLabel.numberOfLines = 0;
            self.headW.constant = 54;
            self.timeW.constant = 100;
            
            if (row == 0) {
                self.nameLabel.hidden = NO;
                self.nameTopw.constant = 0;
            }else{
                self.nameLabel.hidden = YES;
                self.nameLabel.text = @"";
                self.nameTopw.constant = -10;
            }
            
        }else if (type == 6){// 关联审批
            
            self.nameLabel.text = [NSString stringWithFormat:@"%@",[HQHelper nsdateToTime:[model.start_time longLongValue] formatStr:@"yyyy年MM月dd日(EEEE)"]];
            
            self.timeLabel.text= [NSString stringWithFormat:@"开始时间：%@    结束时间：%@",[HQHelper nsdateToTime:[model.start_time longLongValue] formatStr:@"HH:mm"],[HQHelper nsdateToTime:[model.end_time longLongValue] formatStr:@"HH:mm"]];
            
            self.headW.constant = 54;
            self.timeW.constant = SCREEN_WIDTH - 54 - 30;
            self.nameTopw.constant = 0;
            
        }
        
    }else if (index == 1){// 月
        
    }else{// 我
        
    }
    
}




+(instancetype)statisticsTypeCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFStatisticsTypeCell" owner:self options:nil] lastObject];
}

+(instancetype)statisticsTypeCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFStatisticsTypeCell";
    TFStatisticsTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [TFStatisticsTypeCell statisticsTypeCell];
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
