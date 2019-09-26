//
//  TFReferanceModelView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/7/27.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFReferanceModelView.h"
#import "TFRelevanceTradeModel.h"

#define Margin 15
#define Height 40
@interface TFReferanceModelView ()

/** scrollView */
@property (nonatomic, weak) UIScrollView *scrollView;

/** buttons */
@property (nonatomic, strong) NSMutableArray *buttons;

/** models */
@property (nonatomic, strong) NSArray *models;


@end

@implementation TFReferanceModelView

-(NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIButton *disBtn = [HQHelper buttonWithFrame:(CGRect){0,0,50,50} normalImageStr:@"关闭" highImageStr:@"关闭" target:self action:@selector(dismiss)];
        [self addSubview:disBtn];
        
        UILabel *title = [HQHelper labelWithFrame:(CGRect){15,CGRectGetMaxY(disBtn.frame),100,30} text:@"所有关联模块" textColor:BlackTextColor textAlignment:NSTextAlignmentLeft font:FONT(16)];
        [self addSubview:title];
        
        UILabel *desc = [HQHelper labelWithFrame:(CGRect){CGRectGetMaxX(title.frame),CGRectGetMaxY(disBtn.frame),100,30} text:@"点击进入模块" textColor:GrayTextColor textAlignment:NSTextAlignmentLeft font:FONT(12)];
        [self addSubview:desc];
        
        UIView *line = [[UIView alloc] initWithFrame:(CGRect){0,CGRectGetMaxY(title.frame),self.width,0.5}];
        line.backgroundColor = BackGroudColor;
        [self addSubview:line];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:(CGRect){0,CGRectGetMaxY(line.frame),self.width,SCREEN_HEIGHT-CGRectGetMaxY(line.frame)}];
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        self.backgroundColor = WhiteColor;
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeView:)];
        swipe.direction = UISwipeGestureRecognizerDirectionDown;
        [self addGestureRecognizer:swipe];
        
        UISwipeGestureRecognizer *swipe1 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeView:)];
        swipe1.direction = UISwipeGestureRecognizerDirectionUp;
        [self addGestureRecognizer:swipe1];
    }
    return self;
}

- (void)swipeView:(UISwipeGestureRecognizer *)swipe{
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.bottom = 0;
            
        }completion:^(BOOL finished) {
            
            [self removeFromSuperview];
        }];
        
    }else{
        [self dismiss];
    }
}

- (void)dismiss{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.top = SCREEN_HEIGHT;
        
    }completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

+(instancetype)referanceModelView{
    
    TFReferanceModelView *view = [[TFReferanceModelView alloc] initWithFrame:(CGRect){0,20,SCREEN_WIDTH,SCREEN_HEIGHT}];
    return view;
}

-(void)refreshReferanceViewWithModels:(NSArray *)models{
    
    for (UIButton *btn in self.buttons) {
        [btn removeFromSuperview];
    }
    [self.buttons removeAllObjects];
    self.models = models;
    
    for (NSInteger i = 0; i < models.count; i ++) {
        TFRelevanceTradeModel *model = models[i];
        CGSize size = [HQHelper sizeWithFont:FONT(16) maxSize:(CGSize){self.width - 2*Margin,MAXFLOAT} titleStr:model.moduleLabel?:model.chinese_name];
        
        CGFloat labelWidth = size.width;
        CGFloat labelHeight = size.height+16;
        if (labelWidth < 75 ) {
            labelWidth = 75;
        }else if (labelWidth > self.width - 2*Margin){
            labelWidth = self.width - 2*Margin;
        }else{
            labelWidth += Margin;
        }
        if (labelHeight < 40) {
            labelHeight = 40;
        }
        
        model.width = [NSString stringWithFormat:@"%.0f",labelWidth];
        model.height = [NSString stringWithFormat:@"%.0f",labelHeight];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        button.titleLabel.numberOfLines = 0;
        [button setTitle:[NSString stringWithFormat:@"%@",model.moduleLabel?:model.chinese_name] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"%@",model.moduleLabel?:model.chinese_name] forState:UIControlStateHighlighted];
        [self.buttons addObject:button];
        button.titleLabel.font = FONT(16);
        [button setTitleColor:BlackTextColor forState:UIControlStateNormal];
        [button setTitleColor:BlackTextColor forState:UIControlStateHighlighted];
        button.backgroundColor = BackGroudColor;
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 4;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [self.scrollView addSubview:button];
        
    }
}

- (void)buttonClicked:(UIButton *)button{
    NSInteger tag = button.tag;
    if ([self.delegate respondsToSelector:@selector(referanceModelViewDidReferance:)]) {
        [self.delegate referanceModelViewDidReferance:self.models[tag]];
    }
    [self dismiss];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat X = Margin;
    CGFloat Y = Margin;
    
    for (NSInteger i = 0; i < self.buttons.count; i++) {
        TFRelevanceTradeModel *label = self.models[i];
        UIButton *button = self.buttons[i];
        if (X + [label.width floatValue] + Margin <= self.width) {// 同行
            
            button.frame = CGRectMake(X, Y, [label.width floatValue], [label.height floatValue]);
            X += ([label.width floatValue] + Margin);
            
        }else{// 换行
            if (i-1 >= 0) {
                TFRelevanceTradeModel *label1 = self.models[i-1];
                Y += ([label1.height floatValue] + Margin);
            }
            X = Margin;
            button.frame = CGRectMake(X, Y, [label.width floatValue],  [label.height floatValue]);
            X += ([label.width floatValue] + Margin);
        }
        
    }
    
    TFRelevanceTradeModel *label = self.models.lastObject;
    CGFloat totalHeight = Y+([label.height floatValue] + Margin);
    if (totalHeight > SCREEN_HEIGHT-100) {
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, totalHeight);
    }
}

-(void)showAnimation{
    
    self.top = SCREEN_HEIGHT;
    [KeyWindow addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.top = TopM + 20;
    }];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
