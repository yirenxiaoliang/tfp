//
//  TFCustomDetaiHeaderView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/12.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomDetaiHeaderView.h"

@interface TFCustomDetaiHeaderView ()


@end

@implementation TFCustomDetaiHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:imageView];
        
        UILabel *label = [HQHelper labelWithFrame:(CGRect){10+30,self.height-40,self.width-40,40} text:@"" textColor:WhiteColor textAlignment:NSTextAlignmentLeft font:BFONT(20)];
        [self addSubview:label];
        self.titleLabel = label;
        
//        [imageView setImage:[HQHelper createImageWithColor:GreenColor]];
        [imageView setImage:[UIImage imageNamed:@"详情-背景"]];
        
        UIImageView *logo = [[UIImageView alloc] initWithFrame:(CGRect){10,self.height-40,30,40}];
        logo.contentMode = UIViewContentModeCenter;
        [self addSubview:logo];
        logo.image = IMG(@"Shape");
        self.logo = logo;
    }
    return self;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    
    self.titleLabel.text = title;
    CGSize size = [HQHelper sizeWithFont:BFONT(20) maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) titleStr:title];
    CGFloat width = size.width > self.width-100 ? self.width-100 : size.width;
    self.titleLabel.width = width;
    self.titleCenterX = self.titleLabel.centerX;
}

+(instancetype)customDetaiHeaderView{
    
    TFCustomDetaiHeaderView *view = [[TFCustomDetaiHeaderView alloc] initWithFrame:(CGRect){0,-64-TopM,SCREEN_WIDTH,104+TopM}];
    view.backgroundColor = WhiteColor;
    return view;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
