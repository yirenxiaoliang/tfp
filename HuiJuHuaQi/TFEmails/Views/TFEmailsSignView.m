//
//  TFEmailsSignView.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/2/26.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEmailsSignView.h"

@interface TFEmailsSignView ()

@property (nonatomic, strong) UIButton *photoBtn;

@property (nonatomic, strong) UILabel *nameLab;

@property (nonatomic, strong) UILabel *emailLab;

@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, strong) UILabel *lineLab;

@property (nonatomic, strong) UILabel *signLab;

@end

@implementation TFEmailsSignView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self=[super initWithFrame:frame]) {
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {

    self.photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self addSubview:self.photoBtn];
    
    [self.photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(@15);
        make.top.equalTo(@15);
        make.width.height.equalTo(@35);
        
    }];
    
    //
    self.nameLab = [UILabel initCustom:CGRectZero title:@"yokohu1414" titleColor:kUIColorFromRGB(0x17171A) titleFont:14 bgColor:ClearColor];
    
    [self addSubview:self.nameLab];
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.photoBtn.mas_right).offset(10);
        make.top.equalTo(@10);
        make.height.equalTo(@20);
        
    }];
    
    //
    self.emailLab = [UILabel initCustom:CGRectZero title:@"邮箱: yokohu1414@126.com " titleColor:kUIColorFromRGB(0xA0A0AE) titleFont:14 bgColor:ClearColor];
    
    [self addSubview:self.emailLab];
    
    [self.emailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.photoBtn.mas_right).offset(10);
        make.top.equalTo(self.nameLab.mas_bottom).offset(5);
        make.height.equalTo(@20);
        
    }];
    
    //
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self addSubview:self.deleteBtn];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(@15);
        make.centerY.equalTo(self.nameLab.mas_centerY);
        make.width.height.equalTo(@24);
        
    }];
    
    //
    self.lineLab = [UILabel initCustom:CGRectZero title:@"" titleColor:kUIColorFromRGB(0xA0A0AE) titleFont:14 bgColor:kUIColorFromRGB(0xD8D8D8)];
    
    [self addSubview:self.lineLab];
    
    [self.lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.right.equalTo(@15);
        make.top.equalTo(self.emailLab.mas_bottom).offset(5);
        make.height.equalTo(@1);
        
    }];
    
    //
    self.signLab = [UILabel initCustom:CGRectZero title:@"邮箱: yokohu1414@126.com " titleColor:kUIColorFromRGB(0xA0A0AE) titleFont:12 bgColor:ClearColor];
    
    [self addSubview:self.signLab];
    
    [self.signLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(self.lineLab.mas_bottom).offset(10);
        make.height.equalTo(@17);
        
    }];
    
}

@end
