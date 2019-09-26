//
//  TFSubformAddView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/11/30.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSubformAddView.h"

@implementation TFSubformAddView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIButton *view = [HQHelper buttonWithFrame:(CGRect){0,0,SCREEN_WIDTH,40} target:self action:@selector(footerClick:)];
        view.backgroundColor = HexColor(0xF5F8FA);
        [view setTitle:@" 增加栏目" forState:UIControlStateNormal];
        [view setTitle:@" 增加栏目" forState:UIControlStateHighlighted];
        [view setImage:IMG(@"custom加栏") forState:UIControlStateNormal];
        [view setImage:IMG(@"custom加栏") forState:UIControlStateHighlighted];
//        [view setBackgroundImage:IMG(@"新增框") forState:UIControlStateNormal];
//        [view setBackgroundImage:IMG(@"新增框") forState:UIControlStateHighlighted];
        [view setTitleColor:GreenColor forState:UIControlStateNormal];
        [view setTitleColor:GreenColor forState:UIControlStateHighlighted];
        view.titleLabel.font = FONT(12);
        [self addSubview:view];
        self.addBtn = view;
        view.layer.cornerRadius = 4;
        view.layer.masksToBounds = YES;
        self.backgroundColor = WhiteColor;
        self.layer.masksToBounds = YES;
    }
    return self;
}

+(instancetype)subformAddView{
    
    TFSubformAddView *view = [[TFSubformAddView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,40}];
    
    return view;
}

- (void)footerClick:(UIButton *)button{
    
    
    if ([self.delegate respondsToSelector:@selector(subformAddView:didClickedAddBtn:)]) {
        [self.delegate subformAddView:self didClickedAddBtn:button];
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
