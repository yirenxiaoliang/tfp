//
//  HQTFProcessView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/20.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFProcessView.h"
#define Margin 2 * (M_PI/180)


@implementation HQTFProcessView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

- (void)setRate:(CGFloat)rate{
    _rate = rate;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();//当前画笔
    
    CGContextSetLineWidth(context, 8);//线的宽度
    
    
    NSArray *rates = [self changeRate:self.rate];
    
    // 已完成的
    
    if (self.rate == 1.0) {
        CGContextSetRGBStrokeColor(context, 0xff/255.0, 0xec/255.0, 0x00/255.0, 1.0);//画笔线的颜色
    }else{
        CGContextSetRGBStrokeColor(context, 0x50/255.0, 0xed/255.0, 0xc9/255.0, 1.0);//画笔线的颜色
    }
    
    CGContextAddArc(context, self.width/2, self.height/2, self.width/2-8, [rates[0] floatValue], [rates[1] floatValue], 0); //添加一个圆
    
    CGContextDrawPath(context, kCGPathStroke); //绘制路径
    
    // 未完成的
    CGContextSetRGBStrokeColor(context, 0xff/255.0, 0xff/255.0, 0xff/255.0, 1.0);//画笔线的颜色
    
    CGContextAddArc(context, self.width/2, self.height/2, self.width/2-8, [rates[2] floatValue], [rates[3] floatValue], 0); //添加一个圆
    
    CGContextDrawPath(context, kCGPathStroke); //绘制路径
    
    
}

/** 根据rate算出四个点 */
- (NSArray *)changeRate:(CGFloat)rate{
    
    NSMutableArray *num = [NSMutableArray array];
    if (rate <= 0) {
        [num addObject:@(0-M_PI/2)];
        [num addObject:@(0-M_PI/2)];
        [num addObject:@(0-M_PI/2)];
        [num addObject:@(2 * M_PI - M_PI/2)];
        return num;
        
    }else if (rate >= 1){
        [num addObject:@(0 - M_PI/2)];
        [num addObject:@(2 * M_PI - M_PI/2)];
        [num addObject:@(0 - M_PI/2)];
        [num addObject:@(0 - M_PI/2)];
        return num;
    }else{
        [num addObject:@(Margin-M_PI/2)];
        [num addObject:@(2 * M_PI * rate - Margin - M_PI/2)];
        [num addObject:@(2 * M_PI * rate + Margin - M_PI/2)];
        [num addObject:@(2 * M_PI - Margin - M_PI/2)];
        return num;
    }
}



@end
