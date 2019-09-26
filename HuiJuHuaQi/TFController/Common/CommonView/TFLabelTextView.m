//
//  TFLabelTextView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/7.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFLabelTextView.h"
#import "TFCustomerOptionModel.h"
#import "TFDrewModel.h"

#define FontWord 14.0
#define LineSpacing 12.0
#define Margin (FontWord/2)
#define Top 6.0

@interface TFLabelTextView ()

/** models */
@property (nonatomic, strong) NSMutableArray *models;


@end

@implementation TFLabelTextView

-(NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
    }
    return self;
}

-(void)refreshTextViewWithOptions:(NSArray *)options{
    
    NSString *str = @"";
    
    for (TFCustomerOptionModel *model in options) {
        
        str = [str stringByAppendingString:[NSString stringWithFormat:@"    %@    ",model.label]];
        
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
    para.lineSpacing = LineSpacing;
    
    [dict setObject:FONT(FontWord) forKey:NSFontAttributeName];
    [dict setObject:para forKey:NSParagraphStyleAttributeName];
    
    
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:str attributes:dict];
    
    self.attributedText = attriStr;
    

    CGFloat height = (FontWord + LineSpacing/2.0);
    CGFloat length = 0.0;
    NSInteger index = 0;
    
    for (TFCustomerOptionModel *model in options) {
        
        CGSize size = [HQHelper sizeWithFont:FONT(FontWord) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:[NSString stringWithFormat:@"  %@  ",model.label]];
        length += (size.width + Margin);
        
        if (length > self.width) {
            
            NSInteger line = (NSInteger)((length/self.width) + 1);
            
            CGFloat sub = (length)/ self.width;
            NSInteger total = (NSInteger)sub;
            
            CGFloat subWidth = (sub - total) * self.width;
            
            for (NSInteger i = 0; i < line; i ++) {
                
                TFDrewModel *model = [[TFDrewModel alloc] init];
                
                if (i == 0) {// 第一个
                    
                    model.rect = CGRectMake(length - size.width, index * (FontWord + 5 * LineSpacing/4.0)+Top, self.width - (length - size.width), height);
                    model.type = DrewTypeLeft;
            
                }else if (i == line - 1){// 最后一个
                    
                    index ++;
                    model.rect = CGRectMake(0 , index * (FontWord + 5 * LineSpacing/4.0)+Top, subWidth, height);
                    model.type = DrewTypeRight;
                    
                    length = (subWidth + 2 * Margin);
                    
                }else{// 中间的
                    
                    index ++;
                    model.rect = CGRectMake(0, index * (FontWord + 5 * LineSpacing/4.0)+Top, self.width, height);
                    model.type = DrewTypeMiddle;
                }
                
                [self.models addObject:model];
                
            }
            
            
        }else{
            TFDrewModel *model = [[TFDrewModel alloc] init];
            model.rect = CGRectMake(length - size.width + Margin, index * (FontWord + 5 * LineSpacing/4.0)+Top, size.width, height);
            model.type = DrewTypeNormal;
            [self.models addObject:model];
            
            length += Margin;
        }
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    
    if (!self.hasText) return;

    /*画圆角矩形*/
    CGContextRef context = UIGraphicsGetCurrentContext();
    //通过贝塞尔曲线简易绘画
    CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
    
    for (TFDrewModel *model in self.models) {
        
        if (model.type == DrewTypeNormal) {
            
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:model.rect byRoundingCorners:(UIRectCornerTopLeft |UIRectCornerTopRight |UIRectCornerBottomRight|UIRectCornerBottomLeft) cornerRadii:CGSizeMake(rect.size.height/2, rect.size.height/2)];
            [path fill];
            
        }else if (model.type == DrewTypeLeft){
            
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:model.rect byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(rect.size.height/2, rect.size.height/2)];
            [path fill];
        }else if (model.type == DrewTypeRight){
            
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:model.rect byRoundingCorners:(UIRectCornerTopRight |UIRectCornerBottomRight) cornerRadii:CGSizeMake(rect.size.height/2, rect.size.height/2)];
            [path fill];
            
        }else{
            
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:model.rect];
            [path fill];
        }
        
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
