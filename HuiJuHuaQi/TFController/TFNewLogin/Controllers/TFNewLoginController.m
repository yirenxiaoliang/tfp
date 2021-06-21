//
//  TFNewLoginController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/2/26.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFNewLoginController.h"
#import "TFLoginBL.h"
#import "TFInputTelephoneController.h"
#import "HQReSetPasswordController.h"
#import "TFSetUrlController.h"
#import "TFSelectUrlView.h"
#import "XWCountryCodeController.h"
#import "NSBundle+Language.h"

@interface TFNewLoginController ()<HQBLDelegate,UITextFieldDelegate,UIAlertViewDelegate>
/** 登录btn */
@property (nonatomic, weak) UIButton *loginBtn;
/** registerBtn */
@property (nonatomic, weak) UIButton *registerBtn;
/** 显示密码btn */
@property (nonatomic, weak) UIButton *showPasswordBtn;
/** 发送验证码btn */
@property (nonatomic, weak) UIButton *sendVerify;
/** 密码 */
@property (nonatomic, weak) UITextField *passwordField;
/** 验证码 */
@property (nonatomic, weak) UITextField *verifyField;
/** 手机号 */
@property (nonatomic, weak) UITextField *telePhoneField;

/** loginBL */
@property (nonatomic, strong) TFLoginBL *loginBL;

/** modify */
@property (nonatomic, assign) BOOL modify;

/** logo */
@property (nonatomic, weak) UIImageView *logo;

/** scrollView */
@property (nonatomic, weak)  UIScrollView *scrollView;

/** UIButton *teleIcon */
@property (nonatomic, weak) UIButton *teleIcon;
/** UIView *Vline */
@property (nonatomic, weak) UIView *Vline;
/** UIView *telePhoneBg */
@property (nonatomic, weak) UIView *telePhoneBg;
/** UIButton *passIcon */
@property (nonatomic, weak) UIButton *passIcon;
/** UIButton *verifyIcon */
@property (nonatomic, weak) UIButton *verifyIcon;
/** UIView *footer */
@property (nonatomic, weak) UIView *footer;
/**  UIButton *forgetBtn */
@property (nonatomic, weak)  UIButton *forgetBtn;
/** UILabel *tipLabel */
@property (nonatomic, weak) UILabel *tipLabel;
/** UIView *alpha */
@property (nonatomic, weak) UIView *alpha;

@property (nonatomic, weak)  UIImageView *bgImageView;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, weak) UIButton *setBtn;
@property (nonatomic, weak) UIButton *languageBtn;
@property (nonatomic, weak) UIButton *down;

@property (nonatomic, copy) NSString *district;
@property (nonatomic, weak) UIView *mask;
@property (nonatomic, weak) UIView *popview;
@property (nonatomic, weak) UILabel *accountLabel;
@property (nonatomic, strong) NSArray *codes;

@end

@implementation TFNewLoginController

-(NSArray *)codes{
    if (_codes == nil) {
        _codes = @[@"zh-Hans",@"zh-Hant",@"en"];
    }
    return _codes;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:ClearColor size:(CGSize){SCREEN_WIDTH,0.5}]];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self showAnimation];
    [self showLoginAnimation];
    [self showAlpha];
    
    self.url = [[NSUserDefaults standardUserDefaults] valueForKey:SaveInputUrlRecordKey]?[[NSUserDefaults standardUserDefaults] valueForKey:SaveInputUrlRecordKey]:[AppDelegate shareAppDelegate].baseUrl;
    
    self.setBtn.selected = ![[AppDelegate shareAppDelegate].baseUrl isEqualToString:baseUrl];
    self.forgetBtn.hidden = self.setBtn.selected;
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupChild];
    self.loginBL = [TFLoginBL build];
    self.loginBL.delegate = self;
    self.view.backgroundColor = WhiteColor;
}

