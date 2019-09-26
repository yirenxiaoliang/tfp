//
//  TFEmailsHeadView.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/2/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEmailsHeadView.h"

@implementation TFEmailsHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        [self setSubViews];
    }
    
    return self;
}

- (void)setSubViews {

    self.backgroundColor = kUIColorFromRGB(0xFFFFFF);
    
    self.titleLab = [UILabel initCustom:CGRectZero title:@"" titleColor:kUIColorFromRGB(0x4A4A4A) titleFont:16 bgColor:ClearColor];
    
    [self addSubview:self.titleLab];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(@14);
        make.top.equalTo(@12);
        make.height.equalTo(@22);
        
    }];
    
    //数量
    self.numsLab = [UILabel initCustom:CGRectZero title:@"" titleColor:kUIColorFromRGB(0xA0A0AE) titleFont:12 bgColor:ClearColor];
    
    [self addSubview:self.numsLab];
    
    [self.numsLab mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.titleLab.mas_right).offset(5);
        make.centerY.equalTo(self.titleLab.mas_centerY);
        make.height.equalTo(@17);
        
    }];
    
    self.flagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
//    self.flagBtn.layer.borderWidth = 0.5;
//    self.flagBtn.layer.borderColor = [kUIColorFromRGB(0x69696C) CGColor];
//    self.flagBtn.layer.cornerRadius = 2.0;
//    self.flagBtn.layer.masksToBounds = YES;
    
    [self.flagBtn setTitle:@"全标为已读" forState:UIControlStateNormal];
    
    [self.flagBtn setTitleColor:GreenColor forState:UIControlStateNormal];

    [self.flagBtn addTarget:self action:@selector(MarkAllReaded) forControlEvents:UIControlEventTouchUpInside];
    [self.flagBtn.titleLabel setFont:FONT(12)];
    [self addSubview:self.flagBtn];
    
    [self.flagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(@(-15));
        make.centerY.equalTo(self.numsLab.mas_centerY);
        make.height.equalTo(@21);
        make.width.equalTo(@70);
        
    }];
    
    UIView *line = [UIView new];
    [self addSubview:line];
    line.backgroundColor = CellSeparatorColor;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(0));
        make.left.equalTo(@(0));
        make.bottom.equalTo(@(0));
        make.height.equalTo(@(0.5));
        
    }];
    
}

- (void)refreshEmailsHeadViewWithData:(NSString *)title number:(NSInteger)number type:(NSInteger)type {

    self.titleLab.text = title;
    self.numsLab.text = [NSString stringWithFormat:@"(%ld)",number];
    if (number <= 0) {
        self.numsLab.hidden = YES;
    }else{
        self.numsLab.hidden = NO;
    }
    
    if (type == 1 || type == 6) {
        
        self.flagBtn.hidden = NO;
    }
    else {
        
        self.flagBtn.hidden = YES;
    }
}

- (void)MarkAllReaded {

    if ([self.delegate respondsToSelector:@selector(markAllEmailsReaded)]) {
        
        [self.delegate markAllEmailsReaded];
    }
}

@end
