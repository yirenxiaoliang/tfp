//
//  TFTwoLableCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/8.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTwoLableCell.h"

@interface TFTwoLableCell()

@end


@implementation TFTwoLableCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
/** index 0:日统计，1：月统计，2：我的
 type 0：打卡人数，1：迟到，2：早退，3：缺卡,4:旷工，5：外勤打卡，6：关联审批
 */
-(void)refreshCellWithIndex:(NSInteger)index type:(NSInteger)type model:(TFDimensionModel *)model{
    
    if (index == 0) {
        
        if (type == 1) {// 迟到
            long long expect = [model.expect_punchcard_time longLongValue];
            long long real = [model.real_punchcard_time longLongValue];
            NSString *expectStr = [HQHelper nsdateToTime:expect formatStr:@"HH:mm"];
            NSString *realStr = [HQHelper nsdateToTime:real formatStr:@"HH:mm"];
            long long delta = real - expect;
            NSInteger num = delta/(1000 * 60);
            self.twoLab.text = [NSString stringWithFormat:@"上班时间：%@    打卡时间：%@    迟到%ld分钟",expectStr,realStr,num];
            self.oneLab.text = [HQHelper nsdateToTime:expect formatStr:@"yyyy年MM月dd日(EEEE)"];
        }else if (type == 2){// 早退
            
            long long expect = [model.expect_punchcard_time longLongValue];
            long long real = [model.real_punchcard_time longLongValue];
            NSString *expectStr = [HQHelper nsdateToTime:expect formatStr:@"HH:mm"];
            NSString *realStr = [HQHelper nsdateToTime:real formatStr:@"HH:mm"];
            long long delta = expect - real;
            NSInteger num = delta/(1000 * 60);
            self.twoLab.text = [NSString stringWithFormat:@"下班时间：%@    打卡时间：%@    早退%ld分钟",expectStr,realStr,num];
            self.oneLab.text = [HQHelper nsdateToTime:expect formatStr:@"yyyy年MM月dd日(EEEE)"];
        }else if (type == 3){// 缺卡
            NSString *str = @"";
            if ([model.punchcard_type isEqualToString:@"1"]) {// 上班
                str = @"上班";
            }else{
                str = @"下班";
            }
            
            long long expect = [model.expect_punchcard_time longLongValue];
            NSString *expectStr = [HQHelper nsdateToTime:expect formatStr:@"HH:mm"];
            self.twoLab.text = [NSString stringWithFormat:@"%@时间：%@ ",str,expectStr];
            self.oneLab.text = [HQHelper nsdateToTime:expect formatStr:@"yyyy年MM月dd日(EEEE)"];
        }else if (type == 4){//  旷工
         
            long long expect = [model.expect_punchcard_time longLongValue];
            
            self.oneLab.text = [HQHelper nsdateToTime:expect formatStr:@"yyyy年MM月dd日(EEEE)"];
        }else if (type == 5){// 外勤打卡
            
            NSString *str = @"";
            if ([model.punchcard_type isEqualToString:@"1"]) {// 上班
                str = @"上班";
            }else{
                str = @"下班";
            }
            long long expect = [model.real_punchcard_time longLongValue];
            NSString *expectStr = [HQHelper nsdateToTime:expect formatStr:@"HH:mm"];
            self.twoLab.text = [NSString stringWithFormat:@"%@时间：%@  %@",str,expectStr,model.punchcard_address];
            self.oneLab.text = [HQHelper nsdateToTime:expect formatStr:@"yyyy年MM月dd日(EEEE)"];
        }else if (type == 6){// 关联审批单
            
            long long expect = [model.expect_punchcard_time longLongValue];
            self.twoLab.text = [NSString stringWithFormat:@"开始时间：%@      结束时间：%@",[HQHelper nsdateToTime:[model.start_time?:model.startTime longLongValue] formatStr:@"yyyy年MM月dd日(EEEE)HH:mm"],[HQHelper nsdateToTime:[model.end_time?:model.endTime longLongValue] formatStr:@"yyyy年MM月dd日(EEEE)HH:mm"]];
            self.oneLab.text = [HQHelper nsdateToTime:expect formatStr:@"yyyy年MM月dd日(EEEE)"];
        }
        
    }
    else if (index == 1){
        
        if (type == 1) {// 迟到
            long long expect = [model.attendanceDate longLongValue];
            long long real = [model.punchcardTime longLongValue];
            NSString *realStr = [HQHelper nsdateToTime:real formatStr:@"HH:mm"];
            self.twoLab.text = [NSString stringWithFormat:@"打卡时间：%@    迟到%ld分钟",realStr,[model.duration integerValue]];
            self.oneLab.text = [HQHelper nsdateToTime:expect formatStr:@"yyyy年MM月dd日(EEEE) HH:mm"];
        }else if (type == 2) {// 早退
                long long expect = [model.attendanceDate longLongValue];
                long long real = [model.punchcardTime longLongValue];
                NSString *realStr = [HQHelper nsdateToTime:real formatStr:@"HH:mm"];
                self.twoLab.text = [NSString stringWithFormat:@"打卡时间：%@    早退%ld分钟",realStr,[model.duration integerValue]];
                self.oneLab.text = [HQHelper nsdateToTime:expect formatStr:@"yyyy年MM月dd日(EEEE) HH:mm"];
        }else if (type == 3){// 缺卡
            
            long long expect = [model.attendanceDate longLongValue];
            self.oneLab.text = [HQHelper nsdateToTime:expect formatStr:@"yyyy年MM月dd日(EEEE) HH:mm"];
        }else if (type == 4){// 旷工
            
            long long expect = [model.attendanceDate longLongValue];
            self.oneLab.text = [HQHelper nsdateToTime:expect formatStr:@"yyyy年MM月dd日(EEEE)"];
        }else if (type == 5){// 外勤打卡
            
            NSString *str = @"";
            if ([model.punchcardType isEqualToString:@"1"]) {// 上班
                str = @"上班";
            }else{
                str = @"下班";
            }
            long long expect = [model.punchcardTime longLongValue];
            NSString *expectStr = [HQHelper nsdateToTime:expect formatStr:@"HH:mm"];
            self.twoLab.text = [NSString stringWithFormat:@"%@时间：%@  %@",str,expectStr,model.punchcardAddress];
            self.oneLab.text = [HQHelper nsdateToTime:expect formatStr:@"yyyy年MM月dd日(EEEE)"];
            
            if ([model.mark isEqualToString:@"1"]) {
                self.oneLab.hidden = NO;
            }else{
                self.oneLab.hidden = YES;
                self.oneLab.text = @"";
            }
            
        }else if (type == 6){// 关联审批单
            
            long long expect = [model.expect_punchcard_time longLongValue];
            self.twoLab.text = [NSString stringWithFormat:@"开始时间：%@      结束时间：%@",[HQHelper nsdateToTime:[model.start_time?:model.startTime longLongValue] formatStr:@"yyyy年MM月dd日(EEEE)HH:mm"],[HQHelper nsdateToTime:[model.end_time?:model.endTime longLongValue] formatStr:@"yyyy年MM月dd日(EEEE)HH:mm"]];
            self.oneLab.text = [HQHelper nsdateToTime:expect formatStr:@"yyyy年MM月dd日(EEEE)"];
        }
        
    }else{
        if (type == 7) {// 正常
            long long expect = [model.attendanceDate longLongValue];
//            long long real = [model.punchcardTime longLongValue];
//            NSString *realStr = [HQHelper nsdateToTime:real formatStr:@"HH:mm"];
//            self.twoLab.text = [NSString stringWithFormat:@"打卡时间：%@",realStr];
            self.oneLab.text = [HQHelper nsdateToTime:expect formatStr:@"yyyy年MM月dd日(EEEE)"];
        }else if (type == 1) {// 迟到
            long long expect = [model.attendanceDate longLongValue];
            long long real = [model.punchcardTime longLongValue];
            NSString *realStr = [HQHelper nsdateToTime:real formatStr:@"HH:mm"];
            self.twoLab.text = [NSString stringWithFormat:@"打卡时间：%@    迟到%ld分钟",realStr,[model.duration integerValue]];
            self.oneLab.text = [HQHelper nsdateToTime:expect formatStr:@"yyyy年MM月dd日(EEEE) HH:mm"];
        }else if (type == 2) {// 早退
            long long expect = [model.attendanceDate longLongValue];
            long long real = [model.punchcardTime longLongValue];
            NSString *realStr = [HQHelper nsdateToTime:real formatStr:@"HH:mm"];
            self.twoLab.text = [NSString stringWithFormat:@"打卡时间：%@    早退%ld分钟",realStr,[model.duration integerValue]];
            self.oneLab.text = [HQHelper nsdateToTime:expect formatStr:@"yyyy年MM月dd日(EEEE) HH:mm"];
        }else if (type == 3){// 缺卡
            
            long long expect = [model.attendanceDate longLongValue];
            self.oneLab.text = [HQHelper nsdateToTime:expect formatStr:@"yyyy年MM月dd日(EEEE) HH:mm"];
        }else if (type == 4){// 旷工
            
            long long expect = [model.attendanceDate longLongValue];
            self.oneLab.text = [HQHelper nsdateToTime:expect formatStr:@"yyyy年MM月dd日(EEEE)"];
        }else if (type == 5){// 外勤打卡
            
            NSString *str = @"";
            if ([model.punchcardType isEqualToString:@"1"]) {// 上班
                str = @"上班";
            }else{
                str = @"下班";
            }
            long long expect = [model.punchcardTime longLongValue];
            NSString *expectStr = [HQHelper nsdateToTime:expect formatStr:@"HH:mm"];
            self.twoLab.text = [NSString stringWithFormat:@"%@时间：%@  %@",str,expectStr,model.punchcardAddress];
            self.oneLab.text = [HQHelper nsdateToTime:expect formatStr:@"yyyy年MM月dd日(EEEE)"];
        }else if (type == 6){// 关联审批单
            
            long long expect = [model.expect_punchcard_time longLongValue];
            self.twoLab.text = [NSString stringWithFormat:@"开始时间：%@      结束时间：%@",[HQHelper nsdateToTime:[model.start_time?:model.startTime longLongValue] formatStr:@"HH:mm"],[HQHelper nsdateToTime:[model.end_time?:model.endTime longLongValue] formatStr:@"HH:mm"]];
            self.oneLab.text = [HQHelper nsdateToTime:expect formatStr:@"yyyy年MM月dd日(EEEE)"];
        }
    }
}


+ (instancetype)TFTwoLableCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFTwoLableCell" owner:self options:nil] lastObject];
}

+ (instancetype)TwoLableCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"TFTwoLableCell";
    TFTwoLableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self TFTwoLableCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
