//
//  UILabel+Extension.m
//  MapDev
//
//  Created by beok on 16/1/8.
//  Copyright © 2016年 beok. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

+(UILabel *)initCustom:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(CGFloat)titleFont bgColor:(UIColor *)bgColor
{
    //初始化
    UILabel *customLab=[[UILabel alloc]init];
    //设置frame
    customLab.frame=frame;
    //设置标题
    [customLab setText:title];
    //设置标题颜色
    [customLab setTextColor:titleColor];
    //设置字体大小
    [customLab setFont:[UIFont systemFontOfSize:titleFont]];
    //设置背景颜色
    [customLab setBackgroundColor:bgColor];
    
    [customLab setTextAlignment:NSTextAlignmentCenter];
    
    return customLab;
}

@end
