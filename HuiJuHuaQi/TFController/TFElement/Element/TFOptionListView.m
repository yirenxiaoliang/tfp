//
//  TFOptionListView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/8/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFOptionListView.h"
#import "TFTagLabel.h"

#define Margin 8
#define Height 18
#define PlacehoderStringLeft @"%"
#define PlacehoderStringRight @"$"

@interface TFOptionListView ()

/** labels */
@property (nonatomic, strong) NSMutableArray *labels;



@end

@implementation TFOptionListView

-(NSMutableArray *)labels{
    if (!_labels) {
        _labels = [NSMutableArray array];
    }
    return _labels;
}


-(void)refreshWithModel:(TFCustomerRowsModel *)model edit:(BOOL)edit{
    
    for (TFTagLabel *label in self.labels) {
        [label removeFromSuperview];
    }
    [self.labels removeAllObjects];
    
    CGFloat width = SCREEN_WIDTH - 60;
    if ([model.field.structure isEqualToString:@"1"]) {
        width = SCREEN_WIDTH - 60 - 100;
    }
    if (edit) {
        width -= 30;
    }
    for (NSInteger i = 0; i < model.selects.count; i++) {
        TFCustomerOptionModel *option = model.selects[i];
        TFTagLabel *label = [[TFTagLabel alloc] init];
        [self addSubview:label];
        [self.labels addObject:label];
        
        if (option.color && ![option.color isEqualToString:@""] && ![[option.color uppercaseString] isEqualToString:@"#FFFFFF"]) {
            
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [HQHelper colorWithHexString:option.color];
            label.layer.masksToBounds = YES;
            label.layer.cornerRadius = 4;
            label.font = FONT(10);
            label.textColor = WhiteColor;
            
            NSString *text = [NSString stringWithFormat:@"%@%@%@",PlacehoderStringLeft,option.label,PlacehoderStringRight];
            CGSize size = [HQHelper sizeWithFont:FONT(10) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:text];
            label.labelWidth = size.width > width ? width : size.width;
            
            NSRange range1 = [text rangeOfString:PlacehoderStringLeft];
            NSRange range2 = [text rangeOfString:PlacehoderStringRight];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
            [str addAttribute:NSForegroundColorAttributeName value:ClearColor range:range1];
            [str addAttribute:NSForegroundColorAttributeName value:ClearColor range:range2];
            label.attributedText = str;
            
        }else{
            
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = ClearColor;
            label.layer.masksToBounds = NO;
            label.layer.cornerRadius = 0;
            label.font = FONT(14);
            label.textColor = BlackTextColor;
            
            
            NSString *text = [NSString stringWithFormat:@"%@  ",option.label];
            if (i == model.selects.count-1) {
                text = [NSString stringWithFormat:@"%@",option.label];
            }
            CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:text];
            label.labelWidth = size.width > width ? width : size.width;
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
            label.attributedText = str;
            
        }
    }
}
-(void)refreshWithOptions:(NSArray *)options{
    
    for (TFTagLabel *label in self.labels) {
        [label removeFromSuperview];
    }
    [self.labels removeAllObjects];
    
    for (NSInteger i = 0; i < options.count; i++) {
        TFCustomerOptionModel *option = options[i];
        TFTagLabel *label = [[TFTagLabel alloc] init];
        [self addSubview:label];
        [self.labels addObject:label];
        
        if (option.color && ![option.color isEqualToString:@""] && ![[option.color uppercaseString] isEqualToString:@"#FFFFFF"]) {
            
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [HQHelper colorWithHexString:option.color];
            label.layer.masksToBounds = YES;
            label.layer.cornerRadius = 4;
            label.font = FONT(10);
            label.textColor = WhiteColor;
            
            NSString *text = [NSString stringWithFormat:@"%@%@%@",PlacehoderStringLeft,option.label,PlacehoderStringRight];
            CGSize size = [HQHelper sizeWithFont:FONT(10) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:text];
            label.labelWidth = size.width > SCREEN_WIDTH-60 ? SCREEN_WIDTH-60 : size.width;
            
            NSRange range1 = [text rangeOfString:PlacehoderStringLeft];
            NSRange range2 = [text rangeOfString:PlacehoderStringRight];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
            [str addAttribute:NSForegroundColorAttributeName value:ClearColor range:range1];
            [str addAttribute:NSForegroundColorAttributeName value:ClearColor range:range2];
            label.attributedText = str;
            
        }else{
            
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = ClearColor;
            label.layer.masksToBounds = NO;
            label.layer.cornerRadius = 0;
            label.font = FONT(14);
            label.textColor = BlackTextColor;
            
            
            NSString *text = [NSString stringWithFormat:@"%@  ",option.label];
            if (i == options.count-1) {
                text = [NSString stringWithFormat:@"%@",option.label];
            }
            CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:text];
            label.labelWidth = size.width > SCREEN_WIDTH-60 ? SCREEN_WIDTH-60 : size.width;
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
            label.attributedText = str;
            
        }
    }
}

