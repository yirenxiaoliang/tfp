//
//  TFCustomShareHandleView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/12.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomShareHandleView.h"

@implementation TFCustomShareHandleView

+(instancetype)customShareHandleView{
    
    TFCustomShareHandleView *view = [[TFCustomShareHandleView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,36}];
    return view;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIButton *deleteBtn = [HQHelper buttonWithFrame:(CGRect){self.width-60-15,0,60,36} target:self action:@selector(deleteBtnClicked:)];
        [self addSubview:deleteBtn];
        [deleteBtn setTitle:@" 删除" forState:UIControlStateNormal];
        [deleteBtn setTitle:@" 删除" forState:UIControlStateHighlighted];
        [deleteBtn setImage:[UIImage imageNamed:@"回收站"] forState:UIControlStateNormal];
        [deleteBtn setImage:[UIImage imageNamed:@"回收站"] forState:UIControlStateHighlighted];
        [deleteBtn setTitleColor:RedColor forState:UIControlStateNormal];
        [deleteBtn setTitleColor:RedColor forState:UIControlStateHighlighted];
        deleteBtn.titleLabel.font = FONT(14);
        self.deleteBtn = deleteBtn;
        
        UIButton *editBtn = [HQHelper buttonWithFrame:(CGRect){self.width-120-30,0,60,36} target:self action:@selector(editBtnClicked:)];
        [self addSubview:editBtn];
        [editBtn setTitle:@" 编辑" forState:UIControlStateNormal];
        [editBtn setTitle:@" 编辑" forState:UIControlStateHighlighted];
        [editBtn setImage:[UIImage imageNamed:@"编辑20"] forState:UIControlStateNormal];
        [editBtn setImage:[UIImage imageNamed:@"编辑20"] forState:UIControlStateHighlighted];
        [editBtn setTitleColor:LightBlackTextColor forState:UIControlStateNormal];
        [editBtn setTitleColor:LightBlackTextColor forState:UIControlStateHighlighted];
        editBtn.titleLabel.font = FONT(14);
        self.editBtn = editBtn;
        
        self.backgroundColor = HexColor(0xf4f6f9);
    }
    return self;
}


- (void)deleteBtnClicked:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(customShareHandleViewDidClickedDeleteBtn:)]) {
        [self.delegate customShareHandleViewDidClickedDeleteBtn:button];
    }
    
}

- (void)editBtnClicked:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(customShareHandleViewDidClickedEditBtn:)]) {
        [self.delegate customShareHandleViewDidClickedEditBtn:button];
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
