//
//  TFTabBarView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/5/10.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTabBarView.h"

#define GreenViewWidth 20

@interface TFTabBarView ()

/** 按钮标题数组 */
@property (nonatomic, strong) NSArray *titles;
/** 按钮数组 */
@property (nonatomic, strong) NSMutableArray *buttons;

/** UIButton *button */
@property (nonatomic, weak) UIButton *selectButton;

/** UIView *greenView */
@property (nonatomic, weak) UIView *greenView;
@end


@implementation TFNumIndex

@end

@interface TFNumButton ()

@property (nonatomic, strong)  UILabel *numLabel;

@end


@implementation TFNumButton

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        UILabel *label = [HQHelper labelWithFrame:(CGRect){self.size.width - 20,5,16*2,16} text:@"" textColor:WhiteColor textAlignment:NSTextAlignmentCenter font:FONT(10)];
        self.numLabel = label;
        label.layer.cornerRadius = 8;
        label.layer.masksToBounds = YES;
        label.backgroundColor = RedColor;
        label.hidden = YES;
        [self addSubview:label];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self insertSubview:self.numLabel atIndex:self.subviews.count-1];
}

@end


@implementation TFTabBarView

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
- (instancetype)initWithCoder:(NSCoder *)coder withTitles:(NSArray *)titles
{
    self = [super initWithCoder:coder];
    if (self) {
        self.titles = titles;
        
        [self setupChildWithTitles:titles];
        self.backgroundColor = WhiteColor;
    }
    return self;
}



- (void)refreshNumWithNumbers:(NSArray <TFNumIndex> *)numbers{
    
    
    for (TFNumIndex *numIndex in numbers) {
        
        if ([numIndex.type integerValue] > self.buttons.count) {
            return;
        }
        
        TFNumButton *button = self.buttons[[numIndex.type integerValue]];
        
        button.numLabel.hidden = NO;
        NSString *str = [NSString stringWithFormat:@"%@",numIndex.count];
        button.numLabel.text = str;
        
        if (str.length <= 1) {
            button.numLabel.frame = CGRectMake(button.width/2 + 20,8,16,16);
        }else if (str.length <= 2){
            button.numLabel.frame = CGRectMake(button.width/2 + 20,8,20,16);
        }else{
            button.numLabel.frame = CGRectMake(button.width/2 + 20,8,30,16);
        }
        
//        CGSize size = [HQHelper sizeWithFont:FONT(10) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:str];
//        button.numLabel.frame = CGRectMake(button.width/2 + 20,8,size.width + 10,16);
        
        if ([numIndex.count integerValue] <= 0) {
            button.numLabel.text = @"";
            button.numLabel.hidden = YES;
        }
    }
    
}

- (void)setupChildWithTitles:(NSArray *)titles{
    
    CGFloat btnW = SCREEN_WIDTH/self.titles.count;
    for (NSInteger i = 0; i < titles.count; i++) {
        
//        UIButton *button = [HQHelper buttonWithFrame:(CGRect){btnW*i,0,btnW,self.height} target:self action:@selector(butonClicked:)];
        TFNumButton *button = [[TFNumButton alloc] initWithFrame:(CGRect){btnW*i,0,btnW,self.height}];
        [button addTarget:self action:@selector(butonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitle:titles[i] forState:UIControlStateHighlighted];
        [button setTitle:titles[i] forState:UIControlStateSelected];
        button.titleLabel.font = FONT(16);
        [button setTitleColor:LightBlackTextColor forState:UIControlStateNormal];
        [button setTitleColor:LightBlackTextColor forState:UIControlStateHighlighted];
        [button setTitleColor:GreenColor forState:UIControlStateSelected];
        button.tag = 0x123 + i;
        
        if (i==0) {
            button.selected = YES;
            button.titleLabel.font = FONT(18);
            self.selectButton = button;
        }
        [self.buttons addObject:button];
    }
    
    UIView *greenView = [[UIView alloc] initWithFrame:(CGRect){(btnW-GreenViewWidth)/2,0.5,GreenViewWidth,3}];
    greenView.backgroundColor = GreenColor;
    [self addSubview:greenView];
    self.greenView = greenView;
    
    UIView *sepeView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,0.5}];
    sepeView.backgroundColor = CellSeparatorColor;
    [self addSubview:sepeView];
}

- (void)butonClicked:(UIButton *)button{
    
    NSInteger index = button.tag - 0x123;
    
    self.selectButton.selected = NO;
    self.selectButton.titleLabel.font = FONT(16);
    
    button.selected = YES;
    button.titleLabel.font = FONT(18);
    self.selectButton = button;
    
    _selectIndex = index;
    
    CGFloat width = (SCREEN_WIDTH/self.titles.count-GreenViewWidth)/2;
    
    [UIView animateWithDuration:0.15 animations:^{
        
        self.greenView.x = SCREEN_WIDTH/self.titles.count * index + width;
    }];
    
    if ([self.delegate respondsToSelector:@selector(tabBarView:didSelectIndex:)]) {
        [self.delegate tabBarView:self didSelectIndex:index];
    }
}

-(void)setSelectIndex:(NSInteger)selectIndex{
    
    _selectIndex = selectIndex;
    
    if (selectIndex > self.titles.count-1 || selectIndex < 0) {
        
        return;
    }
    
    UIButton *button = self.buttons[selectIndex];
    
    [self butonClicked:button];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
