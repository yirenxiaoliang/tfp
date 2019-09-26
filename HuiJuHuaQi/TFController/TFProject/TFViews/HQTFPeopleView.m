//
//  HQTFPeopleView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFPeopleView.h"

@interface HQTFPeopleView ()

@end

@implementation HQTFPeopleView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    
    self.headImage.layer.cornerRadius = 2;
    self.headImage.layer.masksToBounds = YES;
    self.headImage.contentMode = UIViewContentModeScaleAspectFill;
    self.headImage.titleLabel.font = FONT(16);
    
    self.headName.textColor = LightBlackTextColor;
    self.headName.font = FONT(16);
    self.headName.textAlignment = NSTextAlignmentLeft;
    self.headName.hidden = YES;
    
    [self.headImage setBackgroundImage:[HQHelper createImageWithColor:GrayGroundColor] forState:UIControlStateNormal];
    [self.headImage setBackgroundImage:[HQHelper createImageWithColor:GrayGroundColor] forState:UIControlStateHighlighted];
}

+ (instancetype)peopleView{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQTFPeopleView" owner:self options:nil] lastObject];
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
