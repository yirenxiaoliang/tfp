//
//  TFTwoBtnsView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/5/12.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTwoBtnsView.h"

@interface TFTwoBtnsView ()

/** 按钮标题数组 */
@property (nonatomic, strong) NSArray *titles;
/** 按钮数组 */
@property (nonatomic, strong) NSMutableArray *buttons;
@end

@implementation TFTwoBtnsView

-(NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

-(instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray *)titles{
    
    if (self = [super initWithFrame:frame]) {
        self.titles = titles;
        
        [self setupChildWithTitles:titles];
        self.backgroundColor = WhiteColor;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame withTitles1:(NSArray *)titles{
    
    if (self = [super initWithFrame:frame]) {
        self.titles = titles;
        
        [self setupChildWithTitles1:titles];
        self.backgroundColor = WhiteColor;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame withImages:(NSArray *)images{
    
    if (self = [super initWithFrame:frame]) {
        self.titles = images;
        
        [self setupChildWithImages:images];
        self.backgroundColor = WhiteColor;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame withModels:(NSArray *)models{
    
    if (self = [super initWithFrame:frame]) {
        self.titles = models;
        
        [self setupChildWithModels:models];
        self.backgroundColor = WhiteColor;
    }
    return self;
}


- (void)setupChildWithImages:(NSArray *)images{
    
    CGFloat btnW = (self.width-1.5)/self.titles.count;
    for (NSInteger i = 0; i < images.count; i++) {
        TFTwoBtnsModel *model = images[i];
        
        UIButton *button = [HQHelper buttonWithFrame:(CGRect){(btnW + 0.5)*i,0,btnW,self.height} target:self action:@selector(butonClicked:)];
        [self addSubview:button];
        [button setImage:[UIImage imageNamed:model.title] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:model.title] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:model.title] forState:UIControlStateSelected];
        button.titleLabel.font = model.font;
        [button setTitleColor:model.color forState:UIControlStateNormal];
        [button setTitleColor:model.color forState:UIControlStateHighlighted];
        button.tag = 0x123 + i;
        
        [self.buttons addObject:button];
        
        
        UIView *sepeview = [[UIView alloc] initWithFrame:(CGRect){(btnW + 0.5)* i+btnW,0,0.5,20}];
        sepeview.backgroundColor = BackGroudColor;
        sepeview.centerY = self.height/2;
        [self addSubview:sepeview];
        
        if (self.titles.count-1 == i) {
            sepeview.hidden = YES;
        }
    }
    
    UIView *sepeView = [[UIView alloc] initWithFrame:(CGRect){0,0,self.width,0.5}];
    sepeView.backgroundColor = CellSeparatorColor;
    [self addSubview:sepeView];
}


- (void)setupChildWithTitles:(NSArray *)titles{
    
    CGFloat btnW = (self.width-1.5)/self.titles.count;
    for (NSInteger i = 0; i < titles.count; i++) {
        TFTwoBtnsModel *model = titles[i];
        
        UIButton *button = [HQHelper buttonWithFrame:(CGRect){(btnW + 0.5)*i,0,btnW,self.height} target:self action:@selector(butonClicked:)];
        [self addSubview:button];
        [button setTitle:model.title forState:UIControlStateNormal];
        [button setTitle:model.title forState:UIControlStateHighlighted];
        [button setTitle:model.title forState:UIControlStateSelected];
        button.titleLabel.font = model.font;
        [button setTitleColor:model.color forState:UIControlStateNormal];
        [button setTitleColor:model.color forState:UIControlStateHighlighted];
        button.tag = 0x123 + i;
        
        [self.buttons addObject:button];
        
        
        UIView *sepeview = [[UIView alloc] initWithFrame:(CGRect){(btnW + 0.5)* i+btnW,0,0.5,20}];
        sepeview.backgroundColor = BackGroudColor;
        sepeview.centerY = self.height/2;
        [self addSubview:sepeview];
        
        if (self.titles.count-1 == i) {
            sepeview.hidden = YES;
        }
    }
    
    UIView *sepeView = [[UIView alloc] initWithFrame:(CGRect){0,0,self.width,0.5}];
    sepeView.backgroundColor = CellSeparatorColor;
    [self addSubview:sepeView];
}

- (void)setupChildWithTitles1:(NSArray *)titles{
    
    //    CGFloat btnW = (self.width-1.5)/self.titles.count;
    CGFloat btnW = 70;
    for (NSInteger i = 0; i < titles.count; i++) {
        TFTwoBtnsModel *model = titles[i];
        
        //        UIButton *button = [HQHelper buttonWithFrame:(CGRect){(btnW + 0.5)*i,0,btnW,self.height} target:self action:@selector(butonClicked:)];
        
        UIButton *button = [HQHelper buttonWithFrame:(CGRect){15 + (70 + 20) * i,(self.height-28)/2,btnW,28} target:self action:@selector(butonClicked:)];
        [self addSubview:button];
        [button setTitle:model.title forState:UIControlStateNormal];
        [button setTitle:model.title forState:UIControlStateHighlighted];
        [button setTitle:model.title forState:UIControlStateSelected];
        button.titleLabel.font = model.font;
        [button setTitleColor:model.color forState:UIControlStateNormal];
        [button setTitleColor:model.color forState:UIControlStateHighlighted];
        button.tag = 0x123 + i;
        
        [self.buttons addObject:button];
        button.layer.cornerRadius = 4;
        button.layer.masksToBounds = YES;
        button.backgroundColor = model.color;
        [button setTitleColor:WhiteColor forState:UIControlStateNormal];
        [button setTitleColor:WhiteColor forState:UIControlStateHighlighted];
        
        
        //        UIView *sepeview = [[UIView alloc] initWithFrame:(CGRect){(btnW + 0.5)* i+btnW,0,0.5,20}];
        //        sepeview.backgroundColor = BackGroudColor;
        //        sepeview.centerY = self.height/2;
        //        [self addSubview:sepeview];
        //
        //        if (self.titles.count-1 == i) {
        //            sepeview.hidden = YES;
        //        }
    }
    
    UIView *sepeView = [[UIView alloc] initWithFrame:(CGRect){0,0,self.width,0.5}];
    sepeView.backgroundColor = CellSeparatorColor;
    [self addSubview:sepeView];
}


- (void)setupChildWithModels:(NSArray *)models{
    
    CGFloat btnW = (self.width-1.5)/self.titles.count;
    for (NSInteger i = 0; i < models.count; i++) {
        TFTwoBtnsModel *model = models[i];
        
        UIButton *button = [HQHelper buttonWithFrame:(CGRect){(btnW + 0.5)*i,0,btnW,self.height} target:self action:@selector(butonClicked:)];
        [self addSubview:button];
        [button setTitle:model.title forState:UIControlStateNormal];
        [button setTitle:model.title forState:UIControlStateHighlighted];
        [button setTitle:model.title forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:model.image] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:model.image] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:model.image] forState:UIControlStateSelected];
        button.titleLabel.font = model.font;
        [button setTitleColor:model.color forState:UIControlStateNormal];
        [button setTitleColor:model.color forState:UIControlStateHighlighted];
        button.tag = 0x123 + i;
        
        [self.buttons addObject:button];
        
        
        UIView *sepeview = [[UIView alloc] initWithFrame:(CGRect){(btnW + 0.5)* i+btnW,0,0.5,20}];
        sepeview.backgroundColor = BackGroudColor;
        sepeview.centerY = self.height/2;
        [self addSubview:sepeview];
        
        if (self.titles.count-1 == i) {
            sepeview.hidden = YES;
        }
    }
    
    UIView *sepeView = [[UIView alloc] initWithFrame:(CGRect){0,0,self.width,0.5}];
    sepeView.backgroundColor = CellSeparatorColor;
    [self addSubview:sepeView];
}


- (void)butonClicked:(UIButton *)button{
    
    NSInteger index = button.tag - 0x123;
    
    if ([self.delegate respondsToSelector:@selector(twoBtnsView:didSelectIndex:)]) {
        [self.delegate twoBtnsView:self didSelectIndex:index];
    }
    if ([self.delegate respondsToSelector:@selector(twoBtnsView:didSelectModel:)]) {
        [self.delegate twoBtnsView:self didSelectModel:self.titles[index]];
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
