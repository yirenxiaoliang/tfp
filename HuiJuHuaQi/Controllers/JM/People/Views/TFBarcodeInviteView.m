//
//  TFBarcodeInviteView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/24.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFBarcodeInviteView.h"

@interface TFBarcodeInviteView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *barcodeImage;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation TFBarcodeInviteView


-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.titleLabel.textColor = BlackTextColor;
    self.titleLabel.font = FONT(20);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"深圳汇聚华企科技有限公司";
    
    self.welcomeLabel.textColor = BlackTextColor;
    self.welcomeLabel.font = FONT(32);
    self.welcomeLabel.textAlignment = NSTextAlignmentCenter;
    self.welcomeLabel.text = @"欢迎您！";
    
    
    self.barcodeImage.image = [HQHelper creatBarcodeWithString:@"我是一个兵！" withImgWidth:200];
    
    
    self.tipLabel.text = @"扫描二维码加入企业";
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.textColor = LightGrayTextColor;
    self.tipLabel.font = FONT(14);
    
    
    [self.headImage setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
    [self.headImage setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateHighlighted];
    self.headImage.contentMode = UIViewContentModeScaleAspectFill;
    self.headImage.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.nameLabel.textColor = LightBlackTextColor;
    self.nameLabel.text = @"伊宁路";
    self.nameLabel.font = FONT(18);
    
    self.descLabel.text = @"真诚邀请您的加入";
    self.descLabel.textColor = HexAColor(0xa0a0ae, 1);
    self.descLabel.font = FONT(16);
    
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
}


+ (instancetype)barcodeInviteView{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFBarcodeInviteView" owner:self options:nil] lastObject];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
