//
//  HQBaseView.m
//  HuiJuHuaQi
//
//  Created by hq002 on 16/4/7.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseView.h"

@implementation HQBaseView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self setup];
}

- (void)setup{
    UIView *topLine = [[UIView alloc] initWithFrame:(CGRect){0, 0, self.width, 0.5}];
    [self addSubview:topLine];
    self.topLine = topLine;
    topLine.backgroundColor = CellSeparatorColor;
    
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:(CGRect){0, self.height - 0.5, self.width, 0.5}];
    [self addSubview:bottomLine];
    self.bottomLine = bottomLine;
    bottomLine.backgroundColor = CellSeparatorColor;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.topLine.frame = (CGRect){0, 0, self.width, 0.5};
    self.bottomLine.frame = (CGRect)(CGRect){0, self.height, self.width, 0.5};
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
