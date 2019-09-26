//
//  TFDynamicSectionView.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/9/6.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFDynamicSectionView.h"

@implementation TFDynamicSectionView

- (instancetype)initWithFrame:(CGRect)frame date:(long long)timeSp{

    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = WhiteColor;
        self.timeSp = timeSp;
        
        [self createView];
    }
    return self;

}

- (void)createView {

    UILabel *pointLab = [UILabel initCustom:CGRectZero title:@"" titleColor:nil titleFont:12 bgColor:GreenColor];
    pointLab.layer.cornerRadius = 5.0;
    pointLab.layer.masksToBounds = YES;
    [self addSubview:pointLab];
    
    [pointLab mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(@20);
        make.top.equalTo(@17);
        make.width.height.equalTo(@10);
    }];
    
    NSString *dateStr = [HQHelper nsdateToTime:self.timeSp formatStr:@"yyyy年MM月dd日"];
//    NSString *dateStr = @"2017年10月11日";
    
    UILabel *dateLab = [UILabel initCustom:CGRectZero title:dateStr titleColor:kUIColorFromRGB(0x4A4A4A) titleFont:12 bgColor:ClearColor];
    dateLab.textAlignment = NSTextAlignmentLeft;
    [self addSubview:dateLab];
    
    [dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(pointLab.mas_right).offset(10);
        make.centerY.equalTo(pointLab.mas_centerY);
        make.width.equalTo(@(SCREEN_WIDTH-38-20));
        make.height.equalTo(@17);
    }];

}

@end
