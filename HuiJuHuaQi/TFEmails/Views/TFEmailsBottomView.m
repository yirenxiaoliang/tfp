//
//  TFEmailsBottomView.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/2/27.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEmailsBottomView.h"

@interface TFEmailsBottomView ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation TFEmailsBottomView

- (instancetype)initWithBottomViewFrame:(CGRect)frame labs:(NSArray *)labes image:(NSArray *)images {
    
    
    if (self = [super initWithFrame:frame]) {
        
        self.titles = labes;
        self.images = images;
        
        [self setupSubview];
    }
    
    return self;
    
}

- (void)setupSubview {
    
//    self.backgroundColor = LightGrayTextColor;

    CGFloat width = self.frame.size.width/self.titles.count;
    
    for (int i = 0; i < self.titles.count; i++) {
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.button.frame = CGRectMake(width*i, 0, width, 50);
        self.button.tag = i;
        [self.button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.button setImage:IMG(self.images[i]) forState:UIControlStateNormal];
        self.button.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        [self.button setTitle:[NSString stringWithFormat:@"%@",self.titles[i]] forState:UIControlStateNormal];
        [self.button setTitleColor:kUIColorFromRGB(0x69696C) forState:UIControlStateNormal];
        self.button.titleLabel.font = FONT(14);
        
        [self addSubview:self.button];
    }
}

//刷新按钮的lab
- (void)refreshButtonTitle:(NSString *)title index:(NSInteger)index {

    NSLog(@"self.button.tag:%ld",self.button.tag);
    if (self.button.tag == index) {
        
       [self.button setTitle:title forState:UIControlStateNormal];
    }
    
    
}

- (void)btnAction:(UIButton *)button {

    if ([self.delegate respondsToSelector:@selector(emailBottomButtonClicked:)]) {
        
        [self.delegate emailBottomButtonClicked:button.tag];
    }
}

@end
