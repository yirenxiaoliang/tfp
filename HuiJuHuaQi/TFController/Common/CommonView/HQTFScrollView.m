//
//  HQTFScrollView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/15.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFScrollView.h"

@implementation HQTFScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [self setup];
    }
    return self;
}

- (void)setup{
    
    self.backgroundColor = WhiteColor;
    self.showsHorizontalScrollIndicator = NO;
    
    CGFloat Top = 12;
    CGFloat left = 12;
    CGFloat buttonW = Long(200);
    CGFloat buttomH = Long(75);
    
    self.contentSize = CGSizeMake(left+ (buttonW +left) * 4, self.height);
    
    for (NSInteger i = 0; i < 4; i ++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        [button setBackgroundImage:[UIImage imageNamed:@"广告1"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"广告1"] forState:UIControlStateHighlighted];
        button.frame = CGRectMake(left+ (buttonW +left) * i, Top, buttonW, buttomH);
    }

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
