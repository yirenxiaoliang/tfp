//
//  TFNoteAccessoryView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/19.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFNoteAccessoryView.h"

@interface TFNoteAccessoryView ()

/** checkBtn */
@property (nonatomic, weak) UIButton *checkBtn;
/** numBtn */
@property (nonatomic, weak) UIButton *numBtn;


@end


@implementation TFNoteAccessoryView



-(instancetype)initWithFrame:(CGRect)frame withImages:(NSArray *)images{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = HexColor(0xfefefe);
        [self setupChildViewWithImages:images];
        UIView *line = [UIView new];
        line.backgroundColor = CellSeparatorColor;
        line.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
        [self addSubview:line];
    }
    return self;
}

- (void)setupChildViewWithImages:(NSArray *)images{
    
    if (images.count == 0) {
        return;
    }
    
    CGFloat width = SCREEN_WIDTH/images.count;
    for (NSInteger i = 0; i < images.count; i ++) {
        
        UIButton *button = [HQHelper buttonWithFrame:(CGRect){i * width,0,width,49} normalImageStr:images[i] seletedImageStr:[NSString stringWithFormat:@"select%@",images[i]] highImageStr:nil target:self action:@selector(buttonClicked:)];
        button.tag = i;
        [self addSubview:button];
        
        if (i == 0) {
            self.checkBtn = button;
        }
        if (1 == i) {
            self.numBtn = button;
        }
    }
    
}

-(void)setNum:(BOOL)num{
    
    _num = num;
    self.numBtn.selected = num;
    
}

-(void)setCheck:(BOOL)check{
    
    _check = check;
    self.checkBtn.selected = check;
    
}

- (void)buttonClicked:(UIButton *)button{
    
    button.selected = !button.selected;
    
    if ([self.delegate respondsToSelector:@selector(noteAccessoryDidSelectedItem:AtIndex:)]) {
        [self.delegate noteAccessoryDidSelectedItem:button AtIndex:button.tag];
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
