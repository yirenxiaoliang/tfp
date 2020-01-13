//
//  HQReSetPasswordController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/4/13.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQReSetPasswordController.h"
#import "UILabel+Extension.h"
#import "TFPeopleBL.h"
#import "TFLoginBL.h"

@interface HQReSetPasswordController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *nameArr;

@property (nonatomic, strong) NSArray *placeholderArr;


@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UITextField *textField2;

@property (nonatomic, strong) UITextField *textField3;

/** poepleBL */
@property (nonatomic, strong) TFPeopleBL *peopleBL;

/** setDict */
@property (nonatomic, strong) NSDictionary *setDict;
/** loginBL */
@property (nonatomic, strong) TFLoginBL *loginBL;

@end

@implementation HQReSetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigation];
    
    [self createTableView];
 
    [self createBottomView];
    self.loginBL = [TFLoginBL build];
    self.loginBL.delegate = self;
    [self.loginBL requestGetCompanySetWithPhone:UM.userLoginInfo.employee.phone?:self.phone];
    
    self.peopleBL = [TFPeopleBL build];
    self.peopleBL.delegate = self;
    
    _nameArr = @[@"原密码",@"新密码",@"确认密码"];
    _placeholderArr = @[@"请输入原密码",@"请输入新密码",@"请确认新密码"];
}

- (void)setupNavigation {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"修改密码";
    
}

- (void)requestData {

    if (!_textField.text.length) {
        [MBProgressHUD showError:@"原密码不能为空" toView:KeyWindow];
        return;
    }
    
    if (!_textField2.text.length) {
        [MBProgressHUD showError:@"新密码不能为空" toView:KeyWindow];
        return;
    }
    if (!_textField3.text.length) {
        [MBProgressHUD showError:@"确认密码不能为空" toView:KeyWindow];
        return;
    }
    
    if (![_textField2.text isEqualToString:_textField3.text]) {
        [MBProgressHUD showError:@"新密码和确认密码输入不一致" toView:KeyWindow];
        return;
    }
    if (!self.setDict) {
        [MBProgressHUD showError:@"获取密码策略失败" toView:KeyWindow];
        return;
    }
    /** 密码在没有规则时的默认规则：
     长度为6-16个字符
     只能输入数字、字母、特殊符号 */
    if (![self.setDict valueForKey:@"pwd_complex"] || ![self.setDict valueForKey:@"pwd_length"]) {
        
        if (_textField2.text.length < 6) {
            
            [MBProgressHUD showError:[NSString stringWithFormat:@"不符合密码最小长度6位"] toView:KeyWindow];
            return;
        }
        
        if (_textField2.text.length > 16) {
            
            [MBProgressHUD showError:[NSString stringWithFormat:@"默认密码最大长度为16位"] toView:KeyWindow];
            return;
        }
        if (![_textField2.text haveNumberOrAlphabetOrSpecial]) {
            
            [MBProgressHUD showError:@"由字母、数字、特殊字符组成" toView:KeyWindow];
            return;
        }
        
    }
    NSInteger textNum = [[self.setDict valueForKey:@"pwd_length"] integerValue];
    if (_textField2.text.length < textNum) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"密码不少于%ld个字符",textNum] toView:KeyWindow];
        return;
    }
    if (_textField2.text.length > 16) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"默认密码最大长度为16位"] toView:KeyWindow];
        return;
    }
    
    if ([[self.setDict valueForKey:@"pwd_complex"] integerValue] == 0) {
        if (_textField2.text.length < textNum) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"不符合密码最小长度%ld位",textNum] toView:KeyWindow];
            return;
        }
    }else if ([[self.setDict valueForKey:@"pwd_complex"] integerValue] == 1) {
        
        if (![_textField2.text haveNumberAndAlphabet]) {
            [MBProgressHUD showError:@"需包含字母和数字" toView:KeyWindow];
            return;
        }
        
    }else if ([[self.setDict valueForKey:@"pwd_complex"] integerValue] == 2) {
        
        if (![_textField2.text haveNumberAndAlphabetAndSepecialChar]) {
            [MBProgressHUD showError:@"需包含字母和数字及特殊字符" toView:KeyWindow];
            return;
        }
    }else if ([[self.setDict valueForKey:@"pwd_complex"] integerValue] == 3) {
        
        if (![_textField2.text haveNumberAndUpperLowerAlphabet]) {
            [MBProgressHUD showError:@"需包含数字、大小写字母" toView:KeyWindow];
            return;
        }
    }else if ([[self.setDict valueForKey:@"pwd_complex"] integerValue] == 4) {
        
        if (![_textField2.text haveNumberAndUpperLowerAlphabetAndSepecialChar]) {
            [MBProgressHUD showError:@"需包含数字、大小写字母及特殊字符" toView:KeyWindow];
            return;
        }
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *oldPsw = [HQHelper stringForMD5WithString:_textField.text];
    NSString *newPsw = [HQHelper stringForMD5WithString:_textField2.text];
//    NSString *confirmPsw = [HQHelper stringForMD5WithString:_textField3.text];
    
    [self.peopleBL requestModPassWordWithPassWord:oldPsw newPassWord:newPsw];
}

- (void)createTableView {
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [_tableview setBackgroundColor:BackGroudColor];
    _tableview.dataSource=self;
    _tableview.delegate=self;
    _tableview.scrollEnabled = NO;
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableview];
}