/** 高度 */
+(CGFloat)refreshOptionListViewHeightWithModel:(TFCustomerRowsModel *)model  edit:(BOOL)edit{
    
    CGFloat height = 0;
    
    CGFloat width = SCREEN_WIDTH - 60;
    if ([model.field.structure isEqualToString:@"1"]) {
        width = SCREEN_WIDTH - 60 - 70;
    }
    if (edit) {
        width -= 40;
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < model.selects.count; i++) {
        TFCustomerOptionModel *option = model.selects[i];
        TFTagLabel *label = [[TFTagLabel alloc] init];
        [arr addObject:label];
        if (option.color && ![option.color isEqualToString:@""] && ![[option.color uppercaseString] isEqualToString:@"#FFFFFF"]) {
            
            NSString *text = [NSString stringWithFormat:@"%@%@%@",PlacehoderStringLeft,option.label,PlacehoderStringRight];
            CGSize size = [HQHelper sizeWithFont:FONT(10) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:text];
            label.labelWidth = size.width > width ? width : size.width;
            
        }else{
            
            NSString *text = [NSString stringWithFormat:@"%@  ",option.label];
            if (i == model.selects.count-1) {
                text = [NSString stringWithFormat:@"%@",option.label];
            }
            CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:text];
            label.labelWidth = size.width > width ? width : size.width;
            
        }
    }
    
    
    CGFloat X = 0;
    CGFloat Y = 0;
    
    for (TFTagLabel *label in arr) {
        
        if (X + label.labelWidth + Margin <= width) {// 同行
            
            label.frame = CGRectMake(X, Y, label.labelWidth, Height);
            X += (label.labelWidth + Margin);
            
        }else{// 换行
            
            Y += (Height + Margin);
            X = 0;
            label.frame = CGRectMake(X, Y, label.labelWidth, Height);
            X += (label.labelWidth + Margin);
        }
        
    }
    
    height = Y+(Height);
    
    return height;
}

/** 高度 */
+(CGFloat)refreshOptionListViewHeightWithOptions:(NSArray *)options maxWidth:(CGFloat)maxWidth{
    
    CGFloat height = 0;
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < options.count; i++) {
        TFCustomerOptionModel *option = options[i];
        TFTagLabel *label = [[TFTagLabel alloc] init];
        [arr addObject:label];
        if (option.color && ![option.color isEqualToString:@""] && ![[option.color uppercaseString] isEqualToString:@"#FFFFFF"]) {
            
            NSString *text = [NSString stringWithFormat:@"%@%@%@",PlacehoderStringLeft,option.label,PlacehoderStringRight];
            CGSize size = [HQHelper sizeWithFont:FONT(10) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:text];
            label.labelWidth = size.width > maxWidth ? maxWidth : size.width;
            
        }else{
            
            NSString *text = [NSString stringWithFormat:@"%@  ",option.label];
            if (i == options.count-1) {
                text = [NSString stringWithFormat:@"%@",option.label];
            }
            CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:text];
            label.labelWidth = size.width > maxWidth ? maxWidth : size.width;
            
        }
    }
    
    
    CGFloat X = 0;
    CGFloat Y = 0;
    
    for (TFTagLabel *label in arr) {
        
        if (X + label.labelWidth + Margin <= maxWidth) {// 同行
            
            label.frame = CGRectMake(X, Y, label.labelWidth, Height);
            X += (label.labelWidth + Margin);
            
        }else{// 换行
            
            Y += (Height + Margin);
            X = 0;
            label.frame = CGRectMake(X, Y, label.labelWidth, Height);
            X += (label.labelWidth + Margin);
        }
        
    }
    
    height = Y+(Height);
    
    return height;
}
/** 高度 */
+(CGFloat)refreshOptionListViewHeightWithOptions:(NSArray *)options{
    
    CGFloat height = 0;
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < options.count; i++) {
        TFCustomerOptionModel *option = options[i];
        TFTagLabel *label = [[TFTagLabel alloc] init];
        [arr addObject:label];
        if (option.color && ![option.color isEqualToString:@""] && ![[option.color uppercaseString] isEqualToString:@"#FFFFFF"]) {
            
            NSString *text = [NSString stringWithFormat:@"%@%@%@",PlacehoderStringLeft,option.label,PlacehoderStringRight];
            CGSize size = [HQHelper sizeWithFont:FONT(10) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:text];
            label.labelWidth = size.width > SCREEN_WIDTH-60 ? SCREEN_WIDTH-60 : size.width;
            
        }else{
            
            NSString *text = [NSString stringWithFormat:@"%@  ",option.label];
            if (i == options.count-1) {
                text = [NSString stringWithFormat:@"%@",option.label];
            }
            CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:text];
            label.labelWidth = size.width > SCREEN_WIDTH-60 ? SCREEN_WIDTH-60 : size.width;
            
        }
    }
    
    
    CGFloat X = 0;
    CGFloat Y = 0;
    
    for (TFTagLabel *label in arr) {
        
        if (X + label.labelWidth + Margin <= SCREEN_WIDTH-60) {// 同行
            
            label.frame = CGRectMake(X, Y, label.labelWidth, Height);
            X += (label.labelWidth + Margin);
            
        }else{// 换行
            
            Y += (Height + Margin);
            X = 0;
            label.frame = CGRectMake(X, Y, label.labelWidth, Height);
            X += (label.labelWidth + Margin);
        }
        
    }
    
    height = Y+(Height);
    
    return height;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat X = 0;
    CGFloat Y = 4;
    
    for (TFTagLabel *label in self.labels) {
        
        if (X + label.labelWidth + Margin <= self.width) {// 同行
            
            label.frame = CGRectMake(X, Y, label.labelWidth, Height);
            X += (label.labelWidth + Margin);
            
        }else{// 换行
            
            Y += (Height + Margin);
            X = 0;
            label.frame = CGRectMake(X, Y, label.labelWidth, Height);
            X += (label.labelWidth + Margin);
        }
        
    }
    
//    if ([self.delegate respondsToSelector:@selector(tagListViewHeight:)]) {
//        [self.delegate tagListViewHeight:Y+(Height + Margin)];
//    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
