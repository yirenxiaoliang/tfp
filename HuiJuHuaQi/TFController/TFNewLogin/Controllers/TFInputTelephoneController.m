//
//  TFInputTelephoneController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/2/26.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFInputTelephoneController.h"
#import "TFVerificationCodeController.h"
#import "TFLoginBL.h"
#import "WYWebController.h"

@interface TFInputTelephoneController ()<HQBLDelegate>

/** 手机号 */
@property (nonatomic, weak) UITextField *telePhoneField;
/** 下一步 */
@property (nonatomic, weak) UIButton *stepBtn;

/** loginBL */
@property (nonatomic, strong) TFLoginBL *loginBL;

@end

@implementation TFInputTelephoneController

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
    self.loginBL = [TFLoginBL build];
    self.loginBL.delegate = self;
}

- (void)setupChild{
    
    self.view.backgroundColor = WhiteColor;
    
    // label
    UILabel *teleLabel = [[UILabel alloc] initWithFrame:(CGRect){30,42,SCREEN_WIDTH-60,30}];
    [self.view addSubview:teleLabel];
    teleLabel.textColor = BlackTextColor;
    teleLabel.text = NSLocalizedString(@"phone number", nil);
    teleLabel.font = FONT(18);
    
    //telephone
    UITextField *telePhone = [[UITextField alloc]initWithFrame:CGRectMake(30,CGRectGetMaxY(teleLabel.frame) + 30, SCREEN_WIDTH-60, 40)];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Please enter your mobile phone number", nil) attributes:@{ NSForegroundColorAttributeName:LightGrayTextColor,                                            NSFontAttributeName:FONT(14)}];
    [telePhone setAttributedPlaceholder:str];
    telePhone.clearButtonMode = UITextFieldViewModeWhileEditing;
    [telePhone setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    telePhone.font = FONT(16);
//    telePhone.keyboardType = UIKeyboardTypeNumberPad;
    [telePhone addTarget:self action:@selector(textFieldTextChangeAction:) forControlEvents:UIControlEventEditingChanged];
    telePhone.tag = 0x111;
    self.telePhoneField = telePhone;
    telePhone.textColor = BlackTextColor;
    [self.view addSubview:telePhone];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(30,CGRectGetMaxY(telePhone.frame), SCREEN_WIDTH-60, .5)];
    footer.backgroundColor = HexAColor(0xe7e7e7, 1);
    [self.view addSubview:footer];
    
    // 下一步按钮
    UIButton *stepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    stepBtn.frame = CGRectMake(30, CGRectGetMaxY(telePhone.frame) + 52, SCREEN_WIDTH - 60, 50);
    [stepBtn setTitle:NSLocalizedString(@"next step", nil) forState:UIControlStateNormal];
    [stepBtn setTitle:NSLocalizedString(@"next step", nil) forState:UIControlStateHighlighted];
    [stepBtn setTitle:NSLocalizedString(@"next step", nil) forState:UIControlStateSelected];
    
    [stepBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
    [stepBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateHighlighted];
    [stepBtn setBackgroundImage:[HQHelper createImageWithColor:HexAColor(0x3689E9, 0.5)] forState:UIControlStateDisabled];
    stepBtn.enabled = NO;
    [stepBtn addTarget:self action:@selector(stepClicked:) forControlEvents:UIControlEventTouchUpInside];
    stepBtn.titleLabel.font = FONT(20);
    stepBtn.layer.cornerRadius = 4;
    stepBtn.layer.masksToBounds = YES;
    [self.view addSubview:stepBtn];
    self.stepBtn = stepBtn;
    
    // 服务条款
    UILabel *serviceLabel = [[UILabel alloc] initWithFrame:(CGRect){0,self.view.bottom-40-40-64,SCREEN_WIDTH,40}];
    [self.view addSubview:serviceLabel];
    serviceLabel.textAlignment = NSTextAlignmentCenter;
    serviceLabel.userInteractionEnabled = YES;
    NSString *ss = @"点击下一步，即同意《服务条款和隐私政策》";
    NSMutableAttributedString *serStr = [[NSMutableAttributedString alloc] initWithString:ss];
    [serStr addAttribute:NSForegroundColorAttributeName value:BlackTextColor range:(NSRange){0,ss.length}];
    [serStr addAttribute:NSFontAttributeName value:FONT(12) range:(NSRange){0,ss.length}];
    [serStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:[ss rangeOfString:@"《服务条款和隐私政策》"]];
    
    serviceLabel.attributedText = serStr;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(agreeservice)];
    
    [serviceLabel addGestureRecognizer:tap];
    
    if (self.type == 1) {
        serviceLabel.hidden = YES;
    }
}

- (void)textFieldTextChangeAction:(UITextField *)textField{
    
    if ([HQHelper checkTel:textField.text]) {
        
        self.stepBtn.enabled = YES;
    }else{
        self.stepBtn.enabled = NO;
    }
    
}

- (void)stepClicked:(UIButton *)button{
    
    [self.view endEditing:YES];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.type == 0) {// 注册
        
        [self.loginBL requestGetVerificationWithUserName:self.telePhoneField.text type:@1];
        
    }else{// 忘记密码
        
        [self.loginBL requestGetVerificationWithUserName:self.telePhoneField.text type:@2];
    }
    
    
}

- (void)agreeservice {
    
    WYWebController *webVC = [WYWebController new];
    webVC.url = @"https://app.teamface.cn/#/termsService";
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (resp.cmdId == HQCMD_sendVerifyCode) {
        
        
        TFVerificationCodeController *verification = [[TFVerificationCodeController alloc] init];
        verification.telephone = self.telePhoneField.text;
        verification.type = self.type;
        [self.navigationController pushViewController:verification animated:YES];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    [MBProgressHUD showError:resp.errorDescription toView:self.view];
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:resp.errorDescription delegate:self cancelButtonTitle:NSLocalizedString(@"Sure", nil) otherButtonTitles:nil];
    [alert show];
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
