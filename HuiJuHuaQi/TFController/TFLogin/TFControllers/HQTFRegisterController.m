//
//  HQTFRegisterController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/13.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFRegisterController.h"
#import "HQTFLoginController.h"
#import "TFLoginBL.h"
#import "TFSetPasswordController.h"
#import "HQHelpDetailCtrl.h"

#define TopHeight 60



@interface HQTFRegisterController ()<HQBLDelegate>
/** 显示密码btn */
@property (nonatomic, weak) UIButton *showPassword;
/** 获取验证码btn */
@property (nonatomic, weak) UIButton *veriBtn;
/** 同意btn */
@property (nonatomic, weak) UIButton *agree;
/** regiBtnbtn */
@property (nonatomic, weak) UIButton *regiBtn;
/** 密码 */
@property (nonatomic, weak) UITextField *passwordField;
/** 手机号 */
@property (nonatomic, weak) UITextField *telePhone;
/** 验证码 */
@property (nonatomic, weak) UITextField *verification;

/** HQRegisterBL */
@property (nonatomic, strong) TFLoginBL *loginBL;

/** agree */
@property (nonatomic, assign) BOOL isAgree;

@end

@implementation HQTFRegisterController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginBL = [TFLoginBL build];
    self.loginBL.delegate = self;
    
    self.view.backgroundColor = WhiteColor;
//    [self setFromNavBottomEdgeLayout];
    [self setupChild];
    
    if (self.VCType == 0) {
        self.navigationItem.title = @"注册";
//        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(loginClicked) text:@"登录"];
    }else{
        self.navigationItem.title = @"找回密码";
    }
    
}

- (void)loginClicked{
    HQTFLoginController *login = [[HQTFLoginController alloc] init];
    [self.navigationController pushViewController:login animated:YES];
}

