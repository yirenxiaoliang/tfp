//
//  HQTFLoginController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/13.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFLoginController.h"
#import "HQTFRegisterController.h"
#import "TFLoginBL.h"
#import "HQUserModel.h"
#import "TFSetPasswordController.h"
#import "TFFinishInfoController.h"

@interface HQTFLoginController ()<HQBLDelegate>

/** 同意btn */
@property (nonatomic, weak) UIButton *agree;
/** regiBtnbtn */
@property (nonatomic, weak) UIButton *regiBtn;
/** 显示密码btn */
@property (nonatomic, weak) UIButton *showPassword;

/** 密码 */
@property (nonatomic, weak) UITextField *passwordField;
/** 手机号 */
@property (nonatomic, weak) UITextField *telePhone;

/** registerBL */
@property (nonatomic, strong) TFLoginBL *loginBL;

@end

@implementation HQTFLoginController

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
    [self setFromNavBottomEdgeLayout];
    [self setupChild];
    
    if (self.VCType == 0) {
        self.navigationItem.title = @"登录";
    }
}
#pragma mark - 子控件
- (void)setupChild{
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,SCREEN_HEIGHT}];
    if (SCREEN_HEIGHT<667) {
        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 667);
    }
    [self.view addSubview:scrollView];
    
    // logo
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    logo.frame = CGRectMake((SCREEN_WIDTH - Long(240))/2, Long(62), Long(240), Long(80));
    [scrollView addSubview:logo];
    logo.contentMode = UIViewContentModeCenter;
    
    //telephone
    UITextField *telePhone = [[UITextField alloc]initWithFrame:CGRectMake(30,CGRectGetMaxY(logo.frame) + Long(60), SCREEN_WIDTH-60, 40)];
    telePhone.placeholder = @"请输入手机号";
    telePhone.clearButtonMode = UITextFieldViewModeWhileEditing;
    [telePhone setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    telePhone.font = FONT(18);
    telePhone.keyboardType = UIKeyboardTypeNumberPad;
    [telePhone addTarget:self action:@selector(textFieldTextChangeAction:) forControlEvents:UIControlEventEditingChanged];
    telePhone.tag = 0x111;
    telePhone.text = [[NSUserDefaults standardUserDefaults] objectForKey:UserLoginTelephone];
    //    telePhone.layer.cornerRadius = 4;
    //    telePhone.layer.masksToBounds = YES;
    //    telePhone.backgroundColor = WhiteColor;
    self.telePhone = telePhone;
    [scrollView addSubview:telePhone];
    
    UIView *telePhoneBg = [[UIView alloc] initWithFrame:CGRectMake(30,CGRectGetMaxY(telePhone.frame) , SCREEN_WIDTH-60, .5)];
    telePhoneBg.backgroundColor = CellSeparatorColor;
    [scrollView addSubview:telePhoneBg];
    
    
    UITextField *password = [[UITextField alloc]initWithFrame:CGRectMake(30,CGRectGetMaxY(telePhone.frame) + 20, SCREEN_WIDTH-60-40, 40)];
    password.placeholder = @"请输入登录密码";
    password.clearButtonMode = UITextFieldViewModeWhileEditing;
    [password setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    password.font = FONT(18);
    [password addTarget:self action:@selector(textFieldTextChangeAction:) forControlEvents:UIControlEventEditingChanged];
    password.secureTextEntry = YES;
    password.tag = 0x333;
    //    password.layer.cornerRadius = 4;
    //    password.layer.masksToBounds = YES;
    //    password.backgroundColor = WhiteColor;
    self.passwordField = password;
    [scrollView addSubview:password];
    
    // 显示密码按钮
    UIButton *showPassword = [UIButton buttonWithType:UIButtonTypeCustom];
    showPassword.frame = CGRectMake(CGRectGetMaxX(password.frame)-5, password.y, 40, 38);
    [showPassword setImage:[UIImage imageNamed:@"显示数字"] forState:UIControlStateSelected];
    [showPassword setImage:[UIImage imageNamed:@"不显示数字"] forState:UIControlStateNormal];
    [showPassword addTarget:self action:@selector(showPasswordClicked) forControlEvents:UIControlEventTouchUpInside];
    self.showPassword = showPassword;
    [scrollView addSubview:showPassword];
    
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(30,CGRectGetMaxY(password.frame), SCREEN_WIDTH-60, .5)];
    footer.backgroundColor = CellSeparatorColor;
    [scrollView addSubview:footer];
    
    NSString *agreeStr = @" 我已同意服务条款，以及隐私政策";
    
    // 同意按钮
    UIButton *agree = [UIButton buttonWithType:UIButtonTypeCustom];
    agree.frame = CGRectMake(30, footer.y + 10, SCREEN_WIDTH - 60, 50);
    [agree setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    [agree setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [agree setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateHighlighted];
    [agree setTitleColor:GrayTextColor forState:UIControlStateNormal];
    [agree setTitleColor:GrayTextColor forState:UIControlStateHighlighted];
    [agree setTitleColor:GreenColor forState:UIControlStateSelected];
    [agree setTitle:agreeStr forState:UIControlStateNormal];
    [agree setTitle:agreeStr forState:UIControlStateHighlighted];
    [agree setTitle:agreeStr forState:UIControlStateSelected];
    agree.selected = YES;
    [agree addTarget:self action:@selector(agreeClicked:) forControlEvents:UIControlEventTouchUpInside];
    agree.titleLabel.font = FONT(14);
    self.agree = agree;
    
    
    // 注册按钮
    UIButton *regiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    regiBtn.frame = CGRectMake(30, CGRectGetMaxY(agree.frame) + 10, SCREEN_WIDTH - 60, 50);
    
    //    [regiBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    //    [regiBtn setTitleColor:WhiteColor forState:UIControlStateHighlighted];
    //    [regiBtn setTitleColor:WhiteColor forState:UIControlStateSelected];
    [regiBtn setTitle:@"登录" forState:UIControlStateNormal];
    [regiBtn setTitle:@"登录" forState:UIControlStateHighlighted];
    [regiBtn setTitle:@"登录" forState:UIControlStateSelected];
    
    [regiBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
    [regiBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateHighlighted];
    [regiBtn setBackgroundImage:[HQHelper createImageWithColor:HexAColor(0xc8c8c8, 1)] forState:UIControlStateDisabled];
    
    [regiBtn addTarget:self action:@selector(loginClicked:) forControlEvents:UIControlEventTouchUpInside];
    regiBtn.titleLabel.font = FONT(20);
    regiBtn.layer.cornerRadius = 4;
    regiBtn.layer.masksToBounds = YES;
    [scrollView addSubview:regiBtn];
    self.regiBtn = regiBtn;
    
    if (self.VCType == 0) {
        password.placeholder = @"请输入登录密码";
        regiBtn.frame = CGRectMake(30, CGRectGetMaxY(footer.frame) + 40, SCREEN_WIDTH - 60, 50);
        password.secureTextEntry = YES;
        password.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }else{
        password.placeholder = @"请输入邀请码";
        [scrollView addSubview:agree];
        showPassword.hidden = YES;
        password.secureTextEntry = NO;
        password.keyboardType = UIKeyboardTypeNumberPad;
    }

    
    // 注册按钮
    UIButton *WeChat = [UIButton buttonWithType:UIButtonTypeCustom];
    WeChat.frame = CGRectMake(30, CGRectGetMaxY(regiBtn.frame) + 20, SCREEN_WIDTH - 60, 50);
    
    [WeChat setTitleColor:GreenColor forState:UIControlStateNormal];
    [WeChat setTitleColor:GreenColor forState:UIControlStateHighlighted];
    [WeChat setTitleColor:GreenColor forState:UIControlStateSelected];
    [WeChat setTitle:@"微信登录" forState:UIControlStateNormal];
    [WeChat setTitle:@"微信登录" forState:UIControlStateHighlighted];
    [WeChat setTitle:@"微信登录" forState:UIControlStateSelected];
//    [WeChat setTitle:@"邀请码登录" forState:UIControlStateNormal];
//    [WeChat setTitle:@"邀请码登录" forState:UIControlStateHighlighted];
//    [WeChat setTitle:@"邀请码登录" forState:UIControlStateSelected];
    
    [WeChat setBackgroundImage:[HQHelper createImageWithColor:HexAColor(0xf2f2f2, 1)] forState:UIControlStateNormal];
    [WeChat setBackgroundImage:[HQHelper createImageWithColor:HexAColor(0xf2f2f2, 1)] forState:UIControlStateHighlighted];
    [WeChat setBackgroundImage:[HQHelper createImageWithColor:HexAColor(0xf2f2f2, 1)] forState:UIControlStateDisabled];
    
    [WeChat addTarget:self action:@selector(WeChatClicked) forControlEvents:UIControlEventTouchUpInside];
    WeChat.titleLabel.font = FONT(20);
    WeChat.layer.cornerRadius = 4;
    WeChat.layer.masksToBounds = YES;
    
    // QQ登录
    CGFloat btnW = 120;
    UIButton *QQ = [HQHelper buttonWithFrame:CGRectMake((SCREEN_WIDTH - 2 * btnW)/3, SCREEN_HEIGHT-64-50-20, btnW, 50) normalImageStr:nil seletedImageStr:nil highImageStr:nil target:self action:@selector(QQClicked)];
    QQ.titleLabel.font = FONT(20);
    [QQ setTitle:@"QQ登录" forState:UIControlStateNormal];
    [QQ setTitle:@"QQ登录" forState:UIControlStateHighlighted];
    [QQ setTitle:@"QQ登录" forState:UIControlStateSelected];
    [QQ setTitleColor:GrayTextColor forState:UIControlStateNormal];
    [QQ setTitleColor:GrayTextColor forState:UIControlStateHighlighted];
    [QQ setTitleColor:GrayTextColor forState:UIControlStateSelected];

    
    // 邀请码登录
    UIButton *invite = [HQHelper buttonWithFrame:CGRectMake(2 * (SCREEN_WIDTH - 2 * btnW)/3 + btnW, SCREEN_HEIGHT-64-50-20, btnW, 50) normalImageStr:nil seletedImageStr:nil highImageStr:nil target:self action:@selector(inviteClicked)];
    invite.titleLabel.font = FONT(20);
    [invite setTitle:@"邀请码登录" forState:UIControlStateNormal];
    [invite setTitle:@"邀请码登录" forState:UIControlStateHighlighted];
    [invite setTitle:@"邀请码登录" forState:UIControlStateSelected];
    [invite setTitleColor:GrayTextColor forState:UIControlStateNormal];
    [invite setTitleColor:GrayTextColor forState:UIControlStateHighlighted];
    [invite setTitleColor:GrayTextColor forState:UIControlStateSelected];

    
    if (self.VCType == 0) {
        // 暂时屏蔽
//        [scrollView addSubview:WeChat];
//        [scrollView addSubview:QQ];
//        [scrollView addSubview:invite];
    }
    
    UIButton *forgetBtn = [HQHelper buttonWithFrame:CGRectMake(SCREEN_WIDTH/2, CGRectGetMaxY(regiBtn.frame) + 10, SCREEN_WIDTH/2, 44) target:self action:@selector(forgetPassword)];
    [scrollView addSubview:forgetBtn];
    [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = FONT(14);
    [forgetBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    [forgetBtn setTitleColor:GreenColor forState:UIControlStateHighlighted];
    
}


- (void)showPasswordClicked{
    
    self.showPassword.selected = !self.showPassword.selected;
    self.passwordField.secureTextEntry = !self.passwordField.secureTextEntry;
    
}

- (void)textFieldTextChangeAction:(UITextField *)textField{
    
}

- (void)agreeClicked:(UIButton *)button{
    button.selected = !button.selected;
}

- (void)loginClicked:(UIButton *)button{
    
    [self.view endEditing:YES];
    
    
    if (![HQHelper checkTel:self.telePhone.text]) {
        [MBProgressHUD showError:@"手机号输入有误" toView:self.view];
        return;
    }
    
    if (self.passwordField.text.length == 0) {
        
        [MBProgressHUD showError:@"请输入密码" toView:self.view];
            
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.telePhone.text forKey:UserLoginTelephone];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // 登录
    [self.loginBL requestLoginWithUserName:self.telePhone.text password:self.passwordField.text userCode:nil];
    
}

- (void)WeChatClicked{

    
}

- (void)QQClicked{

}

- (void)inviteClicked{
    HQTFLoginController *inviteLogin = [[HQTFLoginController alloc] init];
    inviteLogin.VCType = TypeOther;
    [self.navigationController pushViewController:inviteLogin animated:YES];
}
#pragma mark - 忘记密码
- (void)forgetPassword{
    HQTFRegisterController *regi = [[HQTFRegisterController alloc] init];
    regi.VCType = 1;
    [self.navigationController pushViewController:regi animated:YES];
}


#pragma mark - 网路请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (resp.cmdId == HQCMD_userLogin) {
        
        NSDictionary *dict = resp.body;
        
        if ([[dict valueForKey:@"perfect"] isEqualToString:@"0"]) {// 未完善信息
            
            if ([[dict valueForKey:@"isCompany"] isEqualToString:@"0"]) {// 完善公司
                
                
                TFFinishInfoController *finish = [[TFFinishInfoController alloc] init];
                finish.type = FinishInfoType_company;
                [self.navigationController pushViewController:finish animated:YES];
            }
            
            if ([[dict valueForKey:@"isCompany"] isEqualToString:@"1"]) {// 完善员工
                
                TFFinishInfoController *finish = [[TFFinishInfoController alloc] init];
                finish.type = FinishInfoType_person;
                [self.navigationController pushViewController:finish animated:YES];
            }
            
        }else{
            
            [self.loginBL requestGetEmployeeInfoAndCompanyInfo];
            
        }
        
    }
    
    if (resp.cmdId == HQCMD_getEmployeeAndCompanyInfo) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginSuccess object:@1];
    }
    
    
    
}

- (void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
    
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
