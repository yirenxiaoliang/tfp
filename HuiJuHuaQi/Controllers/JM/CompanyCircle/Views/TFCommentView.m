//
//  TFCommentView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/19.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCommentView.h"

@interface TFCommentView ()

/** buttons */
@property (nonatomic, strong) NSMutableArray *buttons;

/** lines */
@property (nonatomic, strong) NSMutableArray *lines;

/** heartBtn */
@property (nonatomic, weak) UIButton *heartBtn;
@end

@implementation TFCommentView

-(NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}
-(NSMutableArray *)lines{
    if (!_lines) {
        _lines = [NSMutableArray array];
    }
    return _lines;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChildView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupChildView];
    }
    return self;
}

- (void)setupChildView{
    
    NSArray *images = @[@"共享circle",@"点赞circle",@"评论circle"];
    NSArray *names = @[@" 共享",@" 赞",@" 评论"];
    
    for (NSInteger i = 0; i < 3; i ++) {
        
        UIButton *button = [HQHelper buttonWithFrame:CGRectZero target:self action:@selector(buttonClicked:)];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateHighlighted];
        [button setTitle:names[i] forState:UIControlStateNormal];
        [button setTitle:names[i] forState:UIControlStateHighlighted];
        [self addSubview:button];
        [self.buttons addObject:button];
        button.titleLabel.font = FONT(14);
        button.tag = 0x222 + i;
        if (i == 1) {
            self.heartBtn = button;
            [button setTitle:@"取消" forState:UIControlStateSelected];
        }
    }
    
    for (NSInteger i = 0; i < 2; i ++) {
        UIView *line = [[UIView alloc] init];
        [self addSubview:line];
        line.backgroundColor = LightBlackTextColor;
        [self.lines addObject:line];
    }
    
    self.backgroundColor = ExtraLightBlackTextColor;
    self.size = CGSizeMake(255, 40);
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}

- (void)show{
    
    self.hidden = NO;
    self.width = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.width = 255;
        self.right = SCREEN_WIDTH - 45;
    }];
}

- (void)dismiss{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.width = 0;
        self.right = SCREEN_WIDTH - 45;
    }completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

-(void)setGood:(BOOL)good{
    _good = good;
    
    self.heartBtn.selected = good;
    
}

- (void)buttonClicked:(UIButton *)button{
    
    [self dismiss];
    
    switch (button.tag - 0x222) {
        case 0:
        {
            if ([self.delegate respondsToSelector:@selector(commentViewDidClickedShareBtn:)]) {
                [self.delegate commentViewDidClickedShareBtn:button];
            }
        }
            break;
        case 1:
        {
            if ([self.delegate respondsToSelector:@selector(commentViewDidClickedGoodBtn:)]) {
                [self.delegate commentViewDidClickedGoodBtn:button];
            }        }
            break;
        case 2:
        {
            if ([self.delegate respondsToSelector:@selector(commentViewDidClickedCommentBtn:)]) {
                [self.delegate commentViewDidClickedCommentBtn:button];
            }        }
            break;
            
        default:
            break;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    for (NSInteger i = 0; i < self.buttons.count; i ++) {
        UIButton *button = self.buttons[i];
        button.frame = CGRectMake(85*i, 0, 85, 40);
    }
    
    for (NSInteger i = 0; i < self.lines.count; i++) {
        
        UIView *view = self.lines[i];
        view.frame = CGRectMake(85*(i+1), 10, 1, 20);
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
