//
//  HQPhotoCell.m
//  HuiJuHuaQi
//
//  Created by hq002 on 16/3/10.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQPhotoCell.h"

@interface HQPhotoCell ()

@end

@implementation HQPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.minus setImage:[UIImage imageNamed:@"减去"] forState:UIControlStateNormal];
    [self.minus addTarget:self action:@selector(minusClick) forControlEvents:UIControlEventTouchUpInside];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageNum.hidden = YES;
}

- (void)minusClick{
    if ([self.delegate respondsToSelector:@selector(photoCellMinusButtonClickedIndex:)]) {
        [self.delegate photoCellMinusButtonClickedIndex:self.imageView.tag - 1000];
    }
}

@end
