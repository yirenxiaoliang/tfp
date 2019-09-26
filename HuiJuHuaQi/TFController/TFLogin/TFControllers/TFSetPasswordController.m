//
//  TFSetPasswordController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/6/28.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSetPasswordController.h"
#import "TFLoginBL.h"
#import "TFFinishInfoController.h"
#import "HQTFLoginController.h"

@interface TFSetPasswordController ()<HQBLDelegate>
/** UITextField *password */
@property (nonatomic, weak) UITextField *password;

/** UIButton *regiBtn */
@property (nonatomic, weak) UIButton *regiBtn;

/** HQRegisterBL */
@property (nonatomic, strong) TFLoginBL *loginBL;



@end

@implementation TFSetPasswordController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.password becomeFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupChild];
    self.loginBL = [TFLoginBL build];
    self.loginBL.delegate = self;
    
    
    self.navigationItem.title = @"设置密码";
}

- (void)setupChild{
    
    UITextField *password = [[UITextField alloc]initWithFrame:CGRectMake(30,40, SCREEN_WIDTH-60, 40)];
    if (self.type == 0) {
        password.placeholder = @" 请设置登录密码（6位及以上）";
    }else{
        password.placeholder = @" 请设置新登录密码（6位及以上）";
    }
    password.clearButtonMode = UITextFieldViewModeWhileEditing;
    [password setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    password.font = FONT(18);
    [password addTarget:self action:@selector(textFieldTextChangeAction:) forControlEvents:UIControlEventEditingChanged];
    password.secureTextEntry = NO;
    password.tag = 0x333;
    password.layer.cornerRadius = 4;
    password.layer.masksToBounds = YES;
    password.backgroundColor = WhiteColor;
    self.password = password;
    [self.view addSubview:password];
    password.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    // 注册按钮
    UIButton *regiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    regiBtn.frame = CGRectMake(30, CGRectGetMaxY(password.frame) + 20, SCREEN_WIDTH - 60, 50);
    
    [regiBtn setTitle:@"确定" forState:UIControlStateNormal];
    [regiBtn setTitle:@"确定" forState:UIControlStateHighlighted];
    [regiBtn setTitle:@"确定" forState:UIControlStateSelected];
    
    
    [regiBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
    [regiBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateHighlighted];
    [regiBtn setBackgroundImage:[HQHelper createImageWithColor:HexAColor(0xc8c8c8, 1)] forState:UIControlStateDisabled];
    
    [regiBtn addTarget:self action:@selector(regiBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    regiBtn.titleLabel.font = FONT(20);
    regiBtn.layer.cornerRadius = 4;
    regiBtn.layer.masksToBounds = YES;
    //    regiBtn.enabled = NO;
    [self.view addSubview:regiBtn];
    self.regiBtn = regiBtn;
}
- (void)textFieldTextChangeAction:(UITextField *)textField{
    
    
}
- (void)regiBtnClicked:(UIButton *)button{
    
    
    [self.view endEditing:YES];
    
    if (self.type == 0) {
        
        if (self.password.text.length < 6) {
            [MBProgressHUD showError:@"请输入合适密码" toView:self.view];
            return;
        }
        [self.loginBL requestRegisterWithUserName:self.telephone password:self.password.text];
        
    }else{
        
        
        [self.loginBL requestForgetPasswordWithUserName:self.telephone newPassword:self.password.text];
    }
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_userRegister) {
         
        TFFinishInfoController *finish = [[TFFinishInfoController alloc] init];
        finish.type = FinishInfoType_company;
        [self.navigationController pushViewController:finish animated:YES];
    }
    
    if (resp.cmdId == HQCMD_modifyPassWord) {
        
        [MBProgressHUD showError:@"修改成功" toView:self.view];
        
        for (UIViewController *vc in self.navigationController.childViewControllers) {
            
            if ([vc isKindOfClass:[HQTFLoginController class]]) {
                
                [self.navigationController popToViewController:vc animated:NO];
                break;
            }
        }
    }
    
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
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
