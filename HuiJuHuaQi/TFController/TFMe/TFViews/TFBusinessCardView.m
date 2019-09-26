//
//  TFBusinessCardView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/27.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFBusinessCardView.h"

@interface TFBusinessCardView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view1centerX;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view2centerX;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view3centerX;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view1TopY;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view2BottomY;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view3BottomY;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view1W;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view2W;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view3W;


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *telephoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *teleLabel;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIImageView *companyImage;
@property (weak, nonatomic) IBOutlet UIImageView *locationImage;
@property (weak, nonatomic) IBOutlet UIImageView *telephoneImage;
@property (weak, nonatomic) IBOutlet UIImageView *teleImage;

@end

@implementation TFBusinessCardView


-(void)awakeFromNib{
    [super awakeFromNib];
    self.nameLabel.text = @"";
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.font = FONT(18);
    
    self.positionLabel.text = @"";
    self.positionLabel.textColor = [UIColor blackColor];
    self.positionLabel.font = FONT(12);
    
    self.emailLabel.text = @"";
    self.emailLabel.textColor = [UIColor blackColor];
    self.emailLabel.font = FONT(12);
    
    self.companyLabel.text = @"";
    self.companyLabel.textColor = [UIColor blackColor];
    self.companyLabel.font = FONT(12);
    
    self.addressLabel.text = @"";
    self.addressLabel.textColor = [UIColor blackColor];
    self.addressLabel.font = FONT(12);
    
    self.telephoneLabel.text = @"";
    self.telephoneLabel.textColor = [UIColor blackColor];
    self.telephoneLabel.font = FONT(12);
    
    self.teleLabel.text = @"";
    self.teleLabel.textColor = [UIColor blackColor];
    self.teleLabel.font = FONT(12);
    
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    self.view1.backgroundColor = ClearColor;
    self.view2.backgroundColor = ClearColor;
    self.view3.backgroundColor = ClearColor;
//    self.view1.backgroundColor = RedColor;
//    self.view2.backgroundColor = RedColor;
//    self.view3.backgroundColor = RedColor;
    self.imageView.layer.cornerRadius = 5;
//    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.borderColor = CellSeparatorColor.CGColor;
    self.imageView.layer.borderWidth = 0.5;
    
    self.imageView.layer.shadowOffset = CGSizeMake(4, 4);
    self.imageView.layer.shadowColor = CellSeparatorColor.CGColor;
    self.imageView.layer.shadowOpacity = 0.5;
    self.imageView.layer.shadowRadius = 2;
    
}

-(void)refreshBusinessCardVeiwWithModel:(TFPersonInfoModel *)model{
    
    NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:@"BusinessCard"];
    
    if (str == nil) {
        str = @"businessCard1";
    }
    
    self.imageView.image = [UIImage imageNamed:str];
    
    self.nameLabel.text = model.employeeName;
    self.positionLabel.text = model.position;
    self.emailLabel.text = model.email;
    self.companyLabel.text = model.companyName;
    self.addressLabel.text = model.region;
    self.telephoneLabel.text = model.telephone;
    self.teleLabel.text = model.mobilePhoto;
    NSString *sss = [str stringByReplacingOccurrencesOfString:@"businessCard" withString:@""];
    NSInteger num = [sss integerValue];
    
    self.companyImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"cardC%ld",num]];
    self.locationImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"cardL%ld",num]];
    self.telephoneImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"cardT%ld",num]];
    self.teleImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"cardM%ld",num]];
    
    
    CGFloat width = self.width-30;
    
    switch (num) {
        case 1:
        {
            self.nameLabel.textColor = LightBlackTextColor;
            self.positionLabel.textColor = LightBlackTextColor;
            self.emailLabel.textColor = LightBlackTextColor;
            self.companyLabel.textColor = LightBlackTextColor;
            self.addressLabel.textColor = LightBlackTextColor;
            self.telephoneLabel.textColor = LightBlackTextColor;
            self.teleLabel.textColor = LightBlackTextColor;
            
            self.view1W.constant = width/8*5;
            self.view1centerX.constant = (width/8 * 3)/4 ;
            self.view1TopY.constant = 54;
            
            self.view2W.constant = width/8*5 ;
            self.view2centerX.constant = (width/8 * 3)/4;
            self.view2BottomY.constant = 30 + 48 + 8;
            
            self.view3W.constant = width/8*5 ;
            self.view3centerX.constant = (width/8 * 3)/4;
            self.view3BottomY.constant = 30;
            
        }
            break;
        case 2:
        {
            self.nameLabel.textColor = BlackTextColor;
            self.positionLabel.textColor = BlackTextColor;
            self.emailLabel.textColor = BlackTextColor;
            self.companyLabel.textColor = BlackTextColor;
            self.addressLabel.textColor = BlackTextColor;
            self.telephoneLabel.textColor = BlackTextColor;
            self.teleLabel.textColor = BlackTextColor;
            
            self.view1W.constant = width/8*5;
            self.view1centerX.constant = (width/8 * 3)/4+ width/8;
            self.view1TopY.constant = 34;
            
            self.view2W.constant = width/8*5 ;
            self.view2centerX.constant = -(width/8*3)/2+15;
            self.view2BottomY.constant = 30;
            
            self.view3W.constant = width/8*3 ;
            self.view3centerX.constant = (width/8*5)/2 + width/8 - 30;
            self.view3BottomY.constant = 30;
        }
            break;
        case 3:
        {
            self.nameLabel.textColor = WhiteColor;
            self.positionLabel.textColor = WhiteColor;
            self.emailLabel.textColor = WhiteColor;
            self.companyLabel.textColor = BlackTextColor;
            self.addressLabel.textColor = BlackTextColor;
            self.telephoneLabel.textColor = BlackTextColor;
            self.teleLabel.textColor = BlackTextColor;
            
            self.view1W.constant = width/4*3;
            self.view1centerX.constant = 0;
            self.view1TopY.constant = 54;
            
            self.view2W.constant = width/8*7 ;
            self.view2centerX.constant = 0;
            self.view2BottomY.constant = 30 + 48 + 8;
            
            self.view3W.constant = width/8*7 ;
            self.view3centerX.constant = 0;
            self.view3BottomY.constant = 30;
            
        }
            break;
        case 4:
        {
            self.nameLabel.textColor = RedColor;
            self.positionLabel.textColor = RedColor;
            self.emailLabel.textColor = RedColor;
            self.companyLabel.textColor = RedColor;
            self.addressLabel.textColor = RedColor;
            self.telephoneLabel.textColor = RedColor;
            self.teleLabel.textColor = RedColor;
            
            self.view1W.constant = width/8*5;
            self.view1centerX.constant = (width/8 * 3)/4 ;
            self.view1TopY.constant = 54;
            
            self.view2W.constant = width/8*7 ;
            self.view2centerX.constant = 0;
            self.view2BottomY.constant = 30 + 48 + 8;
            
            self.view3W.constant = width/8*7 ;
            self.view3centerX.constant = 0;
            self.view3BottomY.constant = 30;
        }
            break;
            
        default:
            break;
    }
    
}


+ (instancetype)businessCardView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFBusinessCardView" owner:self options:nil] lastObject];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