#pragma mark - childView
- (void)setupChild{
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView.bounces = YES;
    scrollView.scrollEnabled = YES;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT<667?667:SCREEN_HEIGHT);
    [self.view addSubview:scrollView];
    
    UITextField *telePhone = [[UITextField alloc]initWithFrame:CGRectMake(30,TopHeight, SCREEN_WIDTH-60, 40)];
    if (self.VCType == 0) {
        telePhone.placeholder = @"请输入手机号";
    }else{
        telePhone.placeholder = @"请输入已注册手机号";
    }
    telePhone.clearButtonMode = UITextFieldViewModeWhileEditing;
    [telePhone setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    telePhone.font = FONT(18);
    telePhone.keyboardType = UIKeyboardTypeNumberPad;
    [telePhone addTarget:self action:@selector(textFieldTextChangeAction:) forControlEvents:UIControlEventEditingChanged];
    telePhone.tag = 0x111;
//    telePhone.layer.cornerRadius = 4;
//    telePhone.layer.masksToBounds = YES;
//    telePhone.backgroundColor = WhiteColor;
    self.telePhone = telePhone;
    [scrollView addSubview:telePhone];
    
    UIView *telePhoneBg = [[UIView alloc] initWithFrame:CGRectMake(30,CGRectGetMaxY(telePhone.frame) , SCREEN_WIDTH-60, .5)];
    telePhoneBg.backgroundColor = CellSeparatorColor;
    [scrollView addSubview:telePhoneBg];
    
    
    UITextField *verification = [[UITextField alloc]initWithFrame:CGRectMake(30,CGRectGetMaxY(telePhoneBg.frame) + 20, SCREEN_WIDTH-60 - 150, 40)];
    verification.placeholder = @"请输入验证码";
    verification.clearButtonMode = UITextFieldViewModeWhileEditing;
    [verification setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    verification.font = FONT(18);
    verification.keyboardType = UIKeyboardTypeNumberPad;
    [verification addTarget:self action:@selector(textFieldTextChangeAction:) forControlEvents:UIControlEventEditingChanged];
    verification.tag = 0x222;
//    verification.layer.cornerRadius = 4;
//    verification.layer.masksToBounds = YES;
//    verification.backgroundColor = WhiteColor;
    self.verification = verification;
    [scrollView addSubview:verification];
    
    UIButton *veriBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 110 - 30, verification.y, 110, 40)];
    veriBtn.backgroundColor = GreenColor;
    veriBtn.layer.masksToBounds = YES;
    veriBtn.layer.cornerRadius = 5;
    [veriBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [veriBtn setTitleColor:WhiteColor forState:UIControlStateHighlighted];
    [veriBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [veriBtn setTitle:@"获取验证码" forState:UIControlStateHighlighted];
    [veriBtn addTarget:self action:@selector(getVerificationNum:) forControlEvents:UIControlEventTouchUpInside];
    [veriBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
    veriBtn.titleLabel.font = FONT(16);
    [scrollView addSubview:veriBtn];
    self.veriBtn = veriBtn;
    
    
    UIView *veriBg = [[UIView alloc] initWithFrame:CGRectMake(30,CGRectGetMaxY(verification.frame), SCREEN_WIDTH-60, .5)];
    veriBg.backgroundColor = CellSeparatorColor;
    [scrollView addSubview:veriBg];
    
//    UITextField *password = [[UITextField alloc]initWithFrame:CGRectMake(30,CGRectGetMaxY(verification.frame) + 20, SCREEN_WIDTH-60-40, 40)];
//    password.placeholder = @"请设置登录密码（6位及以上）";
//    
//    password.clearButtonMode = UITextFieldViewModeWhileEditing;
//    [password setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
//    password.font = FONT(18);
//    [password addTarget:self action:@selector(textFieldTextChangeAction:) forControlEvents:UIControlEventEditingChanged];
//    password.secureTextEntry = YES;
//    password.tag = 0x333;
////    password.layer.cornerRadius = 4;
////    password.layer.masksToBounds = YES;
////    password.backgroundColor = WhiteColor;
//    self.passwordField = password;
//    [scrollView addSubview:password];
//    
//    // 显示密码按钮
//    UIButton *showPassword = [UIButton buttonWithType:UIButtonTypeCustom];
//    showPassword.frame = CGRectMake(CGRectGetMaxX(password.frame)-5, password.y, 40, 38);
//    [showPassword setImage:[UIImage imageNamed:@"显示数字"] forState:UIControlStateSelected];
//    [showPassword setImage:[UIImage imageNamed:@"不显示数字"] forState:UIControlStateNormal];
//    [showPassword addTarget:self action:@selector(showPasswordClicked) forControlEvents:UIControlEventTouchUpInside];
//    self.showPassword = showPassword;
//    [scrollView addSubview:showPassword];
    
    
//    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(30,CGRectGetMaxY(password.frame), SCREEN_WIDTH-60, .5)];
//    footer.backgroundColor = CellSeparatorColor;
//    [scrollView addSubview:footer];
//    
//    NSString *agreeStr = @" 我已同意服务条款，以及隐私政策";
//    
//    // 同意按钮
//    UIButton *agree = [UIButton buttonWithType:UIButtonTypeCustom];
//    agree.frame = CGRectMake(30, footer.y + 10, SCREEN_WIDTH - 60, 50);
//    [agree setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
//    [agree setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
//    [agree setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateHighlighted];
//    [agree setTitleColor:GrayTextColor forState:UIControlStateNormal];
//    [agree setTitleColor:GrayTextColor forState:UIControlStateHighlighted];
//    [agree setTitleColor:GreenColor forState:UIControlStateSelected];
//    [agree setTitle:agreeStr forState:UIControlStateNormal];
//    [agree setTitle:agreeStr forState:UIControlStateHighlighted];
//    [agree setTitle:agreeStr forState:UIControlStateSelected];
//    agree.selected = YES;
//    self.isAgree = YES;
//    [agree addTarget:self action:@selector(agreeClicked:) forControlEvents:UIControlEventTouchUpInside];
//    agree.titleLabel.font = FONT(14);
//    self.agree = agree;
//    self.agree.hidden = YES;
   
    // 注册按钮
    UIButton *regiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    regiBtn.frame = CGRectMake(30, CGRectGetMaxY(veriBg.frame) + 30, SCREEN_WIDTH - 60, 50);
    
//    [regiBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
//    [regiBtn setTitleColor:WhiteColor forState:UIControlStateHighlighted];
//    [regiBtn setTitleColor:WhiteColor forState:UIControlStateSelected];
    
    if (self.VCType == 0) {
        [regiBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [regiBtn setTitle:@"下一步" forState:UIControlStateHighlighted];
        [regiBtn setTitle:@"下一步" forState:UIControlStateSelected];
    }else{
        
        [regiBtn setTitle:@"确定" forState:UIControlStateNormal];
        [regiBtn setTitle:@"确定" forState:UIControlStateHighlighted];
        [regiBtn setTitle:@"确定" forState:UIControlStateSelected];
    }
    
    [regiBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
    [regiBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateHighlighted];
    [regiBtn setBackgroundImage:[HQHelper createImageWithColor:HexAColor(0xc8c8c8, 1)] forState:UIControlStateDisabled];
    
    [regiBtn addTarget:self action:@selector(regiBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    regiBtn.titleLabel.font = FONT(20);
    regiBtn.layer.cornerRadius = 4;
    regiBtn.layer.masksToBounds = YES;
//    regiBtn.enabled = NO;
    [scrollView addSubview:regiBtn];
    self.regiBtn = regiBtn;
    
    if (self.VCType == 0) {
        telePhone.placeholder = @"请输入手机号";
//        [scrollView addSubview:agree];
    }else{
//        telePhone.placeholder = @"请输入已注册手机号";
//        regiBtn.frame = CGRectMake(30, CGRectGetMaxY(footer.frame) + 40, SCREEN_WIDTH - 60, 50);
    }
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:(CGRect){0,CGRectGetMaxY(regiBtn.frame)+ 20,SCREEN_WIDTH,30}];
    tipLabel.font = FONT(14);
    tipLabel.textColor = GrayTextColor;
    tipLabel.text = @"点击上面按钮“下一步”即表示您同意";
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:tipLabel];
    
    
    UIButton *serviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    serviceBtn.frame = CGRectMake(SCREEN_WIDTH/6, CGRectGetMaxY(tipLabel.frame) + 0, SCREEN_WIDTH/3, 44);
    [scrollView addSubview:serviceBtn];
    [serviceBtn setTitle:@"《服务协议》" forState:UIControlStateNormal];
    [serviceBtn setTitle:@"《服务协议》" forState:UIControlStateHighlighted];
    [serviceBtn setTitle:@"《服务协议》" forState:UIControlStateSelected];
    serviceBtn.titleLabel.font =  FONT(14);
    [serviceBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    [serviceBtn setTitleColor:GreenColor forState:UIControlStateHighlighted];
    [serviceBtn addTarget:self action:@selector(serviceClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *privacyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    privacyBtn.frame = CGRectMake(SCREEN_WIDTH/2, CGRectGetMaxY(tipLabel.frame) + 0, SCREEN_WIDTH/3, 44);
    [scrollView addSubview:privacyBtn];
    [privacyBtn setTitle:@"《隐私政策》" forState:UIControlStateNormal];
    [privacyBtn setTitle:@"《隐私政策》" forState:UIControlStateHighlighted];
    [privacyBtn setTitle:@"《隐私政策》" forState:UIControlStateSelected];
    privacyBtn.titleLabel.font =  FONT(14);
    [privacyBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    [privacyBtn setTitleColor:GreenColor forState:UIControlStateHighlighted];
    [privacyBtn addTarget:self action:@selector(privacyClicked) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.VCType == 1) {
        tipLabel.hidden = YES;
        serviceBtn.hidden = YES;
        privacyBtn.hidden = YES;
    }
}

- (void)serviceClicked{
    
    HQHelpDetailCtrl *service = [[HQHelpDetailCtrl alloc] init];
    service.htmlUrl = [[NSBundle mainBundle] pathForResource:@"terms_of_service" ofType:@"html"];
    service.title = @"服务协议";
    [self.navigationController pushViewController:service animated:YES];
}
- (void)privacyClicked{
    HQHelpDetailCtrl *service = [[HQHelpDetailCtrl alloc] init];
    service.htmlUrl = [[NSBundle mainBundle] pathForResource:@"Confidentilty_agreement" ofType:@"html"];
    service.title = @"隐私政策";
    [self.navigationController pushViewController:service animated:YES];
}

- (void)showPasswordClicked{
    
    self.showPassword.selected = !self.showPassword.selected;
    self.passwordField.secureTextEntry = !self.passwordField.secureTextEntry;
    
}
-(void)getVerificationNum:(UIButton *)sender{
    
    
    if (![HQHelper checkTel:self.telePhone.text]) {
        [MBProgressHUD showError:@"手机号输入有误！" toView:self.view];
        return;
    }else{
        
        
        [self.verification becomeFirstResponder];
        
        if (self.VCType == 0) {// 注册
            
            [self.loginBL requestGetVerificationWithUserName:self.telePhone.text type:@1];
            
        }else{// 忘记密码
            
            [self.loginBL requestGetVerificationWithUserName:self.telePhone.text type:@2];
        }
    }
    
    
}


- (void)textFieldTextChangeAction:(UITextField *)textField{
    
    
}

- (void)agreeClicked:(UIButton *)button{
    button.selected = !button.selected;
    self.isAgree = button.selected;
}

- (void)regiBtnClicked:(UIButton *)button{
    
    
    if (![HQHelper checkTel:self.telePhone.text]) {
        [MBProgressHUD showError:@"输入的手机号不合法" toView:self.view];
        return;
    }
    
    if (![HQHelper checkSure:self.verification.text]) {
        [MBProgressHUD showError:@"验证码不合法" toView:self.view];
        return;
    }

    
    if (self.VCType == 0) {// 注册界面
    
        [self.loginBL requestVerificationWithUserName:self.telePhone.text code:self.verification.text type:@1];
        
    }else{// 忘记密码界面
        
        [self.loginBL requestVerificationWithUserName:self.telePhone.text code:self.verification.text type:@2];
    }
    
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
   
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (resp.cmdId == HQCMD_sendVerifyCode) {
        
        [HQHelper timeBtn:self.veriBtn];
        
    }
    
    if (resp.cmdId == HQCMD_verifyVerificationCode) {
        
        TFSetPasswordController *set = [[TFSetPasswordController alloc] init];
        set.type = self.VCType;
        
        set.telephone = self.telePhone.text;
        [self.navigationController pushViewController:set animated:YES];
        
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
    
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
