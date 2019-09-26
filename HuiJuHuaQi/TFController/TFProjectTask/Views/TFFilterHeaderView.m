//
//  TFFilterHeaderView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/8.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFFilterHeaderView.h"

@interface TFFilterHeaderView ()

/** arrow */
@property (nonatomic, weak) UIButton *arrow;

@end

@implementation TFFilterHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
     
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, frame.size.width-30, frame.size.height)];
        [self addSubview:label];
        self.title = label;
        
        UIButton *arrow = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:arrow];
        arrow.frame = CGRectMake(frame.size.width-44, 0, 44, 44);
        [arrow setImage:[UIImage imageNamed:@"下拉"] forState:UIControlStateNormal];
        [arrow setImage:[UIImage imageNamed:@"展开"] forState:UIControlStateSelected];
        arrow.userInteractionEnabled = NO;
        self.arrow = arrow;
        
        self.backgroundColor = HexColor(0xf9f9f9);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapClicked{
    
    if ([self.delegate respondsToSelector:@selector(filterHeaderViewDidClicked:)]) {
        [self.delegate filterHeaderViewDidClicked:self];
    }
}

-(void)setSelected:(BOOL)selected{
    _selected = selected;
    
    self.arrow.selected = selected;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
