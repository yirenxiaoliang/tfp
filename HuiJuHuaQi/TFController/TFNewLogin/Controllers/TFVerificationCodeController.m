//
//  TFVerificationCodeController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/2/26.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFVerificationCodeController.h"
#import "TFLoginBL.h"
#import "TFRegisterController.h"
#import "TFResetPasswordController.h"
#import "HQSetViewController.h"

@interface TFVerificationCodeController ()<HQBLDelegate,UITextViewDelegate>
/** 验证码按钮 */
@property (nonatomic, weak)  UIButton *veriBtn;

/** 下一步 */
@property (nonatomic, weak) UIButton *stepBtn;

/** HQRegisterBL */
@property (nonatomic, strong) TFLoginBL *loginBL;

/** fields */
@property (nonatomic, strong) NSMutableArray *fields;


@end

@implementation TFVerificationCodeController

-(NSMutableArray *)fields{
    if (!_fields) {
        _fields = [NSMutableArray array];
    }
    return _fields;
}

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
    [self startTime];
}

- (void)setupChild{
    
    self.view.backgroundColor = WhiteColor;
    
    // label
    UILabel *teleLabel = [[UILabel alloc] initWithFrame:(CGRect){30,42,SCREEN_WIDTH-60,30}];
    [self.view addSubview:teleLabel];
    teleLabel.textColor = BlackTextColor;
    teleLabel.text = @"输入验证码";
    teleLabel.font = FONT(18);
    
    // 验证码
    NSInteger num = 6;
    CGFloat padding = 30.0;
    CGFloat width = 36.0;
    CGFloat margin = (SCREEN_WIDTH - 2 * padding - num * width)/(num - 1);
    
    for (NSInteger i = 0; i < num; i ++) {
        
        UITextView *telePhone = [[UITextView alloc]initWithFrame:CGRectMake(padding + i * (width + margin),CGRectGetMaxY(teleLabel.frame) + 30, width, width)];
//        [telePhone setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
//        [telePhone setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        telePhone.textAlignment = NSTextAlignmentCenter;
        telePhone.font = FONT(16);
        telePhone.keyboardType = UIKeyboardTypeNumberPad;
//        [telePhone addTarget:self action:@selector(textFieldTextChangeAction:) forControlEvents:UIControlEventEditingChanged];
        telePhone.tag = 0x111 + i;
        telePhone.textColor = BlackTextColor;
        [self.view addSubview:telePhone];
        telePhone.layer.borderColor = HexAColor(0x979797, .6).CGColor;
        telePhone.layer.borderWidth = .5;
        telePhone.delegate = self;
        [self.fields addObject:telePhone];
    }
    
    // 获取验证码按钮
    UIButton *veriBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, teleLabel.y+ 110, 70, 40)];
    [veriBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [veriBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [veriBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [veriBtn setTitle:@"获取验证码" forState:UIControlStateHighlighted];
    [veriBtn addTarget:self action:@selector(getVerificationNum:) forControlEvents:UIControlEventTouchUpInside];
    [veriBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
    veriBtn.titleLabel.font = FONT(12);
    [self.view addSubview:veriBtn];
    veriBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.veriBtn = veriBtn;

    
    
    // 下一步按钮
    UIButton *stepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    stepBtn.frame = CGRectMake(30, CGRectGetMaxY(veriBtn.frame) + 15, SCREEN_WIDTH - 60, 50);
    [stepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [stepBtn setTitle:@"下一步" forState:UIControlStateHighlighted];
    [stepBtn setTitle:@"下一步" forState:UIControlStateSelected];
    
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
    
    if (self.type == 2) {
        [stepBtn setTitle:@"提交" forState:UIControlStateNormal];
        [stepBtn setTitle:@"提交" forState:UIControlStateHighlighted];
        [stepBtn setTitle:@"提交" forState:UIControlStateSelected];
        
        self.navigationItem.title = @"变更手机号码";
    }
}

#pragma mark - UITextFieldDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (text.length == 0) {
        
        if (textView.text.length) {
            
        }else{
            if (textView.tag == 0x111) {// 第一个
                
            }else{
                
                UITextView *field = self.fields[textView.tag-0x111-1];
                [field becomeFirstResponder];
                
            }
        }
    }

    
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    
    
    NSInteger tag = textView.tag - 0x111;
    
    if (textView.text.length > 0) {
        
        textView.text = [textView.text substringFromIndex:textView.text.length-1];
    }
    
    if (tag < self.fields.count-1 && textView.text.length == 1) {
        
        UITextView *field = self.fields[tag+1];
        [field becomeFirstResponder];
    }
    
    BOOL satify = YES;
    for (UITextView *ff in self.fields) {
        
        if (ff.text.length != 1) {
            satify = NO;
        }
    }
    
    self.stepBtn.enabled = satify;
    if (satify) {
        [self.view endEditing:YES];
    }
}

//
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    
//    
//    if (string.length == 0) {
//        
//        if (textField.text.length) {
//            
//        }else{
//            if (textField.tag == 0x111) {// 第一个
//                
//            }else{
//                
//                UITextField *field = self.fields[textField.tag-0x111-1];
//                [field becomeFirstResponder];
//                
//            }
//        }
//    }
//        
//    return YES;
//}
//
//- (void)textFieldTextChangeAction:(UITextField *)textField{
//    
//    NSInteger tag = textField.tag - 0x111;
//    
//    if (textField.text.length > 0) {
//        
//        textField.text = [textField.text substringFromIndex:textField.text.length-1];
//    }
//    
//    if (tag < self.fields.count-1 && textField.text.length == 1) {
//        
//        UITextField *field = self.fields[tag+1];
//        [field becomeFirstResponder];
//    }
//    
//    BOOL satify = YES;
//    for (UITextField *ff in self.fields) {
//        
//        if (ff.text.length != 1) {
//            satify = NO;
//        }
//    }
//    
//    self.stepBtn.enabled = satify;
////    if (satify) {
////        [self.view endEditing:YES];
////    }
//}

- (void)stepClicked:(UIButton *)button{
    
    NSString *str = @"";
    
    for (UITextField *ff in self.fields) {
        
        str = [str stringByAppendingString:ff.text];
    }
    if (str.length != 6) {
        [MBProgressHUD showError:@"请输入验证码" toView:self.view];
        return;
    }
    
    [self.view endEditing:YES];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.type == 0) {// 注册界面
        
        [self.loginBL requestVerificationWithUserName:self.telephone code:str type:@1];
        
    }else if (self.type == 1) {// 忘记密码界面
        
        [self.loginBL requestVerificationWithUserName:self.telephone code:str type:@2];
        
    }else if (self.type == 2) {// 变更手机号
        
        [self.loginBL requestChangeTelephoneWithPhone:self.telephone verifyCode:str];
    }
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (resp.cmdId == HQCMD_verifyVerificationCode) {
        
        if (self.type == 0) {
            
            TFRegisterController *regi = [[TFRegisterController alloc] init];
            regi.telephone = self.telephone;
            [self.navigationController pushViewController:regi animated:YES];
            
        }else{
            TFResetPasswordController *pass = [[TFResetPasswordController alloc] init];
            pass.telephone = self.telephone;
            [self.navigationController pushViewController:pass animated:YES];
        }
    }
    
    if (resp.cmdId == HQCMD_changeTelephone) {
        
        
        
        HQCoreDataManager *coreDataManager = [HQCoreDataManager defaultCoreDataManager];
        [coreDataManager saveEmployeePhone:self.telephone];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            for (UIViewController *vc in self.navigationController.childViewControllers) {
                
                if ([vc isKindOfClass:[HQSetViewController class]]) {
                    
                    [self.navigationController popToViewController:vc animated:YES];
                    break;
                }
            }
        });
        
    }
    
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    [MBProgressHUD showError:resp.errorDescription toView:self.view];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:resp.errorDescription delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
    alert.delegate = self;
    [alert show];
}

/** 开始计数 */
- (void)startTime{
    
    [self timeBtn:self.veriBtn];
    
    if (!self.fields.count) return;
    UITextField *field = self.fields[0];
    [field becomeFirstResponder];
}
/** 重获验证码 */
- (void)getVerificationNum:(UIButton *)button{
    
    
    [self timeBtn:self.veriBtn];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.type == 0) {// 注册
        
        [self.loginBL requestGetVerificationWithUserName:self.telephone type:@1];
        
    }else if (self.type == 1){// 忘记密码
        
        [self.loginBL requestGetVerificationWithUserName:self.telephone type:@2];
    }else if (self.type == 2){// 更改手机号
        
        [self.loginBL requestGetVerificationWithUserName:self.telephone type:@0];
    }
    
    if (!self.fields.count) return;
    UITextField *field = self.fields[0];
    [field becomeFirstResponder];
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
                [button setAttributedTitle:[[NSAttributedString alloc] initWithString:@"重发验证码"] forState:UIControlStateNormal];
                button.width = 70;
                button.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 120;
            NSString *strTime = [NSString stringWithFormat:@"%.2ds ", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                NSString *str = @"后重新发送验证码";
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
