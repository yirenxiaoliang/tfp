//
//  HQPictureView.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/3/16.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQPictureView.h"

@interface HQPictureView ()

@property (nonatomic, strong) NSMutableArray *photos;

@end

@implementation HQPictureView



- (void)refreshPictureViewWithPhotos:(NSArray *)photos
                            Distance:(float)distanceFloat
                           itemWidth:(float)itemWidth
                          lineNumber:(NSInteger)lineNum
{
    
    for (UIView *view in self.subviews) {
        
        [view removeFromSuperview];
    }
    
    
    if (photos.count ==0) {
        self.height = 0;
        return;
    }

    
    self.photos = [NSMutableArray arrayWithArray:photos];
    
    
    for (int i=0; i<photos.count; i++) {
        
        CGRect btnFrame = CGRectMake((i%lineNum) * (distanceFloat+itemWidth),
                                     (i/lineNum) * (distanceFloat+itemWidth),
                                     itemWidth,
                                     itemWidth);
        UIButton *imgBtn = [HQHelper buttonWithFrame:btnFrame
                                              target:self
                                              action:@selector(didPictureAction:)];
        imgBtn.tag = 100 + i;
        NSString *photo = photos[i];
        NSString *urlStr = [NSString stringWithFormat:@"%@", photo];
        [imgBtn sd_setImageWithURL:[HQHelper URLWithString:urlStr]
                                    forState:UIControlStateNormal
                            placeholderImage:[UIImage imageNamed:@"picture_loading"]
                                   completed:
         ^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
        {
            if (error) {
                [imgBtn setImage:[UIImage imageNamed:@"picture_loadError"] forState:UIControlStateNormal];
            }
        }];
        imgBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imgBtn];
    }
    
    
    
    self.width  = itemWidth * lineNum + distanceFloat * (lineNum - 1);
    
    NSInteger floorNum;
    if (photos.count % lineNum == 0) {
        floorNum = photos.count / lineNum;
    }else {
        floorNum = photos.count / lineNum + 1;
    }
    self.height = floorNum*itemWidth + (floorNum-1)*distanceFloat;
    
}



- (void)didPictureAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(didPictureWithPhotos:indexNum:)]) {
        
        [self.delegate didPictureWithPhotos:self.photos indexNum:button.tag-100];
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
