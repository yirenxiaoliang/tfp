//
//  TFLabelImageButton.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/8/13.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFLabelImageButton.h"

@implementation TFLabelImageButton


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGRect titleF = self.titleLabel.frame;
    CGRect imageF = self.imageView.frame;
    
    imageF.origin.x = CGRectGetMaxX(titleF) - imageF.size.width;
    self.imageView.frame = imageF;
    
    titleF.origin.x = imageF.origin.x - titleF.size.width;
    self.titleLabel.frame = titleF;
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
