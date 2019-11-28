//
//  HQTFLoginMainController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/13.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFLoginMainController.h"
#import "HQAdvertisementView.h"
#import "NSDate+NSString.h"
#import "TFInputTelephoneController.h"
#import "TFNewLoginController.h"

#define BHeight 210

@interface HQTFLoginMainController ()<CAAnimationDelegate>

@property (nonatomic , strong)HQAdvertisementView *advertisementView;

/** registerBtn */
@property (nonatomic, weak) UIButton *registerBtn;
/** loginBtn */
@property (nonatomic, weak) UIButton *loginBtn;

/** UIView *view */
@property (nonatomic, strong) UIView *snapshotView;


@end

@implementation HQTFLoginMainController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self showAnimation];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)showAnimation{
    
    // 1.创建动画缩放
    CABasicAnimation *animScale = [CABasicAnimation animation];
    animScale.keyPath = @"transform.scale";
    animScale.fromValue = [NSNumber numberWithInteger:0.0];
    animScale.toValue = [NSNumber numberWithInteger:1];
    animScale.duration = 0.6;
    [self.registerBtn.layer addAnimation:animScale forKey:nil];
    
    // 2.创建动画缩放
    CABasicAnimation *animScale2 = [CABasicAnimation animation];
    animScale2.keyPath = @"transform.scale";
    animScale2.fromValue = [NSNumber numberWithInteger:0.0];
    animScale2.toValue = [NSNumber numberWithInteger:1];
    animScale2.duration = 0.6;
    [self.loginBtn.layer addAnimation:animScale forKey:nil];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self setupBtns];
    [self setEdition];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view insertSubview:bgImageView atIndex:0];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    
//    UIView *alpha = [UIView new];
//    alpha.backgroundColor = [UIColor blackColor];
//    alpha.alpha = 0.4;
//    alpha.frame = bgImageView.bounds;
//    [bgImageView addSubview:alpha];
    
    if ([[HQHelper iPhoneType] isEqualToString:@"4"] ||
        [[HQHelper iPhoneType] isEqualToString:@"4s"]) {
        bgImageView.image = IMG(@"320*480");
    }else if ([[HQHelper iPhoneType] isEqualToString:@"5"] ||
              [[HQHelper iPhoneType] isEqualToString:@"5s"] ||
              [[HQHelper iPhoneType] isEqualToString:@"5c"] ||
              [[HQHelper iPhoneType] isEqualToString:@"SE"]){
        bgImageView.image = IMG(@"320*568");
    }else if ([[HQHelper iPhoneType] isEqualToString:@"6"] ||
              [[HQHelper iPhoneType] isEqualToString:@"6s"] ||
              [[HQHelper iPhoneType] isEqualToString:@"7"] ||
              [[HQHelper iPhoneType] isEqualToString:@"8"]){
        bgImageView.image = IMG(@"375*667");
    }else if ([[HQHelper iPhoneType] isEqualToString:@"6plus"] ||
              [[HQHelper iPhoneType] isEqualToString:@"6splus"] ||
              [[HQHelper iPhoneType] isEqualToString:@"7plus"] ||
              [[HQHelper iPhoneType] isEqualToString:@"8plus"]){
        bgImageView.image = IMG(@"414*736");
    }else if ([[HQHelper iPhoneType] isEqualToString:@"XR"] ||
              [[HQHelper iPhoneType] isEqualToString:@"XSMax"]){
        bgImageView.image = IMG(@"414*896");
    }else if ([[HQHelper iPhoneType] isEqualToString:@"X"] ||
              [[HQHelper iPhoneType] isEqualToString:@"XS"]){
        bgImageView.image = IMG(@"375*812");
    }else{
        bgImageView.image = IMG(@"414*896");
    }
    // logo
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"whiteLogo"]];
    logo.frame = CGRectMake(0, 0, Long(120) * (2.0*SCREEN_WIDTH/3.0)/(SCREEN_WIDTH/2.0),Long(120)*80.0/238.0 * (2.0*SCREEN_WIDTH/3.0)/(SCREEN_WIDTH/2.0));
    logo.center = CGPointMake(self.view.center.x, self.view.center.y - 210/2 + NaviHeight/2);
    [self.view insertSubview:logo aboveSubview:bgImageView];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    logo.hidden = YES;
}
#pragma mark - 版本
- (void)setEdition{
    
    NSDate *now = [NSDate date];
    NSString *year = now.getYear;
    NSString *edition = [NSString stringWithFormat:@"Copyright © 2014-%@ Teamface",[year substringToIndex:year.length - 1]];
    
    UILabel *label = [HQHelper labelWithFrame:(CGRect){0,SCREEN_HEIGHT-50,SCREEN_WIDTH,40} text:edition textColor:WhiteColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:label];
}

