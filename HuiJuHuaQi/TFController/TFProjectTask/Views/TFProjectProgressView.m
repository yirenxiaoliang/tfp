//
//  TFProjectProgressView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/9.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectProgressView.h"
#define Margin 0 * (M_PI/180)

@interface TFProjectProgressView()

/** rateLabel */
@property (nonatomic, weak) UILabel *rateLabel;

@end

@implementation TFProjectProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *rateLabel = [[UILabel alloc] initWithFrame:(CGRect){0,0,self.width,30}];
        [self addSubview:rateLabel];
        self.rateLabel = rateLabel;
        rateLabel.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = ClearColor;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        UILabel *rateLabel = [[UILabel alloc] initWithFrame:(CGRect){0,0,self.width,30}];
        [self addSubview:rateLabel];
        self.rateLabel = rateLabel;
        rateLabel.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = ClearColor;
    }
    return self;
}

- (void)setRate:(CGFloat)rate{
    _rate = rate;
    
    NSString *str = [NSString stringWithFormat:@"%.0f%@",rate*100,@"%"];
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
    [att addAttribute:NSForegroundColorAttributeName value:WhiteColor range:NSMakeRange(0, str.length)];
    [att addAttribute:NSFontAttributeName value:BFONT(20) range:NSMakeRange(0, str.length-1)];
    [att addAttribute:NSFontAttributeName value:BFONT(12) range:NSMakeRange(str.length-1, 1)];
    
    self.rateLabel.attributedText = att;

    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();//当前画笔
    
    CGContextSetLineWidth(context, 4);//线的宽度
    
    
    NSArray *rates = [self changeRate:self.rate];
    
    // 已完成的
    
    if (self.rate == 1.0) {
        CGContextSetRGBStrokeColor(context, 0x3a/255.0, 0xcf/255.0, 0xaa/255.0, 1.0);//画笔线的颜色
    }else{
        CGContextSetRGBStrokeColor(context, 0x3a/255.0, 0xcf/255.0, 0xaa/255.0, 1.0);//画笔线的颜色
    }
    
    CGContextAddArc(context, self.width/2, self.height/2, self.width/2-8, [rates[0] floatValue], [rates[1] floatValue], 0); //添加一个圆
    
    CGContextDrawPath(context, kCGPathStroke); //绘制路径
    
    // 未完成的
    CGContextSetRGBStrokeColor(context, 255.0/255.0, 255.0/255.0, 255.0/255.0, 0.4);//画笔线的颜色
    
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

-(void)layoutSubviews{
    [super layoutSubviews];
    self.rateLabel.center = CGPointMake(self.width/2, self.height/2);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
