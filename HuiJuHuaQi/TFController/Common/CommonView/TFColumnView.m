
//
//  TFColumnView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/6.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFColumnView.h"

@interface TFColumnView ()

/** line */
@property (nonatomic, weak) UIView *line;

@end

@implementation TFColumnView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIView *top = [[UIView alloc] initWithFrame:(CGRect){0,0,self.width,8}];
        [self addSubview:top];
        top.backgroundColor = BackGroudColor;
        
        UILabel *label = [HQHelper labelWithFrame:(CGRect){15,8,SCREEN_WIDTH-100,40} text:[NSString stringWithFormat:@""] textColor:HexColor(0x505a6a) textAlignment:NSTextAlignmentLeft font:BFONT(14)];
        label.backgroundColor = WhiteColor;
        label.layer.masksToBounds = YES;
        [self addSubview:label];
        self.titleLebel = label;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        button.frame = CGRectMake(self.width-60, 8, 60, 40);
//        [button setTitle:@"收起" forState:UIControlStateNormal];
//        [button setTitle:@"展开" forState:UIControlStateHighlighted];
//        [button setTitle:@"展开" forState:UIControlStateSelected];
        [button setImage:IMG(@"custom收起") forState:UIControlStateNormal];
        [button setImage:IMG(@"custom展开") forState:UIControlStateSelected];
        button.titleLabel.font = FONT(14);
        [button setTitleColor:GreenColor forState:UIControlStateNormal];
        [button setTitleColor:GreenColor forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(addClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.spreadBtn = button;
        
        UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,self.height-0.5,self.width,0.5}];
        [self addSubview:view];
        view.backgroundColor = HexColor(0xd5d5d5);
        self.line = view;
        
        UIView *view1 = [[UIView alloc] initWithFrame:(CGRect){0,21,3,14}];
        [self addSubview:view1];
        view1.backgroundColor = HexColor(0xb6bac2);
        
        self.backgroundColor = WhiteColor;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)addClicked:(UIButton *)button{
    
    button.selected = !button.selected;
    if (button.selected) {
        self.line.hidden = YES;
    }else{
        self.line.hidden = NO;
    }
    if ([self.delegate respondsToSelector:@selector(columnView:isSpread:)]) {
        [self.delegate columnView:self isSpread:button.selected?@"1":@"0"];
    }
}

+ (instancetype)columnView{
    
    TFColumnView *view = [[TFColumnView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,48}];
    
    return view;
}

-(void)setIsSpread:(NSString *)isSpread{
    _isSpread = isSpread;
    if ([isSpread isEqualToString:@"1"]) {
        
        self.spreadBtn.selected = YES;
    }else{
        
        self.spreadBtn.selected = NO;
    }
    if (self.spreadBtn.selected) {
        self.line.hidden = YES;
    }else{
        self.line.hidden = NO;
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
