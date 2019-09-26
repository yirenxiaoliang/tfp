//
//  HQTFMeHearder.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/17.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFMeHearder.h"
#import "TFCellImgBtnView.h"
#define OffsetHeight 260
@interface HQTFMeHearder ()



@end

@implementation HQTFMeHearder

-(void)awakeFromNib{
    [super awakeFromNib];
    self.headImage.layer.cornerRadius = 26;
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.borderColor = WhiteColor.CGColor;
    self.headImage.layer.borderWidth = 2;
    self.backgroundColor = [UIColor clearColor];
//    self.descri.backgroundColor = HexColor(0x000000, 0.1);
    
    [self.headImage addTarget:self action:@selector(headImgClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.name.textColor = WhiteColor;
    self.name.font = FONT(14);
    self.name.text = @"";
    
    [self.companyBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    self.companyBtn.titleLabel.font = FONT(16);
    [self.companyBtn addTarget:self action:@selector(companyClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)companyClicked{
    
    
    if ([self.delegate respondsToSelector:@selector(meHeaderClickedCompany)]) {
        [self.delegate meHeaderClickedCompany];
    }
}

- (void)headImgClicked{
    
    if ([self.delegate respondsToSelector:@selector(meHeaderClickedPhoto)]) {
        [self.delegate meHeaderClickedPhoto];
    }
}

+ (instancetype)meHearder
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQTFMeHearder" owner:self options:nil] lastObject];
}

//-(void)layoutSubviews{
//    [super layoutSubviews];
//    
//    self.frame = CGRectMake(0, -OffsetHeight, SCREEN_WIDTH, OffsetHeight);
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
