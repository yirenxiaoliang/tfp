//
//  TFPCBottomView.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/11.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFPCBottomView.h"

#define  TipW (124)
#define  BgW (124 + 16)

@interface TFPCBottomView()

@property (nonatomic, strong) UIButton *pcBtn;

@property (nonatomic, weak) UIView *bgView;

/** 定时器 */
@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) TFPutchRecordModel *model;

@end

@implementation TFPCBottomView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"渐隐底白"]];
        [self setupChild];
    }
    return  self;
}

- (void)setupChild {
    
    self.pcBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.pcBtn setBackgroundColor:kUIColorFromRGB(0x2958DB)];
    [self.pcBtn addTarget:self action:@selector(punchCardAction) forControlEvents:UIControlEventTouchUpInside];
    [self.pcBtn addTarget:self action:@selector(punchDown) forControlEvents:UIControlEventTouchDown];
    [self.pcBtn addTarget:self action:@selector(punchCancel) forControlEvents:UIControlEventTouchCancel];
    [self.pcBtn addTarget:self action:@selector(punchCancel) forControlEvents:UIControlEventTouchUpOutside];
    [self.pcBtn addTarget:self action:@selector(punchCancel) forControlEvents:UIControlEventTouchDragOutside];
    [self addSubview:self.pcBtn];
    self.pcBtn.titleLabel.numberOfLines = 0;
    self.pcBtn.layer.cornerRadius = TipW/2;
    self.pcBtn.layer.masksToBounds = YES;
    self.pcBtn.titleLabel.font = FONT(15);
    
    [self.pcBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(@8);
        make.width.equalTo(@(TipW));
        make.height.equalTo(@(TipW));
        make.left.equalTo(@((SCREEN_WIDTH-TipW)/2));
    }];
    self.pcBtn.contentMode = UIViewContentModeScaleToFill;
    
    [self.pcBtn setTitle:[NSString stringWithFormat:@"%@\n上班打卡",[HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"HH:mm:ss"]] forState:UIControlStateNormal];
    [self.pcBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    self.pcBtn.titleLabel.font = FONT(15);
    self.pcBtn.layer.cornerRadius = TipW/2;
    self.pcBtn.layer.masksToBounds = YES;
    self.pcBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView *bgView = [UIView new];
    bgView.frame = CGRectMake(0, 0, BgW, BgW);
    bgView.center = CGPointMake((SCREEN_WIDTH)/2, BgW/2);
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = BgW/2;
    bgView.backgroundColor = HexAColor(0xa0a0a0,0.5);
    self.bgView = bgView;
    [self insertSubview:bgView belowSubview:self.pcBtn];
    
    self.tipImg = [[UIImageView alloc] init];
    
    self.tipImg.image = IMG(@"打卡范围提示");
    
    [self addSubview:self.tipImg];
    
    [self.tipImg mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(@70);
        make.top.equalTo(self.bgView.mas_bottom).offset(20);
        make.width.height.equalTo(@10);
    }];
    
    self.tipLab = [UILabel initCustom:CGRectZero title:@"" titleColor:kUIColorFromRGB(0x666666) titleFont:12 bgColor:ClearColor];
    
    self.tipLab.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.tipLab];
    
    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.tipImg.mas_right).offset(10);
        make.right.equalTo(@(-70));
        make.height.equalTo(@17);
        make.centerY.equalTo(self.tipImg);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeLocation)];
    [self.tipLab addGestureRecognizer:tap];
    
    [self startDisplayLink];
}

