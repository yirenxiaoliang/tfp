//
//  TFTagListView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/28.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTagListView.h"
#import "TFTagLabel.h"

#define Margin 8
#define Height 18
#define PlacehoderStringLeft @"%"
#define PlacehoderStringRight @"$"

@interface TFTagListView ()

/** labels */
@property (nonatomic, strong) NSMutableArray *labels;



@end

@implementation TFTagListView

-(NSMutableArray *)labels{
    if (!_labels) {
        _labels = [NSMutableArray array];
    }
    return _labels;
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
            label.labelWidth = size.width > self.width-30 ? self.width-30 : size.width;
            
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
            label.font = FONT(15);
            label.textColor = BlackTextColor;
            
            
            NSString *text = [NSString stringWithFormat:@"%@、",option.label];
            if (i == options.count-1) {
                text = [NSString stringWithFormat:@"%@",option.label];
            }
            CGSize size = [HQHelper sizeWithFont:FONT(15) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:text];
            label.labelWidth = size.width > self.width-30 ? self.width-30 : size.width;
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
            label.attributedText = str;
            
        }
    }
}


/** 刷新知识库选项 */
-(void)refreshKnowledgeWithOptions:(NSArray *)options{
    
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
            label.backgroundColor = BackGroudColor;
            label.layer.masksToBounds = YES;
            label.layer.cornerRadius = Height/2;
            label.font = FONT(10);
            label.textColor = GrayTextColor;
            
            NSString *text = [NSString stringWithFormat:@"%@%@%@",PlacehoderStringLeft,option.label,PlacehoderStringRight];
            CGSize size = [HQHelper sizeWithFont:FONT(10) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:text];
            label.labelWidth = size.width > self.width-30 ? self.width-30 : size.width;
            
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
            label.font = FONT(15);
            label.textColor = BlackTextColor;
            
            
            NSString *text = [NSString stringWithFormat:@"%@、",option.label];
            if (i == options.count-1) {
                text = [NSString stringWithFormat:@"%@",option.label];
            }
            CGSize size = [HQHelper sizeWithFont:FONT(15) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:text];
            label.labelWidth = size.width > self.width-30 ? self.width-30 : size.width;
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
            label.attributedText = str;
            
        }
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat X = 0;
    CGFloat Y = 0;
    
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
    
    if ([self.delegate respondsToSelector:@selector(tagListViewHeight:)]) {
        [self.delegate tagListViewHeight:Y+(Height + Margin)];
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
