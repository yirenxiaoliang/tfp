//
//  HQStarTextView.m
//  HuiJuHuaQi
//
//  Created by hq002 on 16/3/15.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQStarTextView.h"

@interface HQStarTextView (){
    BOOL _isEdit;
}

@end

@implementation HQStarTextView
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
        self.textAlignment = NSTextAlignmentCenter;
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
        
        self.textAlignment = NSTextAlignmentCenter;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textBeginEdit) name:UITextViewTextDidBeginEditingNotification object:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textEndEdit) name:UITextViewTextDidEndEditingNotification object:self];
    }
    return self;
}
- (void)textBeginEdit{
    // 重绘文字
    _isEdit = YES;
    [self setNeedsDisplay];
}
- (void)textEndEdit{
    // 重绘文字
    _isEdit = NO;
    [self setNeedsDisplay];
}
- (void)textChange{
    // 重绘文字
    _isEdit = YES;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // textView有文字
    if (self.hasText) return;
    // 没有文字需要绘制placeholder
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = self.font;
    attr[NSForegroundColorAttributeName] = self.placeholderColor ? self.placeholderColor : GrayTextColor;
    CGFloat width = [self sizeWithString:self.placeholder font:FONT(14) textWidth:rect.size.width].width;
    if (_isEdit) {
        [self.placeholder drawInRect:CGRectMake(5 + (rect.size.width - width)* 0.5 + 30, 8, rect.size.width, rect.size.height) withAttributes:attr];
    }else{
        [self.placeholder drawInRect:CGRectMake(5 + (rect.size.width - width)* 0.5 , 8, rect.size.width, rect.size.height) withAttributes:attr];
    }
    
    
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

- (CGSize)sizeWithString:(NSString *)textStr font:(UIFont *)textFont textWidth:(CGFloat)textWidth{
    
    CGSize size = [textStr boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:textFont,NSFontAttributeName, nil] context:nil].size;
    return size;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
