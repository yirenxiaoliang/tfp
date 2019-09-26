//
//  AddItemButton.m
//  LiuqsEmoticonkeyboard
//
//  Created by HQ-20 on 2017/12/14.
//  Copyright © 2017年 刘全水. All rights reserved.
//

#import "AddItemButton.h"

@implementation AddItemButton

-(instancetype)init{
    if (self = [super init]) {
        
        self.scale = 0.6;
        self.wordScale = 0.6;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)setScale:(CGFloat)scale{
    _scale = scale;
    
    [self setNeedsLayout];
}

- (void)setWordScale:(CGFloat)wordScale{
    _wordScale = wordScale;
    
    [self setNeedsLayout];
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect rect = CGRectMake(0, self.frame.size.height * self.wordScale, self.frame.size.width, self.frame.size.height * (1-self.wordScale));
    return rect;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGRect rect = CGRectMake(0, 0, self.frame.size.width , self.frame.size.height* self.scale);
    return rect;
}


/** 创建button */
+ (instancetype)rootButton{
    
    AddItemButton *button = [[AddItemButton alloc] init];
    
    return button;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
