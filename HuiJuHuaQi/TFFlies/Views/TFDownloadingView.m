//
//  TFDownloadingView.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/29.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFDownloadingView.h"

@interface TFDownloadingView ()

@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation TFDownloadingView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = kUIColorFromRGB(0xFFFFFF);
        
        [self setDownloadView];
    }
    return self;
}

- (void)setDownloadView {

    _loadLab = [UILabel initCustom:CGRectZero title:@"" titleColor:kUIColorFromRGB(0x69696C) titleFont:8 bgColor:ClearColor];
    
    [self addSubview:_loadLab];
    
    [_loadLab mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(@70);
        make.top.equalTo(self.mas_top).offset(10);
        make.width.equalTo(@(SCREEN_WIDTH-140));
        make.height.equalTo(@11);
        
    }];
    
    
    
    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progressView.frame = CGRectZero;
    _progressView.trackTintColor = kUIColorFromRGB(0xEBEDF0);
    _progressView.progressTintColor = kUIColorFromRGB(0x51D0B1);
    
    [self addSubview:_progressView];
    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(@((SCREEN_WIDTH-240)/2));
        make.top.equalTo(_loadLab.mas_bottom).offset(5);
        make.width.equalTo(@240);
        make.height.equalTo(@1);
        
    }];
    
    
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeBtn.frame = CGRectZero;
    [_closeBtn setImage:IMG(@"错误") forState:UIControlStateNormal];
    
    [self addSubview:_closeBtn];
    
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_progressView.mas_right).offset(6);
        make.centerY.equalTo(_progressView.mas_centerY);
        make.width.height.equalTo(@10);
        
    }];
    
}

@end
