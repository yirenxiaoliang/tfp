//
//  HQTFTaskHeadView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/14.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFTaskHeadView.h"

@implementation HQTFTaskHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UILabel *label = [HQHelper labelWithFrame:(CGRect){12,12,SCREEN_WIDTH - 24,20} text:@"我的任务" textColor:BlackTextColor textAlignment:NSTextAlignmentLeft font:FONT(18)];
        [self addSubview:label];
        label.backgroundColor = WhiteColor;
        self.backgroundColor = WhiteColor;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
