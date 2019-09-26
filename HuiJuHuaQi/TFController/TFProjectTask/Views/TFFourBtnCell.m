//
//  TFFourBtnCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/13.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFFourBtnCell.h"

@interface TFFourBtnCell ()
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourthBtn;


@end

@implementation TFFourBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.firstBtn.userInteractionEnabled = NO;
    self.secondBtn.userInteractionEnabled = NO;
    self.thirdBtn.userInteractionEnabled = NO;
    self.fourthBtn.userInteractionEnabled = NO;
    
}
+(instancetype)fourBtnCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFFourBtnCell" owner:self options:nil] lastObject];
}

+ (TFFourBtnCell *)fourBtnCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"TFFourBtnCell";
    TFFourBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self fourBtnCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)refreshFourBtnCellWithEmployee:(HQEmployModel *)employee{
    
    [self.secondBtn setTitle:@"执行人" forState:UIControlStateNormal];
    [self.firstBtn setImage:IMG(@"addPeople") forState:UIControlStateNormal];
    [self.fourthBtn setImage:IMG(@"下一级浅灰") forState:UIControlStateNormal];
    if (employee) {
        [self.secondBtn setTitleColor:ExtraLightBlackTextColor forState:UIControlStateNormal];
        self.thirdBtn.hidden = NO;
    }else{
        [self.secondBtn setTitleColor:HexColor(0xd6d6d6) forState:UIControlStateNormal];
        self.thirdBtn.hidden = YES;
    }
    self.thirdBtn.layer.cornerRadius = 15;
    self.thirdBtn.layer.masksToBounds = YES;
    [self.thirdBtn sd_setImageWithURL:[HQHelper URLWithString:employee.photograph] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       
        if (image) {
            [self.thirdBtn setTitle:@"" forState:UIControlStateNormal];
        }else{
            [self.thirdBtn setTitle:[HQHelper nameWithTotalName:employee.employeeName?:employee.employee_name] forState:UIControlStateNormal];
            [self.thirdBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
            [self.thirdBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
            self.thirdBtn.titleLabel.font = FONT(12);
        }
    }];
    
}
-(void)refreshFourBtnCellWithTime:(NSString *)time{
    
    [self.firstBtn setImage:IMG(@"endTime") forState:UIControlStateNormal];
    [self.fourthBtn setImage:IMG(@"下一级浅灰") forState:UIControlStateNormal];
    if (time && ![time isEqualToString:@""]) {
        [self.secondBtn setTitleColor:ExtraLightBlackTextColor forState:UIControlStateNormal];
        [self.secondBtn setTitle:time forState:UIControlStateNormal];
    }else{
        [self.secondBtn setTitleColor:HexColor(0xd6d6d6) forState:UIControlStateNormal];
        [self.secondBtn setTitle:@"截止时间" forState:UIControlStateNormal];
    }
    self.thirdBtn.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
