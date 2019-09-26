//
//  HQPageControl.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/8/9.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQPageControl.h"
#define DotWidth 8
@interface HQPageControl ()

@property (nonatomic , strong) UIImage *normalActiveImage;
@property (nonatomic , strong) UIImage *normalInactiveImage;
@property (nonatomic , strong) UIImage *addActiveImage;
@property (nonatomic , strong) UIImage *addInactiveImage;


@property (nonatomic, assign) NSInteger index;

@end

@implementation HQPageControl

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.index = 1;
        self.normalActiveImage = [HQHelper createImageWithColor:GreenColor];
        self.normalInactiveImage = [HQHelper createImageWithColor:HexAColor(0xcdcdcd, 1)];
        self.addActiveImage = [UIImage imageNamed:@"添加阶段-1"];
        self.addInactiveImage = [UIImage imageNamed:@"添加阶段-0"];
    }
    return self;
}

-(void)setSpecial:(BOOL)special{
    _special = special;
    
    if (special) {
        self.normalActiveImage = [HQHelper createImageWithColor:WhiteColor];
        self.normalInactiveImage = [HQHelper createImageWithColor:HexAColor(0xffffff, 0.5)];
    }else{
        self.normalActiveImage = [HQHelper createImageWithColor:GreenColor];
        self.normalInactiveImage = [HQHelper createImageWithColor:HexAColor(0xcdcdcd, 1)];
    }
}

- (void)setNumberOfPages:(NSInteger)numberOfPages{
    
    _numberOfPages = numberOfPages;
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    for (NSInteger i = 0; i < numberOfPages; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.layer.cornerRadius = DotWidth / 2;
        imageView.layer.masksToBounds = YES;
        
        imageView.origin = CGPointMake(i * (self.index + 1) * DotWidth, 0);
        
        imageView.size = CGSizeMake(DotWidth * self.index, DotWidth);
        
        [self addSubview:imageView];
        
    }
    
    self.size = CGSizeMake((self.index + 1) * DotWidth * numberOfPages - DotWidth, 20);
    self.center = CGPointMake(SCREEN_WIDTH / 2, self.y+10);

    self.currentPage = 0;
}

- (void)setCurrentPage:(NSInteger)currentPage{
    
    _currentPage = currentPage;
    
    [self updateDots];
}

- (void)setType:(NSInteger)type{
    _type = type;
    
    [self updateDots];
}

/** 更新点 */
- (void) updateDots
{
    for (int i = 0; i < self.subviews.count; i++){
        
        UIImageView* dot = [self.subviews objectAtIndex:i];
        
        if (self.type == 0) {
            
            if (i == self.subviews.count - 1) {
                
                if (i == self.currentPage) dot.image = self.addActiveImage;
                else dot.image = self.addInactiveImage;
                
            }else{
                
                if (i == self.currentPage) dot.image = self.normalActiveImage;
                else dot.image = self.normalInactiveImage;
                
            }
        }else{
            
            if (i == self.currentPage) dot.image = self.normalActiveImage;
            else dot.image = self.normalInactiveImage;
        }
        
    }
}

- (void)layoutSubviews{
    
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
