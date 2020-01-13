//
//  TFPunchCardCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/11.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFPunchCardCell.h"

@interface TFPunchCardCell ()

@property (nonatomic, strong) TFPutchRecordModel *model;
/** 外勤卡 */
@property (weak, nonatomic) IBOutlet UIButton *outBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *outW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *outTrailW;
@property (weak, nonatomic) IBOutlet UILabel *addCard;

@end

@implementation TFPunchCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.outBtn.layer.borderWidth = 0.5;
    self.outBtn.layer.cornerRadius = 4.0;
    self.outBtn.layer.masksToBounds = YES;
    self.outBtn.titleLabel.font = FONT(10);
    self.outBtn.layer.borderColor = RGBColor(109, 216, 178).CGColor;
    [self.outBtn setTitleColor:RGBColor(109, 216, 178) forState:UIControlStateNormal];
    
    self.pcStatusBtn.layer.borderWidth = 0.5;
    self.pcStatusBtn.layer.cornerRadius = 4.0;
    self.pcStatusBtn.layer.masksToBounds = YES;
    self.pcStatusBtn.titleLabel.font = FONT(10);
    
    self.updateLab.textColor = GreenColor;
    self.line.backgroundColor = CellSeparatorColor;
    self.updateLab.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeDidClicked)];
    [self.updateLab addGestureRecognizer:tap];
    
    
    self.addCard.textColor = GreenColor;
    self.addCard.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addDidClicked)];
    [self.addCard addGestureRecognizer:tap1];
}

-(void)changeDidClicked{
    if ([self.delegate respondsToSelector:@selector(punchCardCellDidChange:)]) {
        [self.delegate punchCardCellDidChange:self.model];
    }
}
-(void)addDidClicked{
    if ([self.delegate respondsToSelector:@selector(addCardCellDidChange:)]) {
        [self.delegate addCardCellDidChange:self.model];
    }
}