#pragma mark 定时器
- (void)startDisplayLink{
    self.displayLink = [CADisplayLink displayLinkWithTarget:self
                                                   selector:@selector(handleDisplayLink:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSDefaultRunLoopMode];
}

- (void)handleDisplayLink:(CADisplayLink *)displayLink{
    //do something
    [self refreshPCTimeWithModel:self.model];
}

- (void)stopDisplayLink{
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (void)dealloc {
    [self stopDisplayLink];
}

- (void)refreshPCTimeWithModel:(TFPutchRecordModel *)model {
    
    self.model = model;
    
    NSString *str = nil;
    if ([model.punchcard_type isEqualToString:@"1"]) {// 上班
        str = @"上班打卡";
        if ([model.id isEqualToNumber:@(0)]) {
            str = @"加班打卡";
        }
    }else{
        str = @"下班打卡";
    }
    NSString *time = [HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"HH:mm:ss"];
    NSString *total = [NSString stringWithFormat:@"%@\n%@",time,str];
//    [self.pcBtn setTitle:total forState:UIControlStateNormal];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:total];
    [attr addAttribute:NSFontAttributeName value:FONT(24) range:[total rangeOfString:time]];
    [self.pcBtn setAttributedTitle:attr forState:UIControlStateNormal];
    
    
    // 判断迟到与否及外勤
    if (![model.isPunch isEqualToString:@"3"]) {// 非外勤
        
        if ([model.punchcard_type isEqualToString:@"1"]) {// 上班
           
            if ([model.freedom isEqualToString:@"1"]) {// 自由
//                [self.pcBtn setBackgroundImage:IMG(@"bluebotton") forState:UIControlStateNormal];
//                [self.pcBtn setBackgroundImage:IMG(@"bluebotton") forState:UIControlStateHighlighted];
                [self.pcBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
                [self.pcBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateHighlighted];
                self.bgView.backgroundColor = HexAColor(0x3689E9,.5);
            }else{
                if ([model.punchcard_status isEqualToString:@"2"]) {// 迟到
//                    [self.pcBtn setBackgroundImage:IMG(@"yellowbotton") forState:UIControlStateNormal];
//                    [self.pcBtn setBackgroundImage:IMG(@"yellowbotton") forState:UIControlStateHighlighted];
                    [self.pcBtn setBackgroundImage:[HQHelper createImageWithColor:HexColor(0xFFA416)] forState:UIControlStateNormal];
                    [self.pcBtn setBackgroundImage:[HQHelper createImageWithColor:HexColor(0xFFA416)] forState:UIControlStateHighlighted];
                    self.bgView.backgroundColor = HexAColor(0xFFA416,.5);
                    
                    str = @"迟到打卡";
                    total = [NSString stringWithFormat:@"%@\n%@",time,str];
                    
                    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:total];
                    [attr addAttribute:NSFontAttributeName value:FONT(24) range:[total rangeOfString:time]];
                    [self.pcBtn setAttributedTitle:attr forState:UIControlStateNormal];
                    
//                    [self.pcBtn setTitle:[NSString stringWithFormat:@"%@\n%@",[HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"HH:mm:ss"],@"迟到打卡"] forState:UIControlStateNormal];
                    
                }else if ([model.punchcard_status isEqualToString:@"1"]) {// 正常
//                    [self.pcBtn setBackgroundImage:IMG(@"bluebotton") forState:UIControlStateNormal];
//                    [self.pcBtn setBackgroundImage:IMG(@"bluebotton") forState:UIControlStateHighlighted];
                    
                    [self.pcBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
                    [self.pcBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateHighlighted];
                    self.bgView.backgroundColor = HexAColor(0x3689E9,.5);
                }else {// ??
//                    [self.pcBtn setBackgroundImage:IMG(@"bluebotton") forState:UIControlStateNormal];
//                    [self.pcBtn setBackgroundImage:IMG(@"bluebotton") forState:UIControlStateHighlighted];
                    [self.pcBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
                    [self.pcBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateHighlighted];
                    self.bgView.backgroundColor = HexAColor(0x3689E9,.5);
                }
            }
        }else{// 下班
            if ([model.freedom isEqualToString:@"1"]) {// 自由
//                [self.pcBtn setBackgroundImage:IMG(@"bluebotton") forState:UIControlStateNormal];
//                [self.pcBtn setBackgroundImage:IMG(@"bluebotton") forState:UIControlStateHighlighted];
                [self.pcBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
                [self.pcBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateHighlighted];
                
                self.bgView.backgroundColor = HexAColor(0x3689E9,.5);
            }else{
                if ([model.punchcard_status isEqualToString:@"1"]) {// 正常
//                    [self.pcBtn setBackgroundImage:IMG(@"bluebotton") forState:UIControlStateNormal];
//                    [self.pcBtn setBackgroundImage:IMG(@"bluebotton") forState:UIControlStateHighlighted];
                    
                    [self.pcBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
                    [self.pcBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateHighlighted];
                    self.bgView.backgroundColor = HexAColor(0x3689E9,.5);
                }else if ([model.punchcard_status isEqualToString:@"3"]){// 早退
//                    [self.pcBtn setBackgroundImage:IMG(@"yellowbotton") forState:UIControlStateNormal];
//                    [self.pcBtn setBackgroundImage:IMG(@"yellowbotton") forState:UIControlStateHighlighted];
                    [self.pcBtn setBackgroundImage:[HQHelper createImageWithColor:HexColor(0xFFA416)] forState:UIControlStateNormal];
                    [self.pcBtn setBackgroundImage:[HQHelper createImageWithColor:HexColor(0xFFA416)] forState:UIControlStateHighlighted];
                    self.bgView.backgroundColor = HexAColor(0xFFA416,.5);
                    
                    str = @"早退打卡";
                    total = [NSString stringWithFormat:@"%@\n%@",time,str];
                    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:total];
                    [attr addAttribute:NSFontAttributeName value:BFONT(24) range:[total rangeOfString:time]];
                    [self.pcBtn setAttributedTitle:attr forState:UIControlStateNormal];
                    
//                    [self.pcBtn setTitle:[NSString stringWithFormat:@"%@\n%@",[HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"HH:mm:ss"],@"早退打卡"] forState:UIControlStateNormal];
                }else{// ??
//                    [self.pcBtn setBackgroundImage:IMG(@"bluebotton") forState:UIControlStateNormal];
//                    [self.pcBtn setBackgroundImage:IMG(@"bluebotton") forState:UIControlStateHighlighted];
                    [self.pcBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
                    [self.pcBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateHighlighted];
                    self.bgView.backgroundColor = HexAColor(0x3689E9,.5);
                }
            }
        }
        self.tipLab.userInteractionEnabled = NO;
        if ([model.isPunch isEqualToString:@"0"]) {// 不能打卡
            self.tipImg.image = IMG(@"打卡范围提示");
            self.tipLab.text = @"不在考勤范围";
//            [self.pcBtn setBackgroundImage:IMG(@"灰botton") forState:UIControlStateNormal];
//            [self.pcBtn setBackgroundImage:IMG(@"灰botton") forState:UIControlStateHighlighted];
            [self.pcBtn setBackgroundImage:[HQHelper createImageWithColor:GrayTextColor] forState:UIControlStateNormal];
            [self.pcBtn setBackgroundImage:[HQHelper createImageWithColor:GrayTextColor] forState:UIControlStateHighlighted];
            self.bgView.backgroundColor = HexAColor(0x999999,.5);
        }
        if ([model.isPunch isEqualToString:@"1"]) {// 地址
            self.tipImg.image = IMG(@"打卡范围提示");
            if ([model.id isEqualToNumber:@(-1)]) {
                self.tipLab.text = [NSString stringWithFormat:@"%@",model.punchcard_name];
            }else{
                self.tipLab.userInteractionEnabled = YES;
                self.tipLab.text = [NSString stringWithFormat:@"已进入打卡范围：%@",model.punchcard_name];
            }
        }
        if ([model.isPunch isEqualToString:@"2"]) {// WiFi
            self.tipImg.image = IMG(@"Wifi");
            if ([model.id isEqualToNumber:@(-1)]) {
                self.tipLab.text = [NSString stringWithFormat:@"%@",model.punchcard_name];
            }else{
                self.tipLab.text = [NSString stringWithFormat:@"已进入打卡WiFi：%@",model.punchcard_name];
            }
        }
        if ([model.isPunch isEqualToString:@"3"]) {// 外勤打卡
            self.tipImg.image = IMG(@"不在考勤范围提示");
            self.tipLab.text = @"当前位置不在考勤范围  查看考勤范围";
            self.tipLab.userInteractionEnabled = YES;
            NSString *str = @"查看考勤范围";
            NSMutableAttributedString *attr  = [[NSMutableAttributedString alloc] initWithString:TEXT(self.tipLab.text) attributes:@{NSForegroundColorAttributeName:ExtraLightBlackTextColor,NSFontAttributeName:FONT(12)}];
            [attr addAttribute:NSForegroundColorAttributeName value:GreenColor range:[TEXT(self.tipLab.text) rangeOfString:str]];
            self.tipLab.attributedText = attr;
            
        }
        
    }
    else{
        
//        [self.pcBtn setBackgroundImage:IMG(@"greenbotton") forState:UIControlStateNormal];
//        [self.pcBtn setBackgroundImage:IMG(@"greenbotton") forState:UIControlStateHighlighted];
        [self.pcBtn setBackgroundImage:[HQHelper createImageWithColor:HexColor(0x04B88D)] forState:UIControlStateNormal];
        [self.pcBtn setBackgroundImage:[HQHelper createImageWithColor:HexColor(0x04B88D)] forState:UIControlStateHighlighted];
         self.bgView.backgroundColor = HexAColor(0x04B88D,.5);
        
        
        str = @"外勤打卡";
        total = [NSString stringWithFormat:@"%@\n%@",time,str];
        NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:total];
        [attr1 addAttribute:NSFontAttributeName value:FONT(24) range:[total rangeOfString:time]];
        [self.pcBtn setAttributedTitle:attr1 forState:UIControlStateNormal];
        
        
//        [self.pcBtn setTitle:[NSString stringWithFormat:@"%@\n%@",[HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"HH:mm:ss"],@"外勤打卡"] forState:UIControlStateNormal];
        
        self.tipImg.image = IMG(@"不在考勤范围提示");
        self.tipLab.text = @"当前位置不在考勤范围  查看考勤范围";
        self.tipLab.userInteractionEnabled = YES;
        NSString *str = @"查看考勤范围";
        NSMutableAttributedString *attr  = [[NSMutableAttributedString alloc] initWithString:TEXT(self.tipLab.text) attributes:@{NSForegroundColorAttributeName:ExtraLightBlackTextColor,NSFontAttributeName:FONT(12)}];
        [attr addAttribute:NSForegroundColorAttributeName value:GreenColor range:[TEXT(self.tipLab.text) rangeOfString:str]];
        self.tipLab.attributedText = attr;
        
    }
    
    // 确保没有单独的一个图标
    if (IsStrEmpty(self.tipLab.text)) {
        self.tipImg.hidden = YES;
    }else{
        self.tipImg.hidden = self.tipLab.hidden;
    }
}

- (void)punchCardAction {
    
    if ([self.delegate respondsToSelector:@selector(punchCardClicked)]) {
        
        [self.delegate punchCardClicked];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.pcBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@8);
            make.width.equalTo(@(TipW));
            make.height.equalTo(@(TipW));
            make.left.equalTo(@((SCREEN_WIDTH-TipW)/2));
        }];
    }completion:^(BOOL finished) {
        
        self.pcBtn.layer.cornerRadius = TipW/2;
    }];
}
-(void)punchCancel{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.pcBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@8);
            make.width.equalTo(@(TipW));
            make.height.equalTo(@(TipW));
            make.left.equalTo(@((SCREEN_WIDTH-TipW)/2));
        }];
    }completion:^(BOOL finished) {
        
        self.pcBtn.layer.cornerRadius = TipW/2;
    }];
}
-(void)punchDown{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.pcBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.width.equalTo(@(BgW));
            make.height.equalTo(@(BgW));
            make.left.equalTo(@((SCREEN_WIDTH-BgW)/2));
        }];
    }completion:^(BOOL finished) {
        
        self.pcBtn.layer.cornerRadius = BgW/2;
    }];
}
-(void)seeLocation{
    if ([self.delegate respondsToSelector:@selector(punchCardTipLocationClicked:)]) {
        [self.delegate punchCardTipLocationClicked:self.model];
    }
}

@end