- (void)showAnimation{
    
    NSMutableArray *animations = [NSMutableArray array];
    // 创建动画组
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    // 1.创建动画平移
    CABasicAnimation *animPosition = [CABasicAnimation animation];
    animPosition.keyPath = @"position";
    NSValue *from = [NSValue valueWithCGPoint:CGPointMake(self.view.center.x, self.view.center.y - 210/2)];
    animPosition.fromValue = from;
    NSValue *to = [NSValue valueWithCGPoint:self.logo.center];
    animPosition.toValue = to;
    [animations addObject:animPosition];
    
    // 2.创建动画缩放
    CABasicAnimation *animScale = [CABasicAnimation animation];
    animScale.keyPath = @"transform.scale";
    animScale.fromValue = [NSNumber numberWithFloat:(2.0*SCREEN_WIDTH/3.0)/(SCREEN_WIDTH/2.0)];
    animScale.toValue = [NSNumber numberWithFloat:1];
    [animations addObject:animScale];
    
    animGroup.removedOnCompletion = NO;
    animGroup.fillMode = kCAFillModeForwards;
    animGroup.duration = 0.6;
    animGroup.animations = animations;
    // 添加动画
    [self.logo.layer addAnimation:animGroup forKey:nil];
    
}
- (void)showAlpha{
    
    self.registerBtn.alpha = 0;
    self.showPasswordBtn.alpha = 0;
    self.passwordField.alpha = 0;
    self.telePhoneField.alpha = 0;
    self.teleIcon.alpha = 0;
    self.accountLabel.alpha = 0;
    self.Vline.alpha = 0;
    self.telePhoneBg.alpha = 0;
    self.passIcon.alpha = 0;
    self.footer.alpha = 0;
    self.forgetBtn.alpha = 0;
    self.tipLabel.alpha = 0;
    self.down.alpha = 0;
    self.languageBtn.alpha = 0;
    if (self.bgImageView.alpha != 0) {
        self.bgImageView.alpha = 1;
    }
    [UIView animateWithDuration:1 animations:^{
        
        self.registerBtn.alpha = 1;
        self.showPasswordBtn.alpha = 1;
        self.passwordField.alpha = 1;
        self.telePhoneField.alpha = 1;
        self.teleIcon.alpha = 1;
        self.accountLabel.alpha = 1;
        self.Vline.alpha = 1;
        self.telePhoneBg.alpha = 1;
        self.passIcon.alpha = 1;
        self.footer.alpha = 1;
        self.forgetBtn.alpha = 1;
        self.tipLabel.alpha = 1;
        self.down.alpha = 1;
        self.languageBtn.alpha = 1;
        self.alpha.alpha = 0.4;
        self.bgImageView.alpha = 0;
    }];
}

- (void)showLoginAnimation{
    
    
    NSMutableArray *animations = [NSMutableArray array];
    // 创建动画组
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    // 1.创建动画平移
    CABasicAnimation *animPosition = [CABasicAnimation animation];
    animPosition.keyPath = @"position";
    CGFloat btnW = 135;
    CGFloat btnH = 45;
    NSValue *from = [NSValue valueWithCGPoint:CGPointMake((SCREEN_WIDTH-2*btnW)/3 * (1 + 1) + 1 * btnW + btnW/2,  SCREEN_HEIGHT - 210 + btnH/2 + (210- btnH)/2)];
    animPosition.fromValue = from;
    NSValue *to = [NSValue valueWithCGPoint:self.loginBtn.center];
    animPosition.toValue = to;
    [animations addObject:animPosition];
    
    // 2.创建动画缩放
    CABasicAnimation *animScale = [CABasicAnimation animation];
    animScale.keyPath = @"transform.scale.x";
    animScale.fromValue = [NSNumber numberWithFloat:(btnW*1.0)/(self.loginBtn.width*1.0)];
    animScale.toValue = [NSNumber numberWithFloat:1];
    [animations addObject:animScale];
    
    animGroup.removedOnCompletion = NO;
    animGroup.fillMode = kCAFillModeForwards;
    animGroup.duration = 0.6;
    animGroup.animations = animations;
    // 添加动画
    [self.loginBtn.layer addAnimation:animGroup forKey:nil];
    
}

