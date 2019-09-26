//
//  TFAttendanceMonthCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/14.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAttendanceMonthCell.h"

@interface TFAttendanceMonthCell ()
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UILabel *punchLabel;
@property (weak, nonatomic) IBOutlet UILabel *expectLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UIImageView *addressImage;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation TFAttendanceMonthCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.topLine.backgroundColor = CellSeparatorColor;
    self.bottomLine.backgroundColor = CellSeparatorColor;
    self.punchLabel.textColor = BlackTextColor;
    self.expectLabel.textColor = GrayTextColor;
    self.addressLabel.textColor = ExtraLightBlackTextColor;
    self.punchLabel.font = FONT(14);
    self.expectLabel.font = FONT(14);
    self.addressLabel.font = FONT(12);
    self.statusBtn.layer.cornerRadius = 4;
    self.statusBtn.layer.borderWidth = 1;
    
}

-(void)refreshAttendanceMonthCellWithModel:(TFPunchCardInfoModel *)model{
    
    if ([[model.punchcardType description] isEqualToString:@"1"]) {// 上班
        
        self.expectLabel.text = [NSString stringWithFormat:@"(上班时间  %@)",[HQHelper nsdateToTime:[model.expectPunchcardTime longLongValue] formatStr:@"HH:mm"]];
        
    }else{// 下班
        
        self.expectLabel.text = [NSString stringWithFormat:@"(下班时间  %@)",[HQHelper nsdateToTime:[model.expectPunchcardTime longLongValue] formatStr:@"HH:mm"]];
    }
    
    // 打卡真实时间
    if (model.realPunchcardTime) {
        self.punchLabel.text = [NSString stringWithFormat:@"打卡时间  %@",[HQHelper nsdateToTime:[model.realPunchcardTime longLongValue] formatStr:@"HH:mm"]];
    }else{
        self.punchLabel.text = @"";
    }
    /** 打卡状态（1迟到, 2早退, 3缺卡, 4旷工, 5外勤打卡, 6关联审批, 7正常, 8未到打卡时间） */
    if ([[model.punchcardState description] isEqualToString:@"0"]) {
        
        self.statusImage.image = IMG(@"未打卡");
        [self.statusBtn setTitle:@"未打卡" forState:UIControlStateNormal];
        [self.statusBtn setTitleColor:kUIColorFromRGB(0xB2B2B2) forState:UIControlStateNormal];
        self.statusBtn.layer.borderColor = kUIColorFromRGB(0xB2B2B2).CGColor;
    }else if ([[model.punchcardState description] isEqualToString:@"1"]) {
        
        self.statusImage.image = IMG(@"打卡正常");
        [self.statusBtn setTitle:@"正常" forState:UIControlStateNormal];
        [self.statusBtn setTitleColor:kUIColorFromRGB(0x1890FF) forState:UIControlStateNormal];
        self.statusBtn.layer.borderColor = kUIColorFromRGB(0x1890FF).CGColor;
    }else if ([[model.punchcardState description] isEqualToString:@"2"]) {
        
        self.statusImage.image = IMG(@"打卡迟到");
        [self.statusBtn setTitle:@"迟到" forState:UIControlStateNormal];
        [self.statusBtn setTitleColor:kUIColorFromRGB(0xF9A244) forState:UIControlStateNormal];
        self.statusBtn.layer.borderColor = kUIColorFromRGB(0xF9A244).CGColor;
    }else if ([[model.punchcardState description] isEqualToString:@"3"]) {
        
        self.statusImage.image = IMG(@"打卡早退");
        [self.statusBtn setTitle:@"早退" forState:UIControlStateNormal];
        [self.statusBtn setTitleColor:kUIColorFromRGB(0xFF5E00) forState:UIControlStateNormal];
        self.statusBtn.layer.borderColor = kUIColorFromRGB(0xFF5E00).CGColor;
    }else if ([[model.punchcardState description] isEqualToString:@"4"]) {
        
        self.statusImage.image = IMG(@"打卡旷工");
        [self.statusBtn setTitle:@"旷工" forState:UIControlStateNormal];
        [self.statusBtn setTitleColor:kUIColorFromRGB(0x4B4948) forState:UIControlStateNormal];
        self.statusBtn.layer.borderColor = kUIColorFromRGB(0x4B4948).CGColor;
    }else if ([[model.punchcardState description] isEqualToString:@"5"]) {
        
        self.statusImage.image = IMG(@"打卡缺卡");
        [self.statusBtn setTitle:@"缺卡" forState:UIControlStateNormal];
        [self.statusBtn setTitleColor:kUIColorFromRGB(0xF63F3F) forState:UIControlStateNormal];
        self.statusBtn.layer.borderColor = kUIColorFromRGB(0xF63F3F).CGColor;
    }else if ([[model.punchcardState description] isEqualToString:@"6"]) {//, 6外勤打卡, 7关联审批, 8未到打卡时间
        
    }else if ([[model.punchcardState description] isEqualToString:@"7"]) {
        self.statusImage.image = IMG(@"打卡正常");
        [self.statusBtn setTitle:@"外勤" forState:UIControlStateNormal];
        [self.statusBtn setTitleColor:kUIColorFromRGB(0xF63F3F) forState:UIControlStateNormal];
        self.statusBtn.layer.borderColor = kUIColorFromRGB(0xF63F3F).CGColor;
        
    }else if ([[model.punchcardState description] isEqualToString:@"8"]) {
        self.statusImage.image = IMG(@"未打卡");
        [self.statusBtn setTitle:@"未打卡" forState:UIControlStateNormal];
        [self.statusBtn setTitleColor:kUIColorFromRGB(0xB2B2B2) forState:UIControlStateNormal];
        self.statusBtn.layer.borderColor = kUIColorFromRGB(0xB2B2B2).CGColor;
    }
    
    
    self.addressLabel.text = model.isWayInfo;
    if ([model.isWay isEqualToString:@"0"]) {// 地址
        self.addressImage.image = IMG(@"打卡定位");
    }else{// wifi
        self.addressImage.image = IMG(@"打卡定位");
    }
    self.addressImage.hidden = IsStrEmpty(model.isWayInfo);
}
+(instancetype)attendanceMonthCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFAttendanceMonthCell" owner:self options:nil] lastObject];
}

+(instancetype)attendanceMonthCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFAttendanceMonthCell";
    TFAttendanceMonthCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [TFAttendanceMonthCell attendanceMonthCell];
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
