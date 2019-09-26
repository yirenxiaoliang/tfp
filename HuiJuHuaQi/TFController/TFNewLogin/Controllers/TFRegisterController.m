//
//  TFRegisterController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/2/26.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFRegisterController.h"
#import "TFLoginBL.h"
#import "TFNewLoginController.h"
#import "HQTFLoginMainController.h"

@interface TFRegisterController ()<HQBLDelegate,UIAlertViewDelegate,UITextFieldDelegate>
/** companyField */
@property (nonatomic, weak) UITextField *companyField;
/** nameField */
@property (nonatomic, weak) UITextField *nameField;
/** passWordField */
@property (nonatomic, weak) UITextField *passWordField;
/** inviteField */
@property (nonatomic, weak) UITextField *inviteField;
/** stepBtn */
@property (nonatomic, weak) UIButton *stepBtn;
/** loginBL */
@property (nonatomic, strong) TFLoginBL *loginBL;

@end

@implementation TFRegisterController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:ClearColor size:(CGSize){SCREEN_WIDTH,0.5}]];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupChild];
    self.navigationItem.title = @"注册";
    self.loginBL = [TFLoginBL build];
    self.loginBL.delegate = self;
    
}

- (void)setupChild{
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,SCREEN_HEIGHT}];
    if (SCREEN_HEIGHT<667) {
        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 667);
    }
    [self.view addSubview:scrollView];
    scrollView.backgroundColor = WhiteColor;
    
    // 公司
    UITextField *company = [[UITextField alloc]initWithFrame:CGRectMake(30,60, SCREEN_WIDTH-60, 40)];
    company.placeholder = @"请输入公司名称（必填）";
    company.clearButtonMode = UITextFieldViewModeWhileEditing;
    [company setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    company.font = FONT(18);
    company.keyboardType = UIKeyboardTypeDefault;
    [company addTarget:self action:@selector(textFieldTextChangeAction:) forControlEvents:UIControlEventEditingChanged];
    company.tag = 0x111;
    self.companyField = company;
    company.textColor = BlackTextColor;
    [scrollView addSubview:company];
    
    UIView *companyBg = [[UIView alloc] initWithFrame:CGRectMake(30,CGRectGetMaxY(company.frame) , SCREEN_WIDTH-60, .5)];
    companyBg.backgroundColor = HexColor(0xe7e7e7);
    [scrollView addSubview:companyBg];
    
    
    // 姓名
    UITextField *name = [[UITextField alloc]initWithFrame:CGRectMake(30,CGRectGetMaxY(companyBg.frame) + 15, SCREEN_WIDTH-60, 40)];
    name.placeholder = @"请输入姓名（必填）";
    name.clearButtonMode = UITextFieldViewModeWhileEditing;
    [name setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    name.font = FONT(18);
    name.keyboardType = UIKeyboardTypeDefault;
    [name addTarget:self action:@selector(textFieldTextChangeAction:) forControlEvents:UIControlEventEditingChanged];
    name.tag = 0x222;
    self.nameField = name;
    name.textColor = BlackTextColor;
    [scrollView addSubview:name];
    
    UIView *nameBg = [[UIView alloc] initWithFrame:CGRectMake(30,CGRectGetMaxY(name.frame) , SCREEN_WIDTH-60, .5)];
    nameBg.backgroundColor = HexColor(0xe7e7e7);
    [scrollView addSubview:nameBg];
    
    
    // 密码
    UITextField *password = [[UITextField alloc]initWithFrame:CGRectMake(30,CGRectGetMaxY(nameBg.frame) + 15, SCREEN_WIDTH-60, 40)];
    password.placeholder = @"请输入6位及以上登录密码（必填）";
    password.clearButtonMode = UITextFieldViewModeWhileEditing;
    [password setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    password.font = FONT(18);
    password.keyboardType = UIKeyboardTypeEmailAddress;
    [password addTarget:self action:@selector(textFieldTextChangeAction:) forControlEvents:UIControlEventEditingChanged];
    password.tag = 0x333;
    self.passWordField = password;
    password.delegate = self;
    password.textColor = BlackTextColor;
    [scrollView addSubview:password];
    
    UIView *passwordBg = [[UIView alloc] initWithFrame:CGRectMake(30,CGRectGetMaxY(password.frame) , SCREEN_WIDTH-60, .5)];
    passwordBg.backgroundColor = HexColor(0xe7e7e7);
    [scrollView addSubview:passwordBg];
    
    /**
    // invite
    UITextField *invite = [[UITextField alloc]initWithFrame:CGRectMake(30,CGRectGetMaxY(passwordBg.frame) + 15, SCREEN_WIDTH-60, 40)];
    invite.placeholder = @"请输入邀请码（非必填）";
    invite.clearButtonMode = UITextFieldViewModeWhileEditing;
    [invite setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    invite.font = FONT(18);
    invite.keyboardType = UIKeyboardTypeEmailAddress;
    [invite addTarget:self action:@selector(textFieldTextChangeAction:) forControlEvents:UIControlEventEditingChanged];
    invite.tag = 0x444;
    self.inviteField = invite;
    invite.textColor = BlackTextColor;
    [scrollView addSubview:invite];
    
    UIView *inviteBg = [[UIView alloc] initWithFrame:CGRectMake(30,CGRectGetMaxY(invite.frame) , SCREEN_WIDTH-60, .5)];
    inviteBg.backgroundColor = HexColor(0xe7e7e7);
    [scrollView addSubview:inviteBg];
    */
    
    // 下一步按钮
    UIButton *stepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    stepBtn.frame = CGRectMake(30, CGRectGetMaxY(passwordBg.frame) + 30, SCREEN_WIDTH - 60, 50);
    [stepBtn setTitle:@"注册" forState:UIControlStateNormal];
    [stepBtn setTitle:@"注册" forState:UIControlStateHighlighted];
    [stepBtn setTitle:@"注册" forState:UIControlStateSelected];
    
    [stepBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
    [stepBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateHighlighted];
    [stepBtn setBackgroundImage:[HQHelper createImageWithColor:HexAColor(0x3689E9, 0.5)] forState:UIControlStateDisabled];
//    stepBtn.enabled = NO;
    [stepBtn addTarget:self action:@selector(stepClicked:) forControlEvents:UIControlEventTouchUpInside];
    stepBtn.titleLabel.font = FONT(20);
    stepBtn.layer.cornerRadius = 4;
    stepBtn.layer.masksToBounds = YES;
    [scrollView addSubview:stepBtn];
    self.stepBtn = stepBtn;
}

#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.tag == 0x333) {
        
        if (string.length) {
            
            if (![string haveNumberOrAlphabetOrSpecial]) {
                [MBProgressHUD showError:@"密码由数字、字母、特殊字符组成" toView:self.view];
                return NO;
            }
        }
    }
    
    return YES;
}

- (void)textFieldTextChangeAction:(UITextField *)textfield{
    
    if (textfield.tag == 0x111) {
        
    }else if (textfield.tag == 0x222){
        
    }else if (textfield.tag == 0x333){
        
    }else{
        
    }
    
//    if (self.companyField.text.length && self.nameField.text.length && self.passWordField.text.length >= 6) {
//
//        self.stepBtn.enabled = YES;
//    }
//    else{
//        self.stepBtn.enabled = NO;
//    }
}

- (void)stepClicked:(UIButton *)button{
    
    [self.view endEditing:YES];
    
    if (!self.companyField.text.length) {
        [MBProgressHUD showError:@"请输入公司名称" toView:self.view];
        return;
    }
    if (self.companyField.text.length < 4) {
        [MBProgressHUD showError:@"公司名称4个字及以上" toView:self.view];
        return;
    }
    if (!self.nameField.text.length) {
        [MBProgressHUD showError:@"请输入姓名" toView:self.view];
        return;
    }
    if (!self.passWordField.text.length) {
        [MBProgressHUD showError:@"请输入密码" toView:self.view];
        return;
    }
    
    if (self.passWordField.text.length < 6 || self.passWordField.text.length > 16 ) {
        [MBProgressHUD showError:@"密码格式不正确" toView:self.view];
        return;
    }
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.loginBL requestRegisterWithCompanyName:self.companyField.text userName:self.nameField.text password:self.passWordField.text telephone:self.telephone inviteCode:self.inviteField.text.length?self.inviteField.text:nil];
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    if (resp.cmdId == HQCMD_userNewRegister) {
        
        if (resp.data[kData]) {
            [self.loginBL requestGetEmployeeInfoAndCompanyInfo]; // 免密注册直接进入系统
        }else{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *res = resp.data[kMyResponse];
            NSString *str = (!IsStrEmpty(res[kDescribe]) && ![res[kDescribe] isEqualToString:@"执行成功"]) ? res[kDescribe] : @"感谢您的注册！相关同事将会对您的信息进行审核，审核通过后会以短信的形式通知到您。" ;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
            [alertView show];
            
        }
        
//        if (self.inviteField.text.length) {
//            [self.loginBL requestGetEmployeeInfoAndCompanyInfo];
//        }else{
        
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"感谢您的注册！相关同事将会对您的信息进行审核，审核通过后会以短信的形式通知到您。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
//            [alertView show];
//            [MBProgressHUD showImageSuccess:@"注册成功" toView:self.view];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//                UIViewController *viewVc = nil;
//                for (UIViewController *vc in self.navigationController.childViewControllers) {
//                    if ([vc isKindOfClass:[HQTFLoginMainController class]]) {
//                        viewVc = vc;
//                    }
//                    if ([vc isKindOfClass:[TFNewLoginController class]]) {
//                        viewVc = vc;
//                    }
//                }
//                [self.navigationController popToViewController:viewVc animated:YES];
//            });
//        }
    }
    
    if (resp.cmdId == HQCMD_getEmployeeAndCompanyInfo) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginSuccess object:@1];
        
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
        UIViewController *viewVc = nil;
        for (UIViewController *vc in self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:[HQTFLoginMainController class]]) {
                viewVc = vc;
            }
            if ([vc isKindOfClass:[TFNewLoginController class]]) {
                viewVc = vc;
            }
        }
        [self.navigationController popToViewController:viewVc animated:YES];
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