//配置数据
- (void)configPunchCardCellWithModel:(TFPutchRecordModel *)model {
    
    self.model = model;
    if ([model.punchcard_type isEqualToString:@"1"]) {// 上班
        
        self.timeLab.text = [NSString stringWithFormat:@"上班时间  %@",model.expect_punchcard_time];
        
    }else{// 下班
        
        self.timeLab.text = [NSString stringWithFormat:@"下班时间  %@",model.expect_punchcard_time];
    }
    
    if ([model.is_outworker isEqualToString:@"0"]) {// 外勤打卡
        self.outBtn.hidden = NO;
        self.outW.constant = 34;
        self.outTrailW.constant = 8;
        [self.outBtn setTitle:@"外勤" forState:UIControlStateNormal];
        self.addCard.text = @"查看备注";
        //加下划线
        self.addCard.attributedText = [HQHelper stringAttributeWithUnderLine:self.addCard.text];
        self.addCard.hidden = NO;
        
    }else{
        self.outBtn.hidden = YES;
        self.outW.constant = 0;
        self.outTrailW.constant = 0;
        
        self.addCard.text = @"";
        self.addCard.hidden = YES;
    }
    
    // 打卡真实时间
    if (!IsStrEmpty(model.real_punchcard_time)) {
        self.pcTimeLab.text = [NSString stringWithFormat:@"打卡时间  %@",[HQHelper nsdateToTime:[model.real_punchcard_time longLongValue] formatStr:@"HH:mm"]];
    }else{
        self.pcTimeLab.text = @"";
    }
    // 真实打卡
    if ([model.finish isEqualToString:@"1"]) {
        // 打卡地址
        if (!IsStrEmpty(model.punchcard_address)) {
            self.pcTypeLab.text = model.punchcard_address;
            if (IsStrEmpty(model.is_way) || [model.is_way isEqualToString:@"0"]) {// 地址
                self.pcTypeImgV.image = IMG(@"打卡定位");
            }else{// Wifi
                self.pcTypeImgV.image = IMG(@"Wifi");
            }
        }else{
            self.pcTypeLab.text = @"";
            self.pcTypeImgV.image = nil;
        }
    }else{
        self.pcTypeLab.text = @"";
        self.pcTypeImgV.image = nil;
    }
    
    // 打卡状态   0:未打卡,1:正常,2:迟到,3:早退,4:旷工,5:缺卡，7：请假，8：出差，9：外出 10:迟到旷工 11：早退旷工
    if ([model.punchcard_status isEqualToString:@"0"]) {
        
        self.statusImgV.image = IMG(@"未打卡");
        [self.pcStatusBtn setTitle:@"未打卡" forState:UIControlStateNormal];
        [self.pcStatusBtn setTitleColor:kUIColorFromRGB(0xB2B2B2) forState:UIControlStateNormal];
        self.pcStatusBtn.layer.borderColor = kUIColorFromRGB(0xB2B2B2).CGColor;
    }else if ([model.punchcard_status isEqualToString:@"1"]) {
        
        self.statusImgV.image = IMG(@"打卡正常");
        [self.pcStatusBtn setTitle:@"正常" forState:UIControlStateNormal];
        [self.pcStatusBtn setTitleColor:kUIColorFromRGB(0x1890FF) forState:UIControlStateNormal];
        self.pcStatusBtn.layer.borderColor = kUIColorFromRGB(0x1890FF).CGColor;
    }else if ([model.punchcard_status isEqualToString:@"2"]) {
        
        self.statusImgV.image = IMG(@"打卡迟到");
        [self.pcStatusBtn setTitle:@"迟到" forState:UIControlStateNormal];
        [self.pcStatusBtn setTitleColor:kUIColorFromRGB(0xF9A244) forState:UIControlStateNormal];
        self.pcStatusBtn.layer.borderColor = kUIColorFromRGB(0xF9A244).CGColor;
    }else if ([model.punchcard_status isEqualToString:@"3"]) {
        
        self.statusImgV.image = IMG(@"打卡早退");
        [self.pcStatusBtn setTitle:@"早退" forState:UIControlStateNormal];
        [self.pcStatusBtn setTitleColor:kUIColorFromRGB(0xFF5E00) forState:UIControlStateNormal];
        self.pcStatusBtn.layer.borderColor = kUIColorFromRGB(0xFF5E00).CGColor;
    }else if ([model.punchcard_status isEqualToString:@"4"]) {
        
        self.statusImgV.image = IMG(@"打卡旷工");
        [self.pcStatusBtn setTitle:@"旷工" forState:UIControlStateNormal];
        [self.pcStatusBtn setTitleColor:kUIColorFromRGB(0x4B4948) forState:UIControlStateNormal];
        self.pcStatusBtn.layer.borderColor = kUIColorFromRGB(0x4B4948).CGColor;
    }else if ([model.punchcard_status isEqualToString:@"5"]) {
        
        self.statusImgV.image = IMG(@"打卡缺卡");
        [self.pcStatusBtn setTitle:@"缺卡" forState:UIControlStateNormal];
        [self.pcStatusBtn setTitleColor:kUIColorFromRGB(0xF63F3F) forState:UIControlStateNormal];
        self.pcStatusBtn.layer.borderColor = kUIColorFromRGB(0xF63F3F).CGColor;
    }else if ([model.punchcard_status isEqualToString:@"7"]) {
        
        self.statusImgV.image = IMG(@"打卡缺卡");
        [self.pcStatusBtn setTitle:@"请假" forState:UIControlStateNormal];
        [self.pcStatusBtn setTitleColor:kUIColorFromRGB(0xF63F3F) forState:UIControlStateNormal];
        self.pcStatusBtn.layer.borderColor = kUIColorFromRGB(0xF63F3F).CGColor;
    }else if ([model.punchcard_status isEqualToString:@"8"]) {
        
        self.statusImgV.image = IMG(@"打卡缺卡");
        [self.pcStatusBtn setTitle:@"出差" forState:UIControlStateNormal];
        [self.pcStatusBtn setTitleColor:kUIColorFromRGB(0xF63F3F) forState:UIControlStateNormal];
        self.pcStatusBtn.layer.borderColor = kUIColorFromRGB(0xF63F3F).CGColor;
    }else if ([model.punchcard_status isEqualToString:@"9"]) {
        
        self.statusImgV.image = IMG(@"打卡缺卡");
        [self.pcStatusBtn setTitle:@"外出" forState:UIControlStateNormal];
        [self.pcStatusBtn setTitleColor:kUIColorFromRGB(0xF63F3F) forState:UIControlStateNormal];
        self.pcStatusBtn.layer.borderColor = kUIColorFromRGB(0xF63F3F).CGColor;
    }else if ([model.punchcard_status isEqualToString:@"10"]) {
        
        self.statusImgV.image = IMG(@"打卡旷工");
        [self.pcStatusBtn setTitle:@"迟到旷工" forState:UIControlStateNormal];
        [self.pcStatusBtn setTitleColor:kUIColorFromRGB(0x4B4948) forState:UIControlStateNormal];
        self.pcStatusBtn.layer.borderColor = kUIColorFromRGB(0x4B4948).CGColor;
    }else if ([model.punchcard_status isEqualToString:@"11"]) {
        
        self.statusImgV.image = IMG(@"打卡旷工");
        [self.pcStatusBtn setTitle:@"早退旷工" forState:UIControlStateNormal];
        [self.pcStatusBtn setTitleColor:kUIColorFromRGB(0x4B4948) forState:UIControlStateNormal];
        self.pcStatusBtn.layer.borderColor = kUIColorFromRGB(0x4B4948).CGColor;
    }
    
    if ([model.change isEqualToString:@"1"]) {
        
            self.updateLab.text = @"更新打卡";
            //加下划线
            self.updateLab.attributedText = [HQHelper stringAttributeWithUnderLine:self.updateLab.text];
        self.updateLab.hidden = NO;
    }else{
        
        self.updateLab.hidden = YES;
    }
    
    
    if ([model.punchcard_status isEqualToString:@"5"]) {// 缺卡
        
        if (!IsStrEmpty(model.bean_name)) {
            
            self.addCard.text = @"申请补卡";
            //加下划线
            self.addCard.attributedText = [HQHelper stringAttributeWithUnderLine:self.addCard.text];
            self.addCard.hidden = NO;
        }else{
            self.addCard.hidden = YES;
        }
    }
//    else if ([model.punchcard_status isEqualToString:@"1"]){// 正常
    else{// 正常
        
        if (!IsStrEmpty(model.bean_name) && !IsStrEmpty(model.data_id)) {
            self.addCard.text = @"申请补卡(审批通过)";
            //加下划线
            self.addCard.attributedText = [HQHelper stringAttributeWithUnderLine:self.addCard.text];
            self.addCard.hidden = NO;
        }else{
            if ([model.is_outworker isEqualToString:@"0"]) {
                self.addCard.hidden = NO;// 有可能为查看备注
            }else{
                self.addCard.hidden = YES;// 有可能为查看备注
            }
        }
    }
    
}

+ (instancetype)TFPunchCardCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFPunchCardCell" owner:self options:nil] lastObject];
}

+ (instancetype)PunchCardCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"TFPunchCardCell";
    TFPunchCardCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self TFPunchCardCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
