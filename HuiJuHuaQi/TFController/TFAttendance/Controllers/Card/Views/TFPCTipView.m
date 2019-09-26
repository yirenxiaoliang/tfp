//
//  TFPCTipView.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFPCTipView.h"

@interface TFPCTipView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *mainView;

@property (nonatomic, strong) UILabel *goWork;

@property (nonatomic, strong) UILabel *offWork;

@property (nonatomic, strong) UIButton *knowBtn;


//@property (nonatomic, strong) UIImageView *imageV;

@end

@implementation TFPCTipView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
//        self.backgroundColor = [UIColor grayColor];
//        self.alpha = 0.5;
        [self setupChild];
    }
    return  self;
}

- (void)setupChild {
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];

    [self addSubview:self.bgView];
    
    self.mainView = [[UIImageView alloc] init];
    self.mainView.frame =CGRectMake((SCREEN_WIDTH-300)/2, (SCREEN_HEIGHT-284)/2, 300, 284);
//    self.mainView.backgroundColor = WhiteColor;
    self.mainView.image = IMG(@"正常状态打卡成功弹框");
    self.mainView.userInteractionEnabled = YES;
    
    self.mainView.layer.cornerRadius = 16.0;
    self.mainView.layer.masksToBounds = YES;
    self.mainView.contentMode = UIViewContentModeScaleToFill;
    [self.bgView addSubview:self.mainView];
    
    
    //上班时间
    self.goWork = [UILabel initCustom:CGRectZero title:@"" titleColor:ExtraLightBlackTextColor titleFont:14 bgColor:ClearColor];
    self.goWork.textAlignment = NSTextAlignmentCenter;

    [self.mainView addSubview:self.goWork];

    [self.goWork mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(self.mainView.mas_left);
        make.right.equalTo(self.mainView.mas_right);
        make.bottom.equalTo(self.mainView.mas_bottom).offset(-95);
        make.height.equalTo(@20);
    }];

    //下班时间
    self.offWork = [UILabel initCustom:CGRectZero title:@"" titleColor:HexColor(0x5AA3FB) titleFont:14 bgColor:ClearColor];
    self.offWork.textAlignment = NSTextAlignmentCenter;
    
    [self.mainView addSubview:self.offWork];
    
    [self.offWork mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mainView.mas_left);
        make.right.equalTo(self.mainView.mas_right);
        make.bottom.equalTo(self.mainView.mas_bottom).offset(-75);
        make.height.equalTo(@20);
    }];
    
    //按钮
    self.knowBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    [self.knowBtn addTarget:self action:@selector(knowAction) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:self.knowBtn];

    [self.knowBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(self.mainView.mas_left).offset(0);
        make.right.equalTo(self.mainView.mas_right).offset(0);
        make.bottom.equalTo(self.mainView.mas_bottom).offset(0);
        make.height.equalTo(@50);
    }];

}

/** 打卡提示 */
-(void)refreshTipViewWithModel:(TFPutchRecordModel *)model{
    
    /** 打卡状态，0:未打卡,1:正常,2:迟到,3:早退,4:旷工,5:缺卡 */
    if ([model.punchcard_status isEqualToString:@"1"]) {
        self.mainView.image = IMG(@"正常状态打卡成功弹框");
    }else if ([model.punchcard_status isEqualToString:@"2"]){
        self.mainView.image = IMG(@"迟到状态打卡成功弹框");
    }else if ([model.punchcard_status isEqualToString:@"3"]){
        self.mainView.image = IMG(@"早退状态打卡成功弹框");
    }else if ([model.punchcard_status isEqualToString:@"4"]){
        self.mainView.image = IMG(@"异常转旷工打卡成功弹框");
    }
    // 期望时间
    if ([model.punchcard_type isEqualToString:@"1"]) {// 上班卡
        if (!IsStrEmpty(model.expect_punchcard_time)) {
            self.goWork.text = [NSString stringWithFormat:@"上班时间：%@",model.expect_punchcard_time];
        }else{
            self.goWork.text = @"";
        }
    }else if ([model.punchcard_type isEqualToString:@"2"]){// 下班卡
        if (!IsStrEmpty(model.expect_punchcard_time)) {
            self.goWork.text = [NSString stringWithFormat:@"下班时间：%@",model.expect_punchcard_time];
        }else{
            self.goWork.text = @"";
        }
    }
    // 真实打卡时间
    self.offWork.text = [NSString stringWithFormat:@"打卡时间：%@",[HQHelper nsdateToTime:[model.real_punchcard_time longLongValue] formatStr:@"HH:mm"]];
    
}

- (void)knowAction {
    
    if ([self.delegate respondsToSelector:@selector(knowClicked)]) {
        
        [self.delegate knowClicked];
    }
    
}

@end
