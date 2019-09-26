//
//  TFBusinessCard.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/19.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFBusinessCard.h"

@interface TFBusinessCard ()

/** imageView */
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *bgview;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIButton *companyLabel;
@property (weak, nonatomic) IBOutlet UIButton *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *telephoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *teleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *teleH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *telephoneH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *companyH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameHead;

@end

@implementation TFBusinessCard

+ (instancetype)businessCard
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFBusinessCard" owner:self options:nil] lastObject];
}
-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 4;
    self.layer.borderColor = CellSeparatorColor.CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowColor = CellSeparatorColor.CGColor;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 4;
    self.bgview.backgroundColor = ClearColor;
    
    self.imageView.layer.cornerRadius = 4;
    self.imageView.layer.masksToBounds = YES;
//    self.imageView.layer.shadowOffset = CGSizeMake(-4, -4);
//    self.imageView.layer.shadowColor = CellSeparatorColor.CGColor;
//    self.imageView.layer.shadowOpacity = 0.5;
//    self.imageView.layer.shadowRadius = 2;
    
    self.nameLabel.text = @"";
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.font = FONT(18);
    
    self.positionLabel.text = @"";
    self.positionLabel.textColor = [UIColor blackColor];
    self.positionLabel.font = FONT(12);
    
    self.emailLabel.text = @"";
    self.emailLabel.textColor = [UIColor blackColor];
    self.emailLabel.font = FONT(12);
    
    [self.companyLabel setTitle:@"" forState:UIControlStateNormal];
    self.companyLabel.userInteractionEnabled = NO;
    [self.companyLabel setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [self.companyLabel setImage:IMG(@"cardC2") forState:UIControlStateNormal];
    self.companyLabel.titleLabel.font = FONT(12);
    
    [self.addressLabel setTitle:@"" forState:UIControlStateNormal];
    self.addressLabel.userInteractionEnabled = NO;
    [self.addressLabel setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [self.addressLabel setImage:IMG(@"cardL2") forState:UIControlStateNormal];
    self.addressLabel.titleLabel.font = FONT(12);
    self.addressLabel.titleLabel.numberOfLines = 0;
    
    [self.telephoneLabel setTitle:@"" forState:UIControlStateNormal];
    self.telephoneLabel.userInteractionEnabled = NO;
    [self.telephoneLabel setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [self.telephoneLabel setImage:IMG(@"cardT2") forState:UIControlStateNormal];
    self.telephoneLabel.titleLabel.font = FONT(12);
    
    [self.teleLabel setTitle:@"" forState:UIControlStateNormal];
    self.teleLabel.userInteractionEnabled = NO;
    [self.teleLabel setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [self.teleLabel setImage:IMG(@"cardM2") forState:UIControlStateNormal];
    self.teleLabel.titleLabel.font = FONT(12);
    
    self.logoImage.contentMode = UIViewContentModeScaleAspectFit;
}

-(void)refreshViewWithStyle:(NSInteger)style hiddens:(NSArray *)hiddens{
    
    if (style == 0) {
        self.nameHead.constant = 18;
        self.imageView.image = IMG(@"cardStyle1");
    }else{
        self.nameHead.constant = 58;
        self.imageView.image = IMG(@"cardStyle2");
    }
    
    self.teleH.constant = 30;
    self.telephoneH.constant = 30;
    self.addressH.constant = 30;
    self.logoImage.hidden = NO;
    self.teleLabel.hidden = NO;
    self.telephoneLabel.hidden = NO;
    self.addressLabel.hidden = NO;
    self.emailLabel.hidden = NO;
    for (NSString *str in hiddens) {
        
        if ([str isEqualToString:@"0"]) {
            self.logoImage.hidden = YES;
        }
        if ([str isEqualToString:@"1"]) {
            self.teleLabel.hidden = YES;
            self.teleH.constant = 0;
        }
        if ([str isEqualToString:@"2"]) {
            self.telephoneLabel.hidden = YES;
            self.telephoneH.constant = 0;
        }
        if ([str isEqualToString:@"3"]) {
            self.emailLabel.hidden = YES;
        }
        if ([str isEqualToString:@"4"]) {
            self.addressLabel.hidden = YES;
            self.addressH.constant = 0;
        }
    }
    self.nameLabel.text = UM.userLoginInfo.employee.employee_name;
    self.positionLabel.text = UM.userLoginInfo.employee.post_name;
    self.emailLabel.text = UM.userLoginInfo.employee.email;
    [self.companyLabel setTitle:UM.userLoginInfo.company.company_name forState:UIControlStateNormal];
    [self.addressLabel setTitle:UM.userLoginInfo.company.address forState:UIControlStateNormal];
    [self.telephoneLabel setTitle:UM.userLoginInfo.employee.phone forState:UIControlStateNormal];
    [self.teleLabel setTitle:UM.userLoginInfo.employee.mobile_phone forState:UIControlStateNormal];
    [self.logoImage sd_setImageWithURL:[HQHelper URLWithString:UM.userLoginInfo.company.logo] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
