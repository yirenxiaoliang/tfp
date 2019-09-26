//
//  HQWigetButton.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/6/6.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQWigetButton.h"

@implementation HQWigetButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 5, self.frame.size.width, self.frame.size.height * 2 / 3);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, self.frame.size.height * 2 / 3, self.frame.size.width, self.frame.size.height * 1 / 3);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