#pragma mark - 子控件
- (void)setupChild{
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
//    scrollView.backgroundColor = RedColor;
    
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -44, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (SCREEN_HEIGHT <= 736) {// x/xr/xmax
        bgImageView.frame = CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    [scrollView addSubview:bgImageView];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImageView = bgImageView;
    
    
    UIView *alpha = [UIView new];
    alpha.backgroundColor = [UIColor blackColor];
    alpha.alpha = 0.0;
    alpha.frame = bgImageView.bounds;
    [bgImageView addSubview:alpha];
    self.alpha = alpha;
    alpha.hidden = YES;
    
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
    logo.frame = CGRectMake(30, Long(40)+60, Long(120), Long(120)*80.0/238.0 );
    [scrollView addSubview:logo];
    logo.contentMode = UIViewContentModeCenter;
    self.logo = logo;

#ifdef DEBUG // 调试状态, 打开LOG功能
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [logo addGestureRecognizer:longPress];
    logo.userInteractionEnabled = YES;
#endif
    
    // 手机图标
    UIButton *teleIcon = [[UIButton alloc] initWithFrame:(CGRect){20,CGRectGetMaxY(logo.frame) + Long(60),60,40}];
    [scrollView addSubview:teleIcon];
//    [teleIcon setImage:[UIImage imageNamed:@"白手机"]];
    teleIcon.contentMode = UIViewContentModeCenter;
    [teleIcon setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [teleIcon setTitle:@"+86" forState:UIControlStateNormal];
    self.teleIcon = teleIcon;
    [teleIcon addTarget:self action:@selector(selectDistrict) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *Vline = [[UIView alloc] initWithFrame:(CGRect){CGRectGetMaxX(teleIcon.frame)+10,teleIcon.y+10,0.5,20}];
    Vline.backgroundColor = BlackTextColor;
    [scrollView addSubview:Vline];
    self.Vline = Vline;
    
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:teleIcon.frame];
    accountLabel.text = @"账号";
    accountLabel.textAlignment = NSTextAlignmentRight;
    [scrollView addSubview:accountLabel];
    accountLabel.backgroundColor = WhiteColor;
    accountLabel.font = FONT(18);
    self.accountLabel = accountLabel;
    
    //telephone
    UITextField *telePhone = [[UITextField alloc]initWithFrame:CGRectMake(70+40,CGRectGetMaxY(logo.frame) + Long(60), SCREEN_WIDTH-60-40-40, 40)];
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Please enter your mobile phone number", nil) attributes:@{ NSForegroundColorAttributeName:ExtraLightBlackTextColor,                                            NSFontAttributeName:FONT(14)}];
    [telePhone setAttributedPlaceholder:str1];
    telePhone.clearButtonMode = UITextFieldViewModeWhileEditing;
//    telePhone.backgroundColor = WhiteColor;
    [telePhone setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    telePhone.font = FONT(18);
//    telePhone.keyboardType = UIKeyboardTypeNumberPad;
    [telePhone addTarget:self action:@selector(textFieldTextChangeAction:) forControlEvents:UIControlEventEditingChanged];
    telePhone.tag = 0x111;
    telePhone.text = [[NSUserDefaults standardUserDefaults] objectForKey:UserLoginTelephone];
    self.telePhoneField = telePhone;
    telePhone.textColor = ExtraLightBlackTextColor;
    [scrollView addSubview:telePhone];
    if ([HQHelper checkTel:telePhone.text]) {
        self.accountLabel.hidden = YES;
    }else{
        self.accountLabel.hidden = NO;
    }
    
    UIView *telePhoneBg = [[UIView alloc] initWithFrame:CGRectMake(30,CGRectGetMaxY(telePhone.frame) , SCREEN_WIDTH-60, .5)];
    telePhoneBg.backgroundColor = ExtraLightBlackTextColor;
    [scrollView addSubview:telePhoneBg];
    self.telePhoneBg = telePhoneBg;
    
    // 密码图标
    UIButton *passIcon = [[UIButton alloc] initWithFrame:(CGRect){25,CGRectGetMaxY(telePhone.frame) + 20,80,40}];
    [scrollView addSubview:passIcon];
    //    [passIcon setImage:[UIImage imageNamed:@"密码"]];
    [passIcon setTitle:NSLocalizedString(@"password", nil) forState:UIControlStateNormal];
    [passIcon setTitleColor:BlackTextColor forState:UIControlStateNormal];
    passIcon.contentMode = UIViewContentModeCenter;
    self.passIcon = passIcon;
    
    // 密码
    UITextField *password = [[UITextField alloc]initWithFrame:CGRectMake(70+40,passIcon.y, SCREEN_WIDTH-60-40-40-40, 40)];
//    password.placeholder = @"请输入登录密码";
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Please input a password", nil) attributes:@{ NSForegroundColorAttributeName:ExtraLightBlackTextColor,                                            NSFontAttributeName:FONT(14)}];
    [password setAttributedPlaceholder:str];
    password.clearButtonMode = UITextFieldViewModeWhileEditing;
//    password.backgroundColor = WhiteColor;
    [password setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    password.font = FONT(18);
//    [password addTarget:self action:@selector(textFieldTextChangeAction:) forControlEvents:UIControlEventEditingChanged];
    password.secureTextEntry = YES;
    password.tag = 0x333;
    password.textColor = ExtraLightBlackTextColor;
    password.delegate = self;
    self.passwordField = password;
    [scrollView addSubview:password];
    
    // 显示密码按钮
    UIButton *showPassword = [UIButton buttonWithType:UIButtonTypeCustom];
    showPassword.frame = CGRectMake(CGRectGetMaxX(password.frame)-5, password.y, 40, 38);
    [showPassword setImage:[UIImage imageNamed:@"显示密码green"] forState:UIControlStateSelected];
    [showPassword setImage:[UIImage imageNamed:@"不显示数字"] forState:UIControlStateNormal];
    [showPassword addTarget:self action:@selector(showPasswordClicked) forControlEvents:UIControlEventTouchUpInside];
    self.showPasswordBtn = showPassword;
    [scrollView addSubview:showPassword];
    
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(30,CGRectGetMaxY(password.frame), SCREEN_WIDTH-60, .5)];
    footer.backgroundColor = ExtraLightBlackTextColor;
    [scrollView addSubview:footer];
    self.footer = footer;
    
    // 验证码图标
    UIButton *verifyIcon = [[UIButton alloc] initWithFrame:(CGRect){30,CGRectGetMaxY(telePhone.frame) + 20,60,40}];
    [scrollView addSubview:verifyIcon];
    //    [passIcon setImage:[UIImage imageNamed:@"密码"]];
    [verifyIcon setTitle:NSLocalizedString(@"Verification code", nil) forState:UIControlStateNormal];
    [verifyIcon setTitleColor:BlackTextColor forState:UIControlStateNormal];
    verifyIcon.contentMode = UIViewContentModeCenter;
    self.verifyIcon = verifyIcon;
    
    // 密码
    UITextField *verifyField = [[UITextField alloc]initWithFrame:CGRectMake(70+40,verifyIcon.y, SCREEN_WIDTH-60-40-40-100, 40)];
    //    password.placeholder = @"请输入登录密码";
    
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Please input verification code", nil) attributes:@{ NSForegroundColorAttributeName:ExtraLightBlackTextColor,                                            NSFontAttributeName:FONT(14)}];
    [verifyField setAttributedPlaceholder:str2];
    verifyField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //    password.backgroundColor = WhiteColor;
    [verifyField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    verifyField.font = FONT(18);
    //    [password addTarget:self action:@selector(textFieldTextChangeAction:) forControlEvents:UIControlEventEditingChanged];
    verifyField.secureTextEntry = NO;
    verifyField.tag = 0x333;
    verifyField.textColor = ExtraLightBlackTextColor;
    verifyField.delegate = self;
    self.verifyField = verifyField;
    [scrollView addSubview:verifyField];
    
    // 显示密码按钮
    UIButton *sendVerify = [UIButton buttonWithType:UIButtonTypeCustom];
    sendVerify.frame = CGRectMake(CGRectGetMaxX(verifyField.frame)-5, verifyField.y, 100, 38);
    [sendVerify setTitle:NSLocalizedString(@"Send verification code", nil) forState:UIControlStateNormal];
    [sendVerify addTarget:self action:@selector(sendVerifyClicked) forControlEvents:UIControlEventTouchUpInside];
    self.sendVerify = sendVerify;
    [sendVerify setTitleColor:ExtraLightBlackTextColor forState:UIControlStateNormal];
    [scrollView addSubview:sendVerify];
    
    
    // 注册账号
    UIButton *registerBtn = [HQHelper buttonWithFrame:CGRectMake(30, CGRectGetMaxY(footer.frame) + 10, 80, 44) target:self action:@selector(registerBtnClicked)];
    [scrollView addSubview:registerBtn];
    [registerBtn setTitle:@"注册账号" forState:UIControlStateNormal];
    [registerBtn setTitle:@"注册账号" forState:UIControlStateNormal];
    registerBtn.titleLabel.font = FONT(14);
    [registerBtn setTitleColor:HexColor(0xf17200) forState:UIControlStateNormal];
    [registerBtn setTitleColor:HexColor(0xf17200) forState:UIControlStateHighlighted];
    self.registerBtn = registerBtn;
    registerBtn.hidden = YES;
    
    // 忘记密码
    UIButton *forgetBtn = [HQHelper buttonWithFrame:CGRectMake(SCREEN_WIDTH-180-30, CGRectGetMaxY(footer.frame) + 10, 180, 44) target:self action:@selector(forgetPasswordClicked)];
    
    [scrollView addSubview:forgetBtn];
    [forgetBtn setTitle:NSLocalizedString(@"forget the password?", nil) forState:UIControlStateNormal];
    [forgetBtn setTitle:NSLocalizedString(@"forget the password?", nil) forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = FONT(14);
    [forgetBtn setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [forgetBtn setTitleColor:BlackTextColor forState:UIControlStateHighlighted];
    self.forgetBtn = forgetBtn;
    
    // 登录按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(30, CGRectGetMaxY(forgetBtn.frame) + 10, SCREEN_WIDTH - 60, 50);
    [loginBtn setTitle:NSLocalizedString(@"login", nil) forState:UIControlStateNormal];
    [loginBtn setTitle:NSLocalizedString(@"login", nil) forState:UIControlStateHighlighted];
    [loginBtn setTitle:NSLocalizedString(@"login", nil) forState:UIControlStateSelected];
    
    [loginBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateHighlighted];
    [loginBtn setBackgroundImage:[HQHelper createImageWithColor:HexAColor(0x3689E9, 0.7)] forState:UIControlStateDisabled];
//    loginBtn.enabled = NO;
    
    [loginBtn addTarget:self action:@selector(loginClicked:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.titleLabel.font = FONT(20);
    loginBtn.layer.cornerRadius = loginBtn.height/2;
    loginBtn.layer.masksToBounds = YES;
    [scrollView addSubview:loginBtn];
    self.loginBtn = loginBtn;
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:(CGRect){0,CGRectGetMaxY(loginBtn.frame)+20,SCREEN_WIDTH,20}];
    [scrollView addSubview:tipLabel];
    tipLabel.text = NSLocalizedString(@"Open a new generation of digital management", nil);
    tipLabel.font = FONT(14);
    tipLabel.textColor = ExtraLightBlackTextColor;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel = tipLabel;
    
    [self changeType:0];
    
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:setBtn];
    [setBtn setImage:IMG(@"设置灰色") forState:UIControlStateNormal];
    setBtn.frame = CGRectMake(30, SCREEN_HEIGHT-BottomM-44-30, 44, 44);
    [setBtn setImage:IMG(@"设置点击") forState:UIControlStateSelected];
    
    [setBtn addTarget:self action:@selector(setBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.setBtn = setBtn;
    
    
    UIButton *languageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:languageBtn];
    [languageBtn setImage:IMG(@"earth") forState:UIControlStateNormal];
    languageBtn.frame = CGRectMake(screenW-150-44, SCREEN_HEIGHT-BottomM-44-30, 150, 44);
    [languageBtn setImage:IMG(@"earth") forState:UIControlStateHighlighted];
    [languageBtn addTarget:self action:@selector(languageBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.languageBtn = languageBtn;
    
    UIButton *down = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:down];
    [down setImage:IMG(@"workDown") forState:UIControlStateNormal];
    down.frame = CGRectMake(screenW-30-44, SCREEN_HEIGHT-BottomM-44-30, 30, 44);
    [down setImage:IMG(@"workDown") forState:UIControlStateHighlighted];
    [down addTarget:self action:@selector(languageBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.down = down;
    
    [languageBtn setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
    [languageBtn setTitleColor:LightGrayTextColor forState:UIControlStateHighlighted];
    
    NSNumber *tag = [[NSUserDefaults standardUserDefaults] valueForKey:SelectLanguageTag];
    if (tag == nil) {
        [languageBtn setTitle:@"简体中文" forState:UIControlStateNormal];
        [languageBtn setTitle:@"简体中文" forState:UIControlStateHighlighted];
        [NSBundle setLanguage:self.codes[0]];
    }else{
        if (0 == [tag integerValue]) {
            [languageBtn setTitle:@"简体中文" forState:UIControlStateNormal];
            [languageBtn setTitle:@"简体中文" forState:UIControlStateHighlighted];
        }else if (1 == [tag integerValue]) {
            [languageBtn setTitle:@"繁體中文" forState:UIControlStateNormal];
            [languageBtn setTitle:@"繁體中文" forState:UIControlStateHighlighted];
        }else{
            
            [languageBtn setTitle:@"English" forState:UIControlStateNormal];
            [languageBtn setTitle:@"English" forState:UIControlStateHighlighted];
        }
        [NSBundle setLanguage:self.codes[[tag integerValue]]];
    }
    
}
- (void)selectDistrict{
    
    XWCountryCodeController *countryCodeVC = [[XWCountryCodeController alloc] init];
    
    __weak __typeof(self)weakSelf = self;
    countryCodeVC.returnCountryCodeBlock = ^(NSString *countryName, NSString *code) {
        [weakSelf.teleIcon setTitle:[NSString stringWithFormat:@"+%@",code] forState:UIControlStateNormal];
        [weakSelf.teleIcon setTitle:[NSString stringWithFormat:@"+%@",code] forState:UIControlStateNormal];
        weakSelf.district = code;
    };

    [self.navigationController pushViewController:countryCodeVC animated:YES];
}

-(void)setBtnClicked{
    TFSetUrlController *setUrl = [[TFSetUrlController alloc] init];
    [self.navigationController pushViewController:setUrl animated:YES];
}

-(void)maskTap:(UITapGestureRecognizer *)tap{
    [tap.view removeFromSuperview];
}

-(void)setupPopview{
    
    UIView *mask = [[UIView alloc] initWithFrame:(CGRect){0,0,screenW,screenH}];
    mask.backgroundColor = HexAColor(0xffffff, 0.8);
    [mask addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskTap:)]];
    UIView *popview = [[UIView alloc] initWithFrame:(CGRect){screenW-164,SCREEN_HEIGHT-BottomM-44-30-120,100,120}];
    [mask addSubview:popview];
    [self.view addSubview:mask];
    self.mask = mask;
    self.popview = popview;
    popview.backgroundColor = WhiteColor;
    popview.layer.borderWidth = 0.5;
    popview.layer.borderColor = [CellSeparatorColor CGColor];
    popview.layer.cornerRadius = 5.0;
    popview.layer.masksToBounds = YES;
    
    popview.layer.shadowColor = HexColor(0xe1e1e1).CGColor;//shadowColor阴影颜色
    popview.layer.shadowOffset = CGSizeMake(2,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    popview.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    popview.layer.shadowRadius = 2;//阴影半径，默认3
    
    NSArray *title = @[@"简体中文",@"繁體中文",@"English"];
    for (NSInteger i = 0; i < 3; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:title[i] forState:UIControlStateNormal];
        [btn setTitle:title[i] forState:UIControlStateHighlighted];
        [btn setTitle:title[i] forState:UIControlStateSelected];
        NSNumber *tag = [[NSUserDefaults standardUserDefaults] valueForKey:SelectLanguageTag];
        if (tag == nil) {
            if (i == 0) {
                btn.selected = YES;
            }
        }else{
            if (i == [tag integerValue]) {
                btn.selected = YES;
            }
        }
        [btn setTitleColor:BlackTextColor forState:UIControlStateNormal];
        [btn setTitleColor:BlackTextColor forState:UIControlStateHighlighted];
        [btn setTitleColor:GreenColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(selectLanguageClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [popview addSubview:btn];
        btn.frame = CGRectMake(0, 40 * i, 100, 40);
    }
}

-(void)selectLanguageClicked:(UIButton *)btn{
    
    [[NSUserDefaults standardUserDefaults] setValue:@(btn.tag) forKey:SelectLanguageTag];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSArray *views = self.popview.subviews;
    for (UIButton *b in views) {
        b.selected = NO;
    }
    btn.selected = YES;
    
    [NSBundle setLanguage:self.codes[btn.tag]];
    
    if (0 == btn.tag) {
        [self.languageBtn setTitle:@"简体中文" forState:UIControlStateNormal];
        [self.languageBtn setTitle:@"简体中文" forState:UIControlStateHighlighted];
    }else if (1 == btn.tag) {
        [self.languageBtn setTitle:@"繁體中文" forState:UIControlStateNormal];
        [self.languageBtn setTitle:@"繁體中文" forState:UIControlStateHighlighted];
    }else{
        
        [self.languageBtn setTitle:@"English" forState:UIControlStateNormal];
        [self.languageBtn setTitle:@"English" forState:UIControlStateHighlighted];
    }
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    [self setupChild];
    [self.bgImageView removeFromSuperview];
    self.scrollView.y = self.scrollView.y + 20;
    [self.mask removeFromSuperview];
}

-(void)languageBtnClicked{
    
    [self setupPopview];
    
}
-(void)longPress:(UILongPressGestureRecognizer *)gesture{
    
    [self.view endEditing:YES];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [TFSelectUrlView selectUrlViewWithUrl:self.url sure:^(NSString * parameter) {
            self.url = parameter;
            self.setBtn.selected = ![[AppDelegate shareAppDelegate].baseUrl isEqualToString:baseUrl];
            [HQRequestManager dellocManager];// 销毁单例
            
        }];
    }
}

#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (string.length) {
        
        if (![string haveNumberOrAlphabetOrSpecial]) {
            [MBProgressHUD showError:@"密码由数字、字母、特殊字符组成" toView:self.view];
            return NO;
        }
    }
    
    return YES;
}

/** 输入框文字改变 */
- (void)textFieldTextChangeAction:(UITextField *)textField{

//    BOOL tele = NO;
//    BOOL pass = NO;
//    if ([HQHelper checkTel:self.telePhoneField.text]) {
//        tele = YES;
//    }
//
//    if (self.passwordField.text.length > 5) {
//        pass = YES;
//    }
//
//    if (tele && pass) {
//        self.loginBtn.enabled = YES;
//    }else{
//        self.loginBtn.enabled = NO;
//    }
    
    HQLog(@"====%@====", textField.text);
    if ([HQHelper pureNumberWithStr:textField.text] && (textField.text.length > 3 && textField.text.length  < 12)) {
        self.accountLabel.hidden = YES;
    }else{
        self.accountLabel.hidden = NO;
    }
}

/** 0:显示密码 1:显示验证码 */
-(void)changeType:(NSInteger)type{
    if (type == 0) {
        self.passIcon.hidden = NO;
        self.passwordField.hidden = NO;
        self.showPasswordBtn.hidden = NO;
        
        self.verifyIcon.hidden = YES;
        self.verifyField.hidden = YES;
        self.sendVerify.hidden = YES;
        
    }else{
        
        self.passIcon.hidden = YES;
        self.passwordField.hidden = YES;
        self.showPasswordBtn.hidden = YES;
        
        self.verifyIcon.hidden = NO;
        self.verifyField.hidden = NO;
        self.sendVerify.hidden = NO;
        
    }
}


/** 显示密码按钮点击 */
- (void)showPasswordClicked{
    
    self.showPasswordBtn.selected = !self.showPasswordBtn.selected;
    self.passwordField.secureTextEntry = !self.passwordField.secureTextEntry;
}

/** 发送验证码 */
-(void)sendVerifyClicked{
    
    [self timeBtn:self.sendVerify];
    [self.loginBL requestGetVerificationWithUserName:self.telePhoneField.text type:@0];
    
}

//验证码计时按钮
-(void)timeBtn:(UIButton *)button
{
    __block int timeout=119; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [button setAttributedTitle:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"重发验证码", nil)] forState:UIControlStateNormal];
                button.width = 100;
                button.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 120;
            NSString *strTime = [NSString stringWithFormat:@"%.2ds ", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                NSString *str = @"后可重发";
                NSString *totalStr = [NSString stringWithFormat:@"%@%@",strTime,str];
                NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
                
                [attStr addAttribute:NSFontAttributeName value:FONT(12) range:NSMakeRange(0, attStr.string.length)];
                [attStr addAttribute:NSForegroundColorAttributeName value:HexColor(0xf94c4a) range:[totalStr rangeOfString:strTime]];
                [attStr addAttribute:NSForegroundColorAttributeName value:GreenColor range:[totalStr rangeOfString:str]];
                
                
                [button setAttributedTitle:attStr forState:UIControlStateNormal];
                
                button.userInteractionEnabled = NO;
                button.width = 135;
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}


/** 注册按钮点击 */
- (void)registerBtnClicked{
    
    TFInputTelephoneController *forget = [[TFInputTelephoneController alloc] init];
    forget.type = 0;
    [self.navigationController pushViewController:forget animated:YES];
}
/** 忘记密码按钮点击 */
- (void)forgetPasswordClicked{
    
    TFInputTelephoneController *forget = [[TFInputTelephoneController alloc] init];
    forget.type = 1;
    [self.navigationController pushViewController:forget animated:YES];
    
//    HQReSetPasswordController *ser = [[HQReSetPasswordController alloc] init];
//    [self.navigationController pushViewController:ser animated:YES];
}

/** 登录按钮点击 */
- (void)loginClicked:(UIButton *)button{
    
    [self.view endEditing:YES];
    
//    if (self.telePhoneField.text.length == 0) {
//        //        [MBProgressHUD showError:@"手机号输入有误" toView:self.view];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"login fail", nil) message:NSLocalizedString(@"Please enter your mobile phone number", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Sure", nil) otherButtonTitles:nil];
//            [alert show];
//        });
//        return;
//    }
    
    if (self.verifyField.hidden) {
        
        if (self.passwordField.text.length <= 0) {
            
            //        [MBProgressHUD showError:@"请输入密码" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"login fail", nil) message:NSLocalizedString(@"Please input a password", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Sure", nil) otherButtonTitles:nil];
                [alert show];
            });
            return;
        }
    }
    
//    if (![HQHelper checkTel:self.telePhoneField.text]) {
////        [MBProgressHUD showError:@"手机号输入有误" toView:self.view];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"login fail", nil) message:NSLocalizedString(@"手机号码格式不正确", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Sure", nil) otherButtonTitles:nil];
//            [alert show];
//        });
//        return;
//    }
    
    
    if (self.verifyField.hidden) {
        
        if (self.passwordField.text.length < 6 || self.passwordField.text.length > 16) {
            //        [MBProgressHUD showError:@"手机号输入有误" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"login fail", nil) message:NSLocalizedString(@"密码格式不正确", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Sure", nil) otherButtonTitles:nil];
                [alert show];
            });
            return;
        }
    }
    
    
    if (self.verifyField.hidden == NO) {
        
        if (self.verifyField.text.length != 6) {
            //        [MBProgressHUD showError:@"手机号输入有误" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"login fail", nil) message:NSLocalizedString(@"验证码不正确", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Sure", nil) otherButtonTitles:nil];
                [alert show];
            });
            return;
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:self.telePhoneField.text forKey:UserLoginTelephone];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *str = nil;
    if (self.district == nil || [self.district isEqualToString:@"86"]) {
        str = self.telePhoneField.text;
    }else{
        str = [NSString stringWithFormat:@"+%@-%@",self.district,self.telePhoneField.text];
    }
    
    // 登录
    if (self.verifyField.hidden) {// 密码登录
        [self.loginBL requestLoginWithUserName:str password:self.passwordField.text userCode:nil];
    }else{// 验证码登录
        [self.loginBL requestLoginWithUserName:str password:nil userCode:self.verifyField.text];
    }
}

#pragma mark - 网路请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_userLogin) {
        
        NSDictionary *dict = resp.body;
        
        if ([[dict valueForKey:@"term_sign"] isEqualToString:@"1"]) {
        
            [self.loginBL requestGetEmployeeInfoAndCompanyInfo];
        }

        if ([[dict valueForKey:@"term_sign"] isEqualToString:@"0"]) {

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"密码过期，请修改密码",nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Sure", nil) otherButtonTitles:nil];
                alert.delegate = self;
                alert.tag = 0x38;
                [alert show];
            });
        }
    }
    
    if (resp.cmdId == HQCMD_getEmployeeAndCompanyInfo) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginSuccess object:@1];
        if (self.modify) {
            [MBProgressHUD showImageSuccess:NSLocalizedString(@"修改成功", nil) toView:KeyWindow];
        }
    }
    
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        if (alertView.tag == 0x38) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            HQReSetPasswordController *reset = [[HQReSetPasswordController alloc] init];
            reset.phone = self.telePhoneField.text;
            reset.action = ^(NSString *parameter) {
              
                // 直接登录
                [self.loginBL requestLoginWithUserName:self.telePhoneField.text password:parameter userCode:nil];
                self.modify = YES;
            };
            [self.navigationController pushViewController:reset animated:YES];
        }
        if (alertView.tag == 20120021) {
            // 此处切换为验证码登录
            [self changeType:1];
        }
    }
}

- (void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    [MBProgressHUD showError:resp.errorDescription toView:self.view];
    if (resp.cmdId == HQCMD_userLogin) {
        
        NSString *str = [[resp.body valueForKey:@"response"] valueForKey:@"code"];
        if ([str isEqualToString:@"postprocess.username.password.sms.error"]) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"登录失败", nil) message:resp.errorDescription delegate:self cancelButtonTitle:NSLocalizedString(@"Sure", nil) otherButtonTitles:nil];
                alert.tag = 20120021;
                [alert show];
            });
        }else{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"登录失败", nil) message:resp.errorDescription delegate:self cancelButtonTitle:NSLocalizedString(@"Sure", nil) otherButtonTitles:nil];
                [alert show];
            });
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
