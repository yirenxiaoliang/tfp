//
//  TFSubformSectionView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/9/7.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSubformSectionView.h"

@interface TFSubformSectionView ()


@end


@implementation TFSubformSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,40}];
        [self addSubview:view];
        view.layer.cornerRadius = 0;
        view.layer.masksToBounds = YES;
        view.backgroundColor = BackGroudColor;
        
        UILabel *label = [HQHelper labelWithFrame:(CGRect){15,0,SCREEN_WIDTH-100,40} text:@"" textColor:GreenColor textAlignment:NSTextAlignmentLeft font:FONT(13)];
        label.backgroundColor = ClearColor;
        [view addSubview:label];
        self.titleLabel = label;
        
        UIButton *button = [HQHelper buttonWithFrame:(CGRect){SCREEN_WIDTH-60,0,56,40} target:self action:@selector(deleteClicked:)];
        [view addSubview:button];
        [button setTitle:@"删除" forState:UIControlStateNormal];
        [button setTitle:@"删除" forState:UIControlStateHighlighted];
        [button setTitleColor:RedColor forState:UIControlStateHighlighted];
        [button setTitleColor:RedColor forState:UIControlStateNormal];
        button.titleLabel.font = FONT(13);
        self.deleteBtn = button;
        
        self.backgroundColor = WhiteColor;
        self.layer.masksToBounds = YES;
        
    }
    return self;
}

+(instancetype)subformSectionView{
    
    TFSubformSectionView *view = [[TFSubformSectionView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,40}];
    
    return view;
}

-(void)setIsEdit:(BOOL)isEdit{
    
    _isEdit = isEdit;
    self.deleteBtn.hidden = !isEdit;
}

- (void)deleteClicked:(UIButton *)button{
    
    
    if ([self.delegate respondsToSelector:@selector(subformSectionView:didClickedDeleteBtn:)]) {
        [self.delegate subformSectionView:self didClickedDeleteBtn:button];
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
