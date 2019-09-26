//
//  TFCellImgBtnView.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/7/27.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCellImgBtnView.h"

@implementation TFCellImgBtnView

- (void)awakeFromNib {

    [super awakeFromNib];
    
    
}

- (instancetype)initWithimgBtnViewFrame:(CGRect)frame labs:(NSArray *)labes image:(NSArray *)images textFont:(UIFont *)font textColor:(UIColor *)textColor  {

    
    if (self = [super initWithFrame:frame]) {
        
        self.labs = labes;
        self.images = images;
        
        self.textFont = font;
        
        self.textColor = textColor;
        
        [self setupBtnViewsWithImgAndLab];
    }
    
    return self;
    
}

- (void)setupBtnViewsWithImgAndLab{

    CGFloat width = SCREEN_WIDTH/self.labs.count;
    
    for (int i=0; i<self.labs.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(width*i, 0, width, 50);
        button.tag = i;
        [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, width, 25)];
        self.imgView.contentMode = UIViewContentModeCenter;
        self.imgView.image = IMG(self.images[i]);
        [button addSubview:self.imgView];
        
        self.lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, width, 20)];
        self.lab.textAlignment = NSTextAlignmentCenter;
        self.lab.textColor = self.textColor;
        self.lab.font = self.textFont;
        self.lab.text = self.labs[i];
        
        [button addSubview:self.lab];
        
        [self addSubview:button];
        
    }
}

- (void)btnAction:(UIButton *)button {

    if ([self.delegate respondsToSelector:@selector(cellImgBtnView:btnClicked:)]) {
        [self.delegate cellImgBtnView:self btnClicked:button.tag];
    } 
}



- (void)setTextFont:(UIFont *)textFont {

    _textFont = textFont;
    
    self.lab.font = textFont;
}

- (void)setTextColor:(UIColor *)textColor {

    _textColor = textColor;
    
    self.lab.textColor = textColor;
}

@end
