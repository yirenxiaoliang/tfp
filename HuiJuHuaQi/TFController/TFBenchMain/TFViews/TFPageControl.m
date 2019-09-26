//
//  TFPageControl.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/11/6.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFPageControl.h"
#define DotWidth 6

@interface TFPageControl ()

@property (nonatomic , strong) UIImage *normalActiveImage;
@property (nonatomic , strong) UIImage *normalInactiveImage;

@end

@implementation TFPageControl

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.index = 1;
        self.normalActiveImage = [HQHelper createImageWithColor:WhiteColor];
        self.normalInactiveImage = [HQHelper createImageWithColor:HexAColor(0xffffff, 0.5)];
    }
    return self;
}

- (void)setNumberOfPages:(NSInteger)numberOfPages{
    
    _numberOfPages = numberOfPages;
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat margin = (self.width - numberOfPages * (self.index + 1) * DotWidth + DotWidth) / 2.0;
    
    for (NSInteger i = 0; i < numberOfPages; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.layer.cornerRadius = DotWidth / 2;
        imageView.layer.masksToBounds = YES;
        imageView.userInteractionEnabled = YES;
        imageView.origin = CGPointMake(margin + i * (self.index + 1) * DotWidth, 0);
        
        imageView.size = CGSizeMake(DotWidth * self.index, DotWidth);
        
        [self addSubview:imageView];
        imageView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clicked:)];
        [imageView addGestureRecognizer:tap];
    }
    
    self.currentPage = 0;
}

-(void)clicked:(UITapGestureRecognizer *)tap{
    
    [self setCurrentPage:tap.view.tag];
    
    if ([self.delegate respondsToSelector:@selector(pageControlDidClickedWithIndex:)]) {
        [self.delegate pageControlDidClickedWithIndex:tap.view.tag];
    }
}

-(void)setIndex:(NSInteger)index{
    _index = index;
    [self updateDots];
}

- (void)setCurrentPage:(NSInteger)currentPage{
    
    _currentPage = currentPage;
    
    [self updateDots];
}

/** 更新点 */
- (void) updateDots
{
    for (int i = 0; i < self.subviews.count; i++){
        
        UIImageView* dot = [self.subviews objectAtIndex:i];
    
        if (i == self.currentPage) {
            dot.image = self.normalActiveImage;
        } else {
            dot.image = self.normalInactiveImage;
            
        }
        
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