- (void)createBottomView {

    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(25, 267-64, SCREEN_WIDTH-50, 50);
    sureBtn.layer.cornerRadius = 4;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:GreenColor];
    [sureBtn addTarget:self action:@selector(modAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
}

- (void)modAction {

    [self requestData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify=@"MySetCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identify];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    else
    {
        for(UIView *vv in cell.subviews)
        {
            [vv removeFromSuperview];
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    UILabel *passwordLab = [UILabel initCustom:CGRectMake(15, 18, 80, 20) title:_nameArr[indexPath.row] titleColor:BlackTextColor titleFont:16 bgColor:HexAColor(0xFFFFFF, 1)];
    passwordLab.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:passwordLab];
    
    if (indexPath.row==0) {
        
        _textField = [[UITextField alloc] init];
        _textField.frame = CGRectMake(101, 5, SCREEN_WIDTH-150, 45);
        _textField.placeholder = _placeholderArr[0];
        _textField.textColor = HexAColor(0xCACAD0, 1);
        _textField.font = [UIFont systemFontOfSize:16];
        _textField.keyboardType = UIKeyboardTypeURL;
        _textField.delegate = self;
        _textField.secureTextEntry = YES;
        [cell addSubview:_textField];
        
        // 显示密码按钮
        UIButton *showPassword = [UIButton buttonWithType:UIButtonTypeCustom];
        showPassword.frame = CGRectMake(SCREEN_WIDTH-45, 0, 40, 55);
        [showPassword setImage:[UIImage imageNamed:@"显示密码green"] forState:UIControlStateSelected];
        [showPassword setImage:[UIImage imageNamed:@"不显示数字"] forState:UIControlStateNormal];
        [showPassword addTarget:self action:@selector(showPasswordClicked:) forControlEvents:UIControlEventTouchUpInside];
        showPassword.tag = 0x123;
        [cell addSubview:showPassword];
    }
    else if (indexPath.row==1) {
    
        _textField2 = [[UITextField alloc] init];
        _textField2.frame = CGRectMake(101, 5, SCREEN_WIDTH-150, 45);
        _textField2.placeholder = _placeholderArr[indexPath.row];
        _textField2.textColor = HexAColor(0xCACAD0, 1);
        _textField2.font = [UIFont systemFontOfSize:16];
        _textField2.keyboardType = UIKeyboardTypeURL;
        _textField2.delegate = self;
        _textField2.secureTextEntry = YES;
        [cell addSubview:_textField2];
        // 显示密码按钮
        UIButton *showPassword = [UIButton buttonWithType:UIButtonTypeCustom];
        showPassword.frame = CGRectMake(SCREEN_WIDTH-45, 0, 40, 55);
        [showPassword setImage:[UIImage imageNamed:@"显示密码green"] forState:UIControlStateSelected];
        [showPassword setImage:[UIImage imageNamed:@"不显示数字"] forState:UIControlStateNormal];
        [showPassword addTarget:self action:@selector(showPasswordClicked:) forControlEvents:UIControlEventTouchUpInside];
        showPassword.tag = 0x456;
        [cell addSubview:showPassword];
        
    }else{
        
        _textField3 = [[UITextField alloc] init];
        _textField3.frame = CGRectMake(101, 5, SCREEN_WIDTH-150, 45);
        _textField3.placeholder = _placeholderArr[indexPath.row];
        _textField3.textColor = HexAColor(0xCACAD0, 1);
        _textField3.font = [UIFont systemFontOfSize:16];
        _textField3.keyboardType = UIKeyboardTypeURL;
        _textField3.secureTextEntry = YES;
        _textField3.delegate = self;
        [cell addSubview:_textField3];
        
        // 显示密码按钮
        UIButton *showPassword = [UIButton buttonWithType:UIButtonTypeCustom];
        showPassword.frame = CGRectMake(SCREEN_WIDTH-45, 0, 40, 55);
        [showPassword setImage:[UIImage imageNamed:@"显示密码green"] forState:UIControlStateSelected];
        [showPassword setImage:[UIImage imageNamed:@"不显示数字"] forState:UIControlStateNormal];
        [showPassword addTarget:self action:@selector(showPasswordClicked:) forControlEvents:UIControlEventTouchUpInside];
        showPassword.tag = 0x789;
        [cell addSubview:showPassword];
    }
    
    //线
    UILabel *bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(16, 55, SCREEN_WIDTH-16, 0.5)];
    
    bottomLine.backgroundColor = CellSeparatorColor;
    [cell addSubview:bottomLine];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor=HexAColor(0xFFFFFF, 1);
    
    return cell;
    
}

- (void)showPasswordClicked:(UIButton *)button{
    
    button.selected = !button.selected;
    if (button.tag == 0x123) {
        _textField.secureTextEntry = !_textField.secureTextEntry;
    }else if (button.tag == 0x456){
        _textField2.secureTextEntry = !_textField2.secureTextEntry;
    }else{
        _textField3.secureTextEntry = !_textField3.secureTextEntry;
    }
    
}

#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (string) {
        if (![string haveNumberOrAlphabetOrSpecial]) {
            [MBProgressHUD showError:@"密码位数字、字母、特殊字符组成" toView:KeyWindow];
            return NO;
        }
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_modPassWrd) {
        
        if (self.action) {
            
            self.action(_textField3.text);
            
        }else{
            
            [MBProgressHUD showImageSuccess:@"修改密码成功" toView:KeyWindow];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    
    if (resp.cmdId == HQCMD_getCompanySet) {
        
        self.setDict = resp.body;
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

@end
