//
//  TFCompanyCirclePictureView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/19.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCompanyCirclePictureView.h"
#import "TFFileModel.h"

#define ImageViewWidth 74
#define Margin 2

@interface TFCompanyCirclePictureView ()
/** imageViews */
@property (nonatomic, strong) NSMutableArray *imageViews;
/** imageViews */
@property (nonatomic, strong) NSMutableArray *imageViews1;

@end

@implementation TFCompanyCirclePictureView

-(NSMutableArray *)imageViews1{
    
    if (!_imageViews1) {
        _imageViews1 = [NSMutableArray array];
    }
    return _imageViews1;
    
}

-(NSMutableArray *)imageViews{
    
    if (!_imageViews) {
        _imageViews = [NSMutableArray array];
    }
    return _imageViews;
    
}

- (void)refreshCompanyCirclePictureViewWithImages:(NSArray *)images{
    
    for (UIImageView *imageView in self.imageViews1) {
        
        [imageView removeFromSuperview];
    }
    
    [self.imageViews1 removeAllObjects];
    
    for (UIImageView *imageView in self.imageViews) {
        
        [imageView removeFromSuperview];
    }
    
    [self.imageViews removeAllObjects];
    
    for (NSInteger i = 0; i < images.count; i ++) {
        TFFileModel *file = images[i];
        
        UIImageView *imageView1 = [[UIImageView alloc] init];
        imageView1.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imageView1];
        imageView1.layer.masksToBounds = YES;
        [imageView1 sd_setImageWithURL:[HQHelper URLWithString:file.file_url] placeholderImage:[HQHelper createImageWithColor:BackGroudColor]];
        [self.imageViews1 addObject:imageView1];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.tag = i;
        [self addSubview:imageView];
        [self.imageViews addObject:imageView];
        [imageView sd_setImageWithURL:[HQHelper URLWithString:file.file_url] placeholderImage:[HQHelper createImageWithColor:BackGroudColor]];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClicked:)];
        [imageView addGestureRecognizer:tap];
        imageView.layer.masksToBounds = YES;
    }
    
}
- (void)imageViewClicked:(UITapGestureRecognizer *)tap{
    
    if ([self.delegate respondsToSelector:@selector(companyCirclePictureViewWithImageViews:didImageViewWithIndex:)]) {
        [self.delegate companyCirclePictureViewWithImageViews:self.imageViews didImageViewWithIndex:tap.view.tag];
    }
    
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    for (NSInteger i = 0; i < self.imageViews1.count; i ++) {
        UIImageView *imageView = self.imageViews1[i];
        if (self.imageViews1.count <= 1) {
            
            imageView.frame = self.bounds;
        }else if (self.imageViews1.count <= 4){// 两列
            
            NSInteger row = i / 2;
            NSInteger col = i % 2;
            
            imageView.frame = CGRectMake((ImageViewWidth + Margin) * col, (ImageViewWidth + Margin) * row, ImageViewWidth, ImageViewWidth);
        }else{
            
            NSInteger row = i / 3;
            NSInteger col = i % 3;
            
            imageView.frame = CGRectMake((ImageViewWidth + Margin) * col, (ImageViewWidth + Margin) * row, ImageViewWidth, ImageViewWidth);
            
        }
        
    }
    for (NSInteger i = 0; i < self.imageViews.count; i ++) {
        UIImageView *imageView = self.imageViews[i];
        if (self.imageViews.count <= 1) {
            
            imageView.frame = self.bounds;
        }else if (self.imageViews.count <= 4){// 两列
            
            NSInteger row = i / 2;
            NSInteger col = i % 2;
            
            imageView.frame = CGRectMake((ImageViewWidth + Margin) * col, (ImageViewWidth + Margin) * row, ImageViewWidth, ImageViewWidth);
        }else{
            
            NSInteger row = i / 3;
            NSInteger col = i % 3;
            
            imageView.frame = CGRectMake((ImageViewWidth + Margin) * col, (ImageViewWidth + Margin) * row, ImageViewWidth, ImageViewWidth);
            
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
