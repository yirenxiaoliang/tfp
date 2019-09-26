//
//  TFPCFinishedView.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/11.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFPCFinishedView.h"

@interface TFPCFinishedView()

@property (nonatomic, strong) UIImageView *finishImgV;

@property (nonatomic, strong) UILabel *finishLab;
@property (nonatomic, strong) UILabel *tipLab;

@end


@implementation TFPCFinishedView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"渐隐底白"]];
        [self setupChild];
    }
    return  self;
}

- (void)setupChild {
    
    self.finishImgV = [[UIImageView alloc] init];
    
    self.finishImgV.image = IMG(@"打卡异常");
    [self addSubview:self.finishImgV];
    
    [self.finishImgV mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(@109);
        make.top.equalTo(@22);
        make.width.height.equalTo(@40);
    }];
    
    
    self.finishLab = [UILabel initCustom:CGRectZero title:@"今天打卡已完成" titleColor:kUIColorFromRGB(0xF9A144) titleFont:14 bgColor:ClearColor];
    self.finishLab.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.finishLab];
    
    [self.finishLab mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.finishImgV.mas_right).offset(15);
        make.centerY.equalTo(self.finishImgV.mas_centerY);
        make.height.equalTo(@20);
    }];
    
    self.tipLab = [UILabel initCustom:CGRectZero title:@"考勤有异常，记得和领导说明原因" titleColor:kUIColorFromRGB(0x333333) titleFont:14 bgColor:ClearColor];
    self.tipLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.tipLab];
    
    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(@60);
        make.right.equalTo(@(-60));
        make.top.equalTo(self.finishImgV.mas_bottom).offset(20);
        make.height.equalTo(@20);
    }];
    
}

/** 0:正常 ; 1:不正常 */
-(void)refreshFinishStatus:(NSInteger)status{
    
    if (status == 0) {
        self.finishImgV.image = IMG(@"打卡完成icon");
        self.finishLab.text = @"今天打卡已完成";
        self.finishLab.textColor = GreenColor;
        self.tipLab.text = @"工作辛苦了，下班好好休息下";
    }else{
        self.finishImgV.image = IMG(@"打卡异常");
        self.finishLab.text = @"今天打卡已完成";
        self.finishLab.textColor = kUIColorFromRGB(0xF9A144);
        self.tipLab.text = @"考勤有异常，记得和领导说明原因";
    }
}

@end
