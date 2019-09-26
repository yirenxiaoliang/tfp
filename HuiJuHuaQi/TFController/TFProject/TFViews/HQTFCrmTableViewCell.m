//
//  HQTFCrmTableViewCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/23.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFCrmTableViewCell.h"

@interface HQTFCrmTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelHeight;

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet UIButton *btn6;

@property (weak, nonatomic) IBOutlet UIButton *btn7;
@property (weak, nonatomic) IBOutlet UIButton *btn8;
@property (weak, nonatomic) IBOutlet UIButton *btn9;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *circleView;
@property (weak, nonatomic) IBOutlet UIView *groundImage;

@end

@implementation HQTFCrmTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.circleView.layer.cornerRadius = 6;
    self.circleView.layer.masksToBounds = YES;
    self.circleView.layer.borderWidth = 4;
    self.circleView.layer.borderColor = RedColor.CGColor;
    self.circleView.backgroundColor = [UIColor clearColor];
    
    self.titleLabel.textColor = BlackTextColor;
    self.titleLabel.font = FONT(18);
    
    self.btn1.backgroundColor = [UIColor clearColor];
    self.btn2.backgroundColor = [UIColor clearColor];
    self.btn3.backgroundColor = [UIColor clearColor];
    self.btn4.backgroundColor = [UIColor clearColor];
    self.btn5.backgroundColor = [UIColor clearColor];
    self.btn6.backgroundColor = [UIColor clearColor];
    self.btn9.backgroundColor = [UIColor clearColor];
    
//    self.btn7.backgroundColor = [UIColor clearColor];
//    self.btn8.backgroundColor = [UIColor clearColor];
    self.btn7.layer.cornerRadius = 15;
    self.btn7.layer.masksToBounds = YES;
    self.btn8.layer.cornerRadius = 15;
    self.btn8.layer.masksToBounds = YES;
    
    
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.groundImage.layer.cornerRadius = 3;
//    self.groundImage.layer.masksToBounds = YES;
//    self.groundImage.image = [HQHelper createImageWithColor:WhiteColor];
    self.groundImage.backgroundColor = WhiteColor;
    self.groundImage.layer.shadowColor = GrayTextColor.CGColor;
    self.groundImage.layer.shadowOffset = CGSizeMake(1, 1);
    self.groundImage.layer.shadowOpacity = 0.2;
    self.groundImage.layer.shadowRadius = 1;
    [self.contentView insertSubview:self.groundImage atIndex:0];
    
    // self.groundImage 最高为124，加上下边距12 = 136
    
    NSArray *image = @[@"描述",@"考勤2",@"投票2",@"文件",@"重复任务",@"数量",@"上锁",];
}

+ (instancetype)crmTableViewCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQTFCrmTableViewCell" owner:self options:nil] lastObject];
}

+ (HQTFCrmTableViewCell *)crmTableViewCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"HQTFCrmTableViewCell";
    HQTFCrmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self crmTableViewCell];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
