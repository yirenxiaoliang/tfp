//
//  HQWorkDetailTextView.m
//  HuiJuHuaQi
//
//  Created by hq002 on 16/3/10.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQWorkDetailTextView.h"

@implementation HQWorkDetailTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.editable = NO;// 不可编辑
        self.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);
        self.selectable = NO;// 不能选中,点击不能出现特殊文字添加背景
//         禁止滚动, 让文字完全显示出来
        self.scrollEnabled = NO;
        self.font = FONT(14);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
//        self.editable = NO;// 不可编辑
//        self.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);
//        self.selectable = NO;// 不能选中,点击不能出现特殊文字添加背景
        // 禁止滚动, 让文字完全显示出来
//        self.scrollEnabled = NO;
        self.font = FONT(14);
        
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
        
        drawRect = CGRectMake((rect.size.width - placeWidth) / 2, 8, placeWidth, rect.size.height);
    }else if (self.textAlignment == NSTextAlignmentRight){
        
        drawRect = CGRectMake(rect.size.width - placeWidth, 8, placeWidth, rect.size.height);
    }else {
        
        drawRect = CGRectMake(5, 8, rect.size.width, rect.size.height);
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

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
