//
//  TFResetPasswordController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/2/26.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFResetPasswordController.h"
#import "TFLoginBL.h"
#import "TFNewLoginController.h"

@interface TFResetPasswordController ()<HQBLDelegate,UITextFieldDelegate>
/** passwordField */
@property (nonatomic, weak) UITextField *passwordField;
/** repasswordField */
@property (nonatomic, weak) UITextField *repasswordField;
/** stepBtn */
@property (nonatomic, weak) UIButton *stepBtn;

/** loginBL */
@property (nonatomic, strong) TFLoginBL *loginBL;
/** setDict */
@property (nonatomic, strong) NSDictionary *setDict;

@end

@implementation TFResetPasswordController


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
    self.navigationItem.title = @"找回密码";
    self.loginBL = [TFLoginBL build];
    self.loginBL.delegate = self;
    
    [self.loginBL requestGetCompanySetWithPhone:self.telephone];
    
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
    company.placeholder = @"请输入6位及以上新密码（必填）";
    company.clearButtonMode = UITextFieldViewModeWhileEditing;
    [company setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    company.font = FONT(18);
    company.keyboardType = UIKeyboardTypeEmailAddress;
    [company addTarget:self action:@selector(textFieldTextChangeAction:) forControlEvents:UIControlEventEditingChanged];
    company.tag = 0x111;
    self.passwordField = company;
    company.delegate = self;
    company.textColor = BlackTextColor;
    [scrollView addSubview:company];
    
    UIView *companyBg = [[UIView alloc] initWithFrame:CGRectMake(30,CGRectGetMaxY(company.frame) , SCREEN_WIDTH-60, .5)];
    companyBg.backgroundColor = HexColor(0xe7e7e7);
    [scrollView addSubview:companyBg];
    
    
    // 姓名
    UITextField *name = [[UITextField alloc]initWithFrame:CGRectMake(30,CGRectGetMaxY(companyBg.frame) + 15, SCREEN_WIDTH-60, 40)];
    name.placeholder = @"重复新密码（必填）";
    name.clearButtonMode = UITextFieldViewModeWhileEditing;
    [name setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    name.font = FONT(18);
    name.keyboardType = UIKeyboardTypeEmailAddress;
    [name addTarget:self action:@selector(textFieldTextChangeAction:) forControlEvents:UIControlEventEditingChanged];
    name.tag = 0x222;
    name.delegate = self;
    self.repasswordField = name;
    name.textColor = BlackTextColor;
    [scrollView addSubview:name];
    
    UIView *nameBg = [[UIView alloc] initWithFrame:CGRectMake(30,CGRectGetMaxY(name.frame) , SCREEN_WIDTH-60, .5)];
    nameBg.backgroundColor = HexColor(0xe7e7e7);
    [scrollView addSubview:nameBg];
    
    
    // 下一步按钮
    UIButton *stepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    stepBtn.frame = CGRectMake(30, CGRectGetMaxY(nameBg.frame) + 30, SCREEN_WIDTH - 60, 50);
    [stepBtn setTitle:@"提交" forState:UIControlStateNormal];
    [stepBtn setTitle:@"提交" forState:UIControlStateHighlighted];
    [stepBtn setTitle:@"提交" forState:UIControlStateSelected];
    
    [stepBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
    [stepBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateHighlighted];
    [stepBtn setBackgroundImage:[HQHelper createImageWithColor:HexAColor(0x3689E9, 0.5)] forState:UIControlStateDisabled];
    stepBtn.enabled = NO;
    [stepBtn addTarget:self action:@selector(stepClicked:) forControlEvents:UIControlEventTouchUpInside];
    stepBtn.titleLabel.font = FONT(20);
    stepBtn.layer.cornerRadius = 4;
    stepBtn.layer.masksToBounds = YES;
    [scrollView addSubview:stepBtn];
    self.stepBtn = stepBtn;
}

- (void)textFieldTextChangeAction:(UITextField *)textfield{
    
    if (textfield.tag == 0x111) {
        
    }else{
        
    }
    
    if (self.passwordField.text.length >= 6 && self.repasswordField.text.length >= 6) {
        
        self.stepBtn.enabled = YES;
    }
    else{
        self.stepBtn.enabled = NO;
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

- (void)stepClicked:(UIButton *)button{
    
    [self.view endEditing:YES];
    
    if (!self.passwordField.text.length) {
        [MBProgressHUD showError:@"新密码不能为空" toView:self.view];
        return;
    }
    if (!self.repasswordField.text.length) {
        [MBProgressHUD showError:@"确认密码不能为空" toView:self.view];
        return;
    }
    if (![self.passwordField.text isEqualToString:self.repasswordField.text]) {
        
        [MBProgressHUD showError:@"新密码和确认密码输入不一致" toView:self.view];
        return;
    }
    
    if (!self.setDict) {
        return;
    }
    
    if (![self.setDict valueForKey:@"pwd_complex"] || ![self.setDict valueForKey:@"pwd_length"]) {
        
        if (self.passwordField.text.length < 6) {
            
            [MBProgressHUD showError:[NSString stringWithFormat:@"不符合密码最小长度6位"] toView:self.view];
            return;
        }
        
        if (self.passwordField.text.length > 16) {
            
            [MBProgressHUD showError:[NSString stringWithFormat:@"默认密码最大长度为16位"] toView:self.view];
            return;
        }
        if (![self.passwordField.text haveNumberOrAlphabetOrSpecial]) {
            
            [MBProgressHUD showError:@"需包含字母和数字及特殊字符" toView:self.view];
            return;
        }
    }
    NSInteger textNum = [[self.setDict valueForKey:@"pwd_length"] integerValue];
    if (self.passwordField.text.length < textNum) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"密码不少于%ld个字符",textNum] toView:self.view];
        return;
    }
    
    if (self.passwordField.text.length > 16) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"默认密码最大长度为16位"] toView:self.view];
        return;
    }
    
    if ([[self.setDict valueForKey:@"pwd_complex"] integerValue] == 0) {
        if (self.passwordField.text.length < textNum) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"不符合密码最小长度%ld位",textNum] toView:self.view];
            return;
        }
    }else if ([[self.setDict valueForKey:@"pwd_complex"] integerValue] == 1) {
        
        if (![self.passwordField.text haveNumberAndAlphabet]) {
            [MBProgressHUD showError:@"需包含字母和数字" toView:self.view];
            return;
        }
        
    }else if ([[self.setDict valueForKey:@"pwd_complex"] integerValue] == 2) {
        
        if (![self.passwordField.text haveNumberAndAlphabetAndSepecialChar]) {
            [MBProgressHUD showError:@"需包含字母和数字及特殊字符" toView:self.view];
            return;
        }
    }else if ([[self.setDict valueForKey:@"pwd_complex"] integerValue] == 3) {
        
        if (![self.passwordField.text haveNumberAndUpperLowerAlphabet]) {
            [MBProgressHUD showError:@"需包含数字、大小写字母" toView:self.view];
            return;
        }
    }else if ([[self.setDict valueForKey:@"pwd_complex"] integerValue] == 4) {
        
        if (![self.passwordField.text haveNumberAndUpperLowerAlphabetAndSepecialChar]) {
            [MBProgressHUD showError:@"需包含数字、大小写字母及特殊字符" toView:self.view];
            return;
        }
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.loginBL requestForgetPasswordWithUserName:self.telephone newPassword:self.passwordField.text];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (resp.cmdId == HQCMD_modifyPassWord) {
        
        // 登录
        [self.loginBL requestLoginWithUserName:self.telephone password:self.passwordField.text userCode:nil];
        
    }

    if (resp.cmdId == HQCMD_userLogin) {
        
        [self.loginBL requestGetEmployeeInfoAndCompanyInfo];
        
    }
    
    if (resp.cmdId == HQCMD_getEmployeeAndCompanyInfo) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginSuccess object:@1];
    }
 
    if (resp.cmdId == HQCMD_getCompanySet) {
        
        self.setDict = resp.body;
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
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
