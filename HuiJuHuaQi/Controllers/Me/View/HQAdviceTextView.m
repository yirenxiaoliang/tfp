//
//  HQAdviceTextView.m
//  HuiJuHuaQi
//
//  Created by hq002 on 16/3/4.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQAdviceTextView.h"

@implementation HQAdviceTextView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return  self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}


- (void)textChange{
    // 重绘文字
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // textView有文字
    if (self.hasText) return;
    // 没有文字需要绘制placeholder
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = self.font;
    attr[NSForegroundColorAttributeName] = self.placeholderColor ? self.placeholderColor : GrayTextColor;
    
    CGRect  drawRect;
    
    CGFloat placeWidth = [HQHelper sizeWithFont:self.font maxSize:CGSizeMake(1000, 20) titleStr:self.placeholder].width;
    
    if (self.textAlignment == NSTextAlignmentCenter) {
        
        drawRect = CGRectMake((rect.size.width - placeWidth) / 2, 7, placeWidth, rect.size.height);
    }else if (self.textAlignment == NSTextAlignmentRight){
        
        drawRect = CGRectMake(rect.size.width - placeWidth, 7, placeWidth, rect.size.height);
    }else {
        
        drawRect = CGRectMake(5, 7, rect.size.width, rect.size.height);
    }
    
    [self.placeholder drawInRect:drawRect withAttributes:attr];
}


- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = [placeholder copy];
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font{
    [super setFont:font];
    [self setNeedsDisplay];
}
- (void)setText:(NSString *)text{
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}

//- (void)setSize:(CGSize)size{
//    [super setSize:size];
//    [self setNeedsDisplay];
//}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