#pragma mark - registeBtn和loginBtn
- (void)setupBtns{
    CGFloat btnW = 135;
    CGFloat btnH = 50;
    
    for (NSInteger i = 0; i < 2; i ++) {
        
        UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        registerBtn.frame = CGRectMake((SCREEN_WIDTH-2*btnW)/3 * (i + 1) + i * btnW, SCREEN_HEIGHT - BHeight + (BHeight- btnH)/2, btnW, btnH);
        registerBtn.frame = CGRectMake((SCREEN_WIDTH-2*btnW)/3, SCREEN_HEIGHT - BHeight + (BHeight- btnH)/2, SCREEN_WIDTH - 2 *(SCREEN_WIDTH-2*btnW)/3, btnH);
        [self.view addSubview:registerBtn];
        registerBtn.layer.cornerRadius = 5;
        registerBtn.layer.masksToBounds = YES;
//        registerBtn.layer.borderColor = GreenColor.CGColor;
//        registerBtn.layer.borderWidth = 1;
        registerBtn.tag = 0x111 + i;
        [registerBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
            [registerBtn setTitle:@"注册" forState:UIControlStateHighlighted];
            [registerBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
            [registerBtn setTitleColor:WhiteColor forState:UIControlStateHighlighted];
            registerBtn.backgroundColor = ClearColor;
            registerBtn.layer.cornerRadius = btnH/2;
            registerBtn.layer.borderColor = WhiteColor.CGColor;
            registerBtn.layer.borderWidth = 1;
            self.registerBtn = registerBtn;
            registerBtn.hidden = YES;
        }else{
            [registerBtn setTitle:@"登录" forState:UIControlStateNormal];
            [registerBtn setTitle:@"登录" forState:UIControlStateHighlighted];
            [registerBtn setTitleColor:GreenColor forState:UIControlStateNormal];
            [registerBtn setTitleColor:GreenColor forState:UIControlStateHighlighted];
            registerBtn.backgroundColor = WhiteColor;
            registerBtn.layer.cornerRadius = btnH/2;
            self.loginBtn = registerBtn;
        }
    }
    
}

- (void)btnClicked:(UIButton *)button{
    
    if (button.tag - 0x111 == 0) {// 注册
//        TFRegisterController *regi = [[TFRegisterController alloc] init];
//        [self.navigationController pushViewController:regi animated:YES];
        
        UIView *view = [self.view snapshotViewAfterScreenUpdates:YES];
        view.frame = self.view.bounds;
        [KeyWindow addSubview:view];
        self.snapshotView = view;
        
        NSMutableArray *animations = [NSMutableArray array];
        // 创建动画组
        CAAnimationGroup *animGroup = [CAAnimationGroup animation];
        animGroup.delegate = self;
        // 1.创建动画平移
        CABasicAnimation *animPosition = [CABasicAnimation animation];
        animPosition.keyPath = @"position";
        NSValue *toValue = [NSValue valueWithCGPoint:CGPointMake(20, 20)];
        animPosition.toValue = toValue;
        [animations addObject:animPosition];
        
        // 2.创建动画缩放
        CABasicAnimation *animScale = [CABasicAnimation animation];
        animScale.keyPath = @"transform.scale";
        animScale.fromValue = [NSNumber numberWithInteger:1];
        animScale.toValue = [NSNumber numberWithInteger:0.0];
        [animations addObject:animScale];
        
        animGroup.removedOnCompletion = NO;
        animGroup.fillMode = kCAFillModeForwards;
        animGroup.duration = 0.6;
        animGroup.animations = animations;
        // 添加动画
        [view.layer addAnimation:animGroup forKey:nil];
        
        
        TFInputTelephoneController *forget = [[TFInputTelephoneController alloc] init];
        forget.type = 0;
        [self.navigationController pushViewController:forget animated:NO];
        
        
        
    }else{// 登录
        TFNewLoginController *login = [[TFNewLoginController alloc] init];
        [self.navigationController pushViewController:login animated:NO];
    }
}

#pragma mark - CAAnimationDelegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    [self.snapshotView removeFromSuperview];
}

#pragma mark - 初始化scrollVeiw
- (void)setupAdvertisementView
{
    
    _advertisementView = [[HQAdvertisementView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - BHeight)];
    _advertisementView.pageBottom = -40;
    _advertisementView.datas = [NSMutableArray arrayWithArray:@[[UIImage imageNamed:@"第一页"],
                                                                [UIImage imageNamed:@"第二页"],
                                                                [UIImage imageNamed:@"第三页"]
                                                                ]];
    _advertisementView.pageColor = RGBAColor(0x20, 0xbf, 0x9a, 0.4);
    _advertisementView.pageCurrentColor = GreenColor;
    [self.view addSubview:_advertisementView];
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
